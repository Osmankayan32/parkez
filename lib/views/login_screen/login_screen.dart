import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/utils/enums.dart';
import 'package:login_screen/views/login_screen/controller/login_screen_controller.dart';
import 'package:login_screen/views/home_screen/home_screen.dart';
import 'package:login_screen/widgets/wating_widgets.dart';
import 'components/center_widget/center_widget.dart';
import 'components/login_content.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {

    final controller = ref.read(loginController);
    controller.init();
    super.initState();
  }

  Widget topWidget(double screenWidth) {
    return Transform.rotate(
      angle: -35 * math.pi / 180,
      child: Container(
        width: 1.2 * screenWidth,
        height: 1.2 * screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: const LinearGradient(
            begin: Alignment(-0.2, -0.8),
            end: Alignment.bottomCenter,
            colors: [
              Color(0x007CBFCF),
              Color(0xB316BFC4),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomWidget(double screenWidth) {
    return Container(
      width: 1.5 * screenWidth,
      height: 1.5 * screenWidth,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(0.6, -1.1),
          end: Alignment(0.7, 0.8),
          colors: [
            Color(0xDB4BE8CC),
            Color(0x005CDBCF),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Consumer(builder: (context, ref, child) {
      final viewState = ref.watch(loginController.select((value) => value.viewState));

      if (viewState == ViewState.busy) {
        return const WatingWidget();
      }
      bool isLogin = ref.watch(loginController.select((value) => value.isSignedIn));

      return isLogin
          ? const HomeScreen()
          : Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    top: -160,
                    left: -30,
                    child: topWidget(screenSize.width),
                  ),
                  Positioned(
                    bottom: -180,
                    left: -40,
                    child: bottomWidget(screenSize.width),
                  ),
                  CenterWidget(size: screenSize),
                  const LoginContent(),
                ],
              ),
            );
    });
  }
}
