import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_flash_chat_project/components/materialbutton.dart';
import 'package:flutter_flash_chat_project/screens/login_screen.dart';
import 'package:flutter_flash_chat_project/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'WelcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animecontr;
  Animation animation;

  @override
  void initState() {
    super.initState();
    animecontr =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animecontr.forward();
    animation =
        ColorTween(begin: Colors.red, end: Colors.white).animate(animecontr);
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            materialbutton(
                color: Colors.lightBlueAccent,
                onpress: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                title: Text(
                  'Log In',
                )),
            materialbutton(
                color: Colors.blueAccent,
                onpress: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                title: Text(
                  'Register',
                )),
          ],
        ),
      ),
    );
  }
}
