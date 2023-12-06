import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vpn/controllers/token_controller.dart';
import 'package:flutter_vpn/models/token_model.dart';
import 'package:flutter_vpn/utils/constants.dart';

class SplashPage extends StatelessWidget {
  SplashPage();

  final bgColorSplash = [Color(0xFF000000), Colors.blue];

  final TextEditingController tokenController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TokenController>(
      create: (context) => TokenController(),
      child: BlocConsumer<TokenController, TokenStates>(
        listener: (context, state) {
          if (state is TokenStateConnected)
            Navigator.pushReplacementNamed(context, MAIN_PAGE, arguments: {'json': context.read<TokenController>().connectionJson});
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/map-pattern.png"),
                  fit: BoxFit.contain,
                ),
                gradient: LinearGradient(
                    colors: bgColorSplash,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    tileMode: TileMode.clamp)),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  iconTheme: new IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  title: Text("VPN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenAwareSize(18.0, context),
                          fontFamily: "Montserrat-Bold")),
                  centerTitle: true,
                ),
                body: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          controller: tokenController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Token",
                            labelStyle: TextStyle(color: Colors.white),
                            suffixIcon: Icon(
                              Icons.key,
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            hintText: "Enter the token to proceed",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () => context
                              .read<TokenController>()
                              .getConnectionJson(TokenModel(token: tokenController.text)),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white))),
                          ),
                          child: Text(
                            'Confirm',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ))),
          );
        },
      ),
    );
  }
}
