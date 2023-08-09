import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:module_11_live_class/Api/models/auth_utility.dart';
import 'package:module_11_live_class/UI/screens/auth/loginScreen.dart';
import 'package:module_11_live_class/UI/screens/bottom_Nev_BaseScreen.dart';
import 'package:module_11_live_class/UI/utils/assets-utils.dart';

import '../../Wigdets/Screen_Backgroud.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
void initState(){
  super.initState();
  navigateToLogin();
}


  Future<void> navigateToLogin() async {
  Future.delayed(const Duration(seconds: 5)).then((_) async {
    final bool isLoggedIn = await Authutility.checkIfLoggedIn();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
            isLoggedIn
                ? const BottomNevBaseScreen()
                : const LoginScreen(),
          ),
              (route) => false);
    }
  });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Center(
            child:SvgPicture.asset(
              AssetsUtils.logoSVG,fit: BoxFit.scaleDown,) ,
      )),
    );
  }
}

