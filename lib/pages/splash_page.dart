import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vpn/controllers/authorization_controller.dart';
import 'package:flutter_vpn/utils/constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthorizationController, AuthorizationStates>(
      listener: (context, state) {
        state is AuthorizationStatesAuthorized
            ? Navigator.pushReplacementNamed(context, MAIN_PAGE)
            : Navigator.pushReplacementNamed(context, LOGIN_PAGE);
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator(color: Colors.black,)),
        ),
      ),
    );
  }
}
