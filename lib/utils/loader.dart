import 'package:flutter/material.dart';
import 'dart:math';

enum DotType { square, circle, diamond, icon }

class Loader extends StatefulWidget {
  final Color dotOneColor;
  final Color dotTwoColor;
  final Color dotThreeColor;
  final Duration duration;
  final DotType dotType;
  final Icon dotIcon;

  Loader(
      {this.dotOneColor = Colors.redAccent,
      this.dotTwoColor = Colors.green,
      this.dotThreeColor = Colors.blueAccent,
      this.duration = const Duration(milliseconds: 1000),
      this.dotType = DotType.circle,
      this.dotIcon = const Icon(Icons.blur_on)});

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  Animation<double> _animation_1;
  Animation<double> _animation_2;
  Animation<double> _animation_3;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation_1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.80, curve: Curves.ease),
      ),
    );
    _animation_2 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.1, 0.9, curve: Curves.ease),
      ),
    );
    _animation_3 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 1.0, curve: Curves.ease),
      ),
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Transform.translate(
            offset: Offset(
              0.0,
              -30 *
                  (_animation_1.value <= 0.50
                      ? _animation_1.value
                      : 1.0 - _animation_1.value),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Dot(
                radius: 10.0,
                color: widget.dotOneColor,
                type: widget.dotType,
                icon: widget.dotIcon,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(
              0.0,
              -30 *
                  (_animation_2.value <= 0.50
                      ? _animation_2.value
                      : 1.0 - _animation_2.value),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Dot(
                radius: 10.0,
                color: widget.dotTwoColor,
                type: widget.dotType,
                icon: widget.dotIcon,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(
              0.0,
              -30 *
                  (_animation_3.value <= 0.50
                      ? _animation_3.value
                      : 1.0 - _animation_3.value),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Dot(
                radius: 10.0,
                color: widget.dotThreeColor,
                type: widget.dotType,
                icon: widget.dotIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;
  final DotType type;
  final Icon icon;

  Dot({this.radius, this.color, this.type, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (type == DotType.icon)
          ? Icon(
              icon.icon,
              color: color,
              size: 1.3 * radius,
            )
          : Transform.rotate(
              angle: type == DotType.diamond ? pi / 4 : 0.0,
              child: Container(
                width: radius,
                height: radius,
                decoration: BoxDecoration(
                    color: color,
                    shape: type == DotType.circle
                        ? BoxShape.circle
                        : BoxShape.rectangle),
              ),
            ),
    );
  }
}
