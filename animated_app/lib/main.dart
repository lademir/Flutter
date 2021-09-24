import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Animations Intro",
      debugShowCheckedModeBanner: false,
      home: LogoApp(),
    );
  }
}

class LogoApp extends StatefulWidget {
  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;


  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = CurvedAnimation(
        parent: controller,
        curve: Curves.elasticInOut
    );
    animation.addStatusListener((status) {
      print(status);
      if(status == AnimationStatus.completed){
        controller.reverse();
      } else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transition(
        child: LogoWidget(),
        animation: animation,
    );
  }
}

class LogoWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterLogo(),
    );
  }
}

class Transition extends StatelessWidget {

  final Widget child;
  final Animation<double> animation;
  final sizeTween = Tween<double>(begin: 0, end: 300);
  final opacityTween = Tween<double>(begin: 0.1, end: 1);


  Transition({@required this.child, @required this.animation});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child){
          return Opacity(
            opacity: opacityTween.evaluate(animation).clamp(0.0, 1.0),
            child: Container(
              height: sizeTween.evaluate(animation).clamp(0.0, 1000.0),
              width: sizeTween.evaluate(animation).clamp(0.0, 1000.0),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}



