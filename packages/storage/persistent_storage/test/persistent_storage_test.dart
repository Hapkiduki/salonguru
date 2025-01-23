import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

// Create a mock class for SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late PersistentStorage persistentStorage;

  setUpAll(() {
    // Register mocktail fallback values if needed
    registerFallbackValue('');
  });

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    persistentStorage = PersistentStorage(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('PersistentStorage', () {
    test('read returns an existing value', () async {
      // Arrange
      when(() => mockSharedPreferences.get('test_key')).thenReturn('test_value');

      // Act
      final result = await persistentStorage.read(key: 'test_key');

      // Assert
      expect(result, equals('test_value'));
      verify(() => mockSharedPreferences.get('test_key')).called(1);
    });

    test('read throws a StorageException if an internal error occurs', () async {
      // Arrange
      when(() => mockSharedPreferences.get(any())).thenThrow(Exception('Error'));

      // Act & Assert
      expect(
        () => persistentStorage.read(key: 'test_key'),
        throwsA(isA<StorageException>()),
      );
      verify(() => mockSharedPreferences.get('test_key')).called(1);
    });

    test('write with an int calls setInt', () async {
      // Arrange
      when(() => mockSharedPreferences.setInt('test_key', 42)).thenAnswer((_) async => true);

      // Act
      await persistentStorage.write(key: 'test_key', value: 42);

      // Assert
      verify(() => mockSharedPreferences.setInt('test_key', 42)).called(1);
    });

    test('write with a double calls setDouble', () async {
      // Arrange
      when(() => mockSharedPreferences.setDouble('test_key', 3.14)).thenAnswer((_) async => true);

      // Act
      await persistentStorage.write(key: 'test_key', value: 3.14);

      // Assert
      verify(() => mockSharedPreferences.setDouble('test_key', 3.14)).called(1);
    });

    test('write with a String calls setString', () async {
      // Arrange
      when(() => mockSharedPreferences.setString('test_key', 'hello')).thenAnswer((_) async => true);

      // Act
      await persistentStorage.write(key: 'test_key', value: 'hello');

      // Assert
      verify(() => mockSharedPreferences.setString('test_key', 'hello')).called(1);
    });

    test('write with a bool calls setBool', () async {
      // Arrange
      when(() => mockSharedPreferences.setBool('test_key', true)).thenAnswer((_) async => true);

      // Act
      await persistentStorage.write(key: 'test_key', value: true);

      // Assert
      verify(() => mockSharedPreferences.setBool('test_key', true)).called(1);
    });

    test('write throws a StorageException if set fails', () async {
      // Arrange
      when(() => mockSharedPreferences.setInt('test_key', 100)).thenThrow(Exception('Error'));

      // Act & Assert
      expect(
        () => persistentStorage.write(key: 'test_key', value: 100),
        throwsA(isA<StorageException>()),
      );
      verify(() => mockSharedPreferences.setInt('test_key', 100)).called(1);
    });

    test('delete calls remove with the correct key', () async {
      // Arrange
      when(() => mockSharedPreferences.remove('test_key')).thenAnswer((_) async => true);

      // Act
      await persistentStorage.delete(key: 'test_key');

      // Assert
      verify(() => mockSharedPreferences.remove('test_key')).called(1);
    });

    test('delete throws a StorageException if remove fails', () async {
      // Arrange
      when(() => mockSharedPreferences.remove('test_key')).thenThrow(Exception('Error'));

      // Act & Assert
      expect(
        () => persistentStorage.delete(key: 'test_key'),
        throwsA(isA<StorageException>()),
      );
      verify(() => mockSharedPreferences.remove('test_key')).called(1);
    });

    test('clear calls clear', () async {
      // Arrange
      when(() => mockSharedPreferences.clear()).thenAnswer((_) async => true);

      // Act
      await persistentStorage.clear();

      // Assert
      verify(() => mockSharedPreferences.clear()).called(1);
    });

    test('clear throws a StorageException if clear fails', () async {
      // Arrange
      when(() => mockSharedPreferences.clear()).thenThrow(Exception('Error'));

      // Act & Assert
      expect(
        () => persistentStorage.clear(),
        throwsA(isA<StorageException>()),
      );
      verify(() => mockSharedPreferences.clear()).called(1);
    });
  });
}
