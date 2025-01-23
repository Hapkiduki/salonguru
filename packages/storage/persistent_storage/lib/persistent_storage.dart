import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

/// {@template persistent_storage}
/// Storage that saves data in the device's persistent memory.
/// {@endtemplate}
class PersistentStorage implements Storage {
  /// {@macro persistent_storage}
  const PersistentStorage({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  /// Returns value for the provided [key] from storage.
  /// Returns `null` if no value is found for the given [key].
  ///
  /// Throws a [StorageException] if the read fails.
  @override
  Future<Object?> read({required String key}) async {
    try {
      return _sharedPreferences.get(key);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }

  /// Writes the provided [key], [value] pair into storage.
  ///
  /// Throws a [StorageException] if the write fails.
  @override
  Future<void> write({required String key, required dynamic value}) async {
    try {
      switch (value) {
        case final int intV:
          await _sharedPreferences.setInt(key, intV);
        case final double doubleV:
          await _sharedPreferences.setDouble(key, doubleV);
        case final String stringV:
          await _sharedPreferences.setString(key, stringV);
        case final bool boolV:
          await _sharedPreferences.setBool(key, boolV);
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }

  /// Removes the value for the provided [key] from storage.
  ///
  /// Throws a [StorageException] if the delete fails.
  @override
  Future<void> delete({required String key}) async {
    try {
      await _sharedPreferences.remove(key);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }

  /// Removes all key, value pairs from storage.
  ///
  /// Throws a [StorageException] if the clear fails.
  @override
  Future<void> clear() async {
    try {
      await _sharedPreferences.clear();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }
}
