/// ShareMe — Settings Repository Interface.
///
/// Follows Clean Architecture standards for device settings reading & writing.
library;

import 'package:fpdart/fpdart.dart';
import 'package:shareme/core/errors/failures.dart';

abstract interface class SettingsRepository {
  /// Watch live device display name setting.
  Stream<String> watchDeviceName();

  /// Update display name setting.
  Future<Either<Failure, void>> updateDeviceName(String newName);
}
