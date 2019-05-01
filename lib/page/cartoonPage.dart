import 'dart:io';
import 'package:draw_this/page/controllerPage.dart';
import 'package:draw_this/utils/colors.dart';
import 'package:draw_this/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CartoonPage extends StatelessWidget {
  final ControllerInterface _controller;
  final String _cartoonPath;

  CartoonPage(this._controller, this._cartoonPath);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartoon'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _controller.shareCartoon(File(_cartoonPath));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete cartoon'),
                      content: const Text('This action can\'t be undone.'),
                      actions: <Widget>[
                        FlatButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(context);
                          },
                        ),
                        FlatButton(
                          child: const Text(
                            'Remove',
                          ),
                          onPressed: () {
                            _controller.deleteCartoon(_cartoonPath);
                            Navigator.of(context).pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Loader(
          dotOneColor: cDrawThisPrimary,
          dotTwoColor: cDrawThisSecondary,
          dotThreeColor: cDrawThisPrimary,
        ),
        FadeInImage(
          alignment: Alignment.center,
          placeholder: MemoryImage(kTransparentImage),
          image: AssetImage(_cartoonPath),
          fit: BoxFit.fill,
          fadeInDuration: const Duration(milliseconds: 500),
        ),
      ]),
    );
  }
}
