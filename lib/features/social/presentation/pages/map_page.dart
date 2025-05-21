import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackmate/core/common/domain/entities/user_entity.dart';
import 'package:trackmate/core/utils/convertors.dart';

import '../bloc/social_bloc.dart';
import '../bloc/social_event.dart';
import '../bloc/social_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController _mapController;
  final List<GeoPoint> _followedUsersLocations = [];
  GeoPoint? _currentUserLocation;
  bool _isInitialMapBoundsSet = false;
  RoadInfo? _selectedRoute;
  bool _isRouteSelected = false;
  RoadType _selectedTransportMode = RoadType.foot;
  GeoPoint? _selectedDestination;
  String _selectedUserUsername = "";
  List<UserEntity> _followedUsers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initMapWithUserPosition: UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
    );
    _initializeMap();
    _loadFollowedUsersLocations();
    _mapController.enableTracking();
  }

  void _loadFollowedUsersLocations() async {
    context.read<SocialBloc>().add(GetFollowingsLocationEvent());
    _isInitialMapBoundsSet = true;
  }

  Future<void> _updateFollowedUsersMarkers(List<UserEntity> users) async {
    await _mapController.removeMarkers(_followedUsersLocations);
    _followedUsersLocations.clear();
    _followedUsers.clear();
    _followedUsers = users;
    for (final user in users) {
      if (user.location != null) {
        _followedUsersLocations.add(
          GeoPoint(
            latitude: user.location!.latitude,
            longitude: user.location!.longitude,
          ),
        );
        await _mapController.addMarker(
          GeoPoint(
            latitude: user.location!.latitude,
            longitude: user.location!.longitude,
          ),
          markerIcon: MarkerIcon(
            iconWidget: CircleAvatar(
              backgroundColor: Colors.white,
              child:
                  user.photoUrl != null
                      ? Image.network(
                        user.photoUrl!,
                        loadingBuilder: (context, child, loadingProgress) {
                          return const CircularProgressIndicator();
                        },
                      )
                      : const Icon(Icons.person, color: Colors.black),
            ),
          ),
        );
      }
    }
    if (_isInitialMapBoundsSet) {
      await _mapController.zoomToBoundingBox(
        BoundingBox.fromGeoPoints([
          ..._followedUsersLocations,
          _currentUserLocation!,
        ]),
      );
    }
    _isInitialMapBoundsSet = false;
  }

  void _handleLocationUpdate(GeoPoint newPosition) {
    if (_currentUserLocation == null) {
      _updateUserLocation(newPosition);
      return;
    }

    final distance = Geolocator.distanceBetween(
      _currentUserLocation!.latitude,
      _currentUserLocation!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    if (distance >= 10) {
      _updateUserLocation(newPosition);
      if (_selectedRoute != null) {
        _selectedDestination = _selectedRoute!.route.last;
        _drawRouteToDestination();
      }
    }
  }

  void _updateUserLocation(GeoPoint position) {
    final newGeoPoint = GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    _currentUserLocation = newGeoPoint;
    context.read<SocialBloc>().add(
      UpdateLocationEvent(
        location: firestore.GeoPoint(
          newGeoPoint.latitude,
          newGeoPoint.longitude,
        ),
      ),
    );
  }

  Future<void> _initializeMap() async {
    try {
      await _mapController.currentLocation();
      _mapController.addMarker(await _mapController.myLocation());
      Geolocator.getCurrentPosition().then(
        (value) =>
            _currentUserLocation = GeoPoint(
              latitude: value.latitude,
              longitude: value.longitude,
            ),
      );
    } catch (e) {
      debugPrint("Error initializing map controller: $e");
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _drawRouteToDestination() async {
    if (_currentUserLocation == null || _selectedDestination == null) return;

    if (_selectedRoute != null) {
      await _mapController.removeRoad(roadKey: _selectedRoute!.key);
    }

    final route = await _mapController.drawRoad(
      _currentUserLocation!,
      _selectedDestination!,
      roadType: _selectedTransportMode,
      roadOption: RoadOption(
        roadWidth: 20,
        zoomInto: true,
        roadColor: Colors.blue,
      ),
    );

    setState(() {
      _selectedRoute = route;
      _selectedUserUsername =
          _followedUsers
              .firstWhere(
                (element) =>
                    element.location!.latitude ==
                        _selectedDestination!.latitude &&
                    element.location!.longitude ==
                        _selectedDestination!.longitude,
              )
              .username!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: !_isRouteSelected,
        child: FloatingActionButton(
          onPressed: () async {
            await _mapController.currentLocation();
          },
          child: const Icon(Icons.gps_fixed),
        ),
      ),
      body: BlocConsumer<SocialBloc, SocialState>(
        listener: (context, state) {
          if (state is GetFollowingsLocationSuccess) {
            _updateFollowedUsersMarkers(state.followings);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                flex: _isRouteSelected ? 3 : 1,
                child: OSMFlutter(
                  onGeoPointClicked: (p0) {
                    _selectedTransportMode = RoadType.foot;
                    _selectedDestination = p0;
                    _drawRouteToDestination();
                    setState(() {
                      _isRouteSelected = true;
                    });
                  },
                  onLocationChanged: (p0) {
                    _handleLocationUpdate(p0);
                  },
                  key: const Key("map-key"),
                  controller: _mapController,
                  osmOption: OSMOption(
                    showZoomController: true,
                    zoomOption: const ZoomOption(
                      initZoom: 35,
                      minZoomLevel: 3,
                      maxZoomLevel: 19,
                      stepZoom: 1.0,
                    ),
                    roadConfiguration: RoadOption(
                      roadColor: Colors.yellowAccent,
                    ),
                  ),
                ),
              ),
              !_isRouteSelected
                  ? Container()
                  : Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_selectedUserUsername),

                              IconButton(
                                style: IconButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  backgroundColor: Colors.grey,
                                ),
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _isRouteSelected = false;
                                    _mapController.removeRoad(
                                      roadKey: _selectedRoute!.key,
                                    );
                                    _selectedRoute = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Tooltip(
                              message: 'پیاده‌روی',
                              child: ElevatedButton(
                                onPressed: () {
                                  _selectedTransportMode = RoadType.foot;
                                  _drawRouteToDestination();
                                },
                                child: Icon(Icons.directions_walk),
                              ),
                            ),
                            Tooltip(
                              message: 'خودرو',
                              child: ElevatedButton(
                                onPressed: () {
                                  _selectedTransportMode = RoadType.car;
                                  _drawRouteToDestination();
                                },
                                child: Icon(Icons.car_crash),
                              ),
                            ),
                            Tooltip(
                              message: 'دوچرخه',
                              child: ElevatedButton(
                                onPressed: () {
                                  _selectedTransportMode = RoadType.bike;
                                  _drawRouteToDestination();
                                },
                                child: Icon(Icons.directions_bike),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "زمان: ${_selectedRoute == null ? "" : formatDuration(_selectedRoute!.duration)}",
                        ),
                        Text(
                          "مسافت: "
                          "${_selectedRoute == null ? "" : formatDistance(_selectedRoute!.distance)}",
                        ),
                      ],
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
