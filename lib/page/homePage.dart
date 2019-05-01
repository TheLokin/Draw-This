import 'dart:io';
import 'package:draw_this/page/cartoonPage.dart';
import 'package:draw_this/page/controllerPage.dart';
import 'package:draw_this/utils/colors.dart';
import 'package:draw_this/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

abstract class HomeInterface {
  void setPicture(File picture);
  void setCartoon(File cartoon);
  void showInSnackBar(String message);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomeInterface {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ControllerInterface _controller;
  File _image;
  File _picture;
  File _cartoon;
  bool _isLoading = false;
  int _requestsPending = 0;
  int _requestsFinished = 0;
  int _currentIndex = 0;
  List<String> _listGallery;

  _HomePageState() {
    _controller = ControllerPage(this);
    _listGallery = _controller.getGallery();
  }

  @override
  Widget build(BuildContext context) {
    if (_cartoon != null && !_listGallery.contains(_cartoon.path)) {
      _image = null;
      _picture = null;
      _cartoon = null;
    }
    if (_listGallery.isEmpty) {
      _currentIndex = 0;
    }
    AppBar appBar = AppBar(
      title: const Text('Draw This'),
      actions: _currentIndex != 0 ||
              _image == null ||
              _isLoading ||
              _requestsPending != _requestsFinished
          ? <Widget>[]
          : <Widget>[
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  _controller.shareCartoon(_cartoon);
                },
              ),
            ],
    );
    var body = _currentIndex == 0
        ? _isLoading || _requestsPending != _requestsFinished
            ? Loader(
                dotOneColor: cDrawThisPrimary,
                dotTwoColor: cDrawThisSecondary,
                dotThreeColor: cDrawThisPrimary,
              )
            : _image == null
                ? Center(
                    child: const Text('Take some picture',
                        textAlign: TextAlign.center, textScaleFactor: 2.0),
                  )
                : GestureDetector(
                    onPanDown: (DragDownDetails details) => setState(() {
                          _image = _picture;
                        }),
                    onPanEnd: (DragEndDetails details) => setState(() {
                          _image = _cartoon;
                        }),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(_image.path),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
        : GridView.builder(
            itemCount: _listGallery.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Card(
                  elevation: 3.0,
                  color: cDrawThisGray,
                  margin: EdgeInsets.all(8.0),
                  child: FadeInImage(
                    alignment: Alignment.center,
                    placeholder: MemoryImage(kTransparentImage),
                    image: AssetImage(_listGallery[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CartoonPage(_controller, _listGallery[index])),
                  );
                },
              );
            },
          );
    FloatingActionButton floatingActionButton = FloatingActionButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
          _requestsPending++;
        });
        _controller.cartoonifyPicture().then((_) {
          setState(() {
            _image = _cartoon;
            _isLoading = false;
            _requestsFinished++;
            _listGallery = _controller.getGallery();
          });
        });
      },
      child: const Icon(Icons.add_a_photo),
    );
    BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.camera_alt),
          title: const Text('Camera'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.collections),
          title: const Text('Gallery'),
        ),
      ],
      iconSize: 30.0,
      currentIndex: _currentIndex,
      onTap: ((index) {
        setState(() {
          _currentIndex = index;
        });
      }),
    );
    return _listGallery.isEmpty
        ? Scaffold(
            key: _scaffoldKey,
            appBar: appBar,
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: floatingActionButton,
          )
        : _currentIndex == 0
            ? Scaffold(
                key: _scaffoldKey,
                appBar: appBar,
                body: body,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: floatingActionButton,
                bottomNavigationBar: bottomNavigationBar,
              )
            : Scaffold(
                key: _scaffoldKey,
                appBar: appBar,
                body: body,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: bottomNavigationBar,
              );
  }

  @override
  void setPicture(File picture) => _picture = picture;

  @override
  void setCartoon(File cartoon) => _cartoon = cartoon;

  @override
  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }
}
