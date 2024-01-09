import 'package:flutter/material.dart';
import 'package:harmony/const/colors.dart';
import 'package:rive/rive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Center(child: Padding(
              padding: const EdgeInsets.only(bottom: 300),
              child: LoadingAnimationWidget.waveDots(color: pColor, size: 100),
            )),
            const RiveAnimation.asset(
              'assets/sw.riv',
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      ),
    );
  }
}
