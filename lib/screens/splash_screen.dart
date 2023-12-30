import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviereviews/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });

    _animationController.forward();
  }

  void _navigateToNextScreen() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MovieScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Check if the animation controller is attached before disposing it
    if (_animationController.isAnimating) {
      _animationController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Container(width: 100, height: 100, child: Image.asset('assets/images/mr.png'))),
            SizedBox(height: 10),
            Text("Movie Reviews", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(153, 18, 18, 18))),
            SizedBox(height: 100),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}