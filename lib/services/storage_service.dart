import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final instance = StorageService._init();
  StorageService._init();

  static const storage = FlutterSecureStorage();

  Future<String?> readValue(String key) {
    return storage.read(key: key);
  }

  Future<void> writeValue(String key, String value) {
    return storage.write(key: key, value: value);
  }

  Future<void> removeValue(String key) {
    return storage.delete(key: key);
  }
}