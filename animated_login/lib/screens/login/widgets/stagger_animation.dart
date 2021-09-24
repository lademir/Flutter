import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;

  StaggerAnimation({@required this.controller})
      : buttonSqueeze = Tween<double>(
          begin: 320,
          end: 60,
        ).animate(
            CurvedAnimation(parent: controller, curve: Interval(0.0, 0.150))),
        buttonZoomOut =
            Tween<double>(begin: 60, end: 1000).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.5, 1, curve: Curves.bounceOut),
        ));

  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: InkWell(
          onTap: () {
            controller.forward();
          },
          child: buttonZoomOut.value < 70
              ? Container(
                  width: buttonSqueeze.value,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.pinkAccent.shade100,
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: _buildInside(context),
                )
              : Container(
                  width: buttonZoomOut.value,
                  height: buttonZoomOut.value,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.shade100,
                    shape: buttonZoomOut.value < 500
                        ? BoxShape.circle
                        : BoxShape.rectangle,
                  ),
                ),
        ));
  }

  Widget _buildInside(BuildContext context) {
    if (buttonSqueeze.value > 75) {
      return Text(
        "Sign in",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.3),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}
