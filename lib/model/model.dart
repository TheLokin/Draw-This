import 'dart:io';
import 'package:draw_this/main.dart';

abstract class ModelInterface {
  void create(String path);
  List<String> getAll();
  void delete(String path);
}

class Model implements ModelInterface {
  File _file;
  List<String> _listContent = [];

  Model() {
    _file = File(databasePath);
    if (_file.existsSync()) {
      _listContent = _file
          .readAsStringSync()
          .replaceFirst('[', '')
          .replaceFirst(']', '')
          .split(', ');
      if (_listContent.contains('')) {
        _listContent = [];
      }
    } else {
      _listContent = [];
    }
  }

  @override
  void create(String path) {
    if (File(path).existsSync()) {
      _listContent.add(path);
      if (_file.existsSync()) {
        _file.deleteSync();
      }
      _file.writeAsString(_listContent.toString());
    } else {
      throw IOException;
    }
  }

  @override
  List<String> getAll() {
    return _listContent;
  }

  @override
  void delete(String path) {
    if (_listContent.remove(path)) {
      if (_file.existsSync()) {
        _file.deleteSync();
      }
      _file.writeAsString(_listContent.toString());
    } else {
      throw IOException;
    }
  }
}
