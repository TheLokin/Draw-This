import 'dart:convert';
import 'dart:io';
import 'package:advanced_share/advanced_share.dart';
import 'package:draw_this/main.dart';
import 'package:draw_this/model/model.dart';
import 'package:draw_this/page/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

abstract class ControllerInterface {
  Future cartoonifyPicture();
  Future shareCartoon(File cartoon);
  List<String> getGallery();
  void deleteCartoon(String cartoonPath);
}

class ControllerPage implements ControllerInterface {
  final HomeInterface _home;
  final ModelInterface _model = Model();

  ControllerPage(this._home);

  @override
  Future cartoonifyPicture() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      var imageAsBytes = image.readAsBytesSync();
      var request = http.MultipartRequest(
          "POST", Uri.parse('http://127.0.0.1:5000/cartoon'));
      var inputFile = http.MultipartFile.fromBytes('image', imageAsBytes,
          filename: 'image.jpg');
      var outputFile;
      request.files.add(inputFile);
      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseStr = await response.stream.bytesToString();
          var data = jsonDecode(responseStr);
          var cartoon = data['cartoon'];
          if (cartoon != null) {
            outputFile = File(
                '$storagePath/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
            var imageResponse = base64.decode(cartoon);
            await outputFile.writeAsBytes(imageResponse);
            _home.setPicture(image);
            _home.setCartoon(outputFile);
            _model.create(outputFile.path);
          } else {
            _home.showInSnackBar('Something was wrong.');
          }
        }
      } catch (e) {
        print(e);
        _home.showInSnackBar('Server not available.');
      }
    } catch (_) {}
  }

  @override
  Future shareCartoon(File cartoon) async {
    AdvancedShare.generic(
            msg: "Draw This",
            url: "data:image/png;base64," +
                base64.encode(cartoon.readAsBytesSync()))
        .then((response) {
      if (response != 1) {
        _home.showInSnackBar('Something was wrong.');
      }
    });
  }

  @override
  List<String> getGallery() {
    return _model.getAll();
  }

  @override
  void deleteCartoon(String cartoonPath) {
    _model.delete(cartoonPath);
  }
}
