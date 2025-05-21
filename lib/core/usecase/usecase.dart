import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params);
}


abstract interface class FutureUseCase<FailureType, Params> {
  Future<FailureType> call(Params);
}

class NoParams {}
