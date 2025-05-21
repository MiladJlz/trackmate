String formatDuration(double? seconds) {
  if (seconds == null) return '';
  int totalSeconds = seconds.round();
  if (totalSeconds < 60) {
    return '$totalSeconds ثانیه';
  }
  int minutes = totalSeconds ~/ 60;
  if (minutes < 60) {
    return '$minutes دقیقه';
  }
  int hours = minutes ~/ 60;
  minutes = minutes % 60;
  return '$hours ساعت و $minutes دقیقه';
}

String formatDistance(double? kilometers) {
  if (kilometers == null) return '';

  if (kilometers < 1) {
    return '${(kilometers * 1000).round()} متر';
  }

  int wholeKilometers = kilometers.floor();
  int remainingMeters = ((kilometers - wholeKilometers) * 1000).round();

  if (remainingMeters == 0) {
    return '$wholeKilometers کیلومتر';
  }

  return '$wholeKilometers کیلومتر و $remainingMeters متر';
}
