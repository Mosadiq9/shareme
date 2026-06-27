/// ShareMe — Local Settings Repository Implementation.
///
/// Reads and updates app configuration in Drift SQLite table.
library;

import 'package:fpdart/fpdart.dart';
import 'package:shareme/core/data/local/daos/settings_dao.dart';
import 'package:shareme/core/errors/failures.dart';
import 'package:shareme/features/settings/domain/settings_repository.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._dao);

  final SettingsDao _dao;

  @override
  Stream<String> watchDeviceName() {
    return _dao.watchSetting('device_name').map((val) => val ?? 'ShareMe Device');
  }

  @override
  Future<Either<Failure, void>> updateDeviceName(String newName) async {
    try {
      await _dao.saveSetting('device_name', newName);
      return const Right(null);
    } on Object catch (e, st) {
      return Left(StorageFailure(message: 'Failed to update setting: $e', stackTrace: st));
    }
  }
}
