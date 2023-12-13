import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vpn/controllers/token_controller.dart';
import 'package:flutter_vpn/utils/constants.dart';
import 'package:flutter_vpn/widgets/loading_button.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bgColorLogin = [Color(0xFF000000), Colors.blue];

  late bool canConfirm;

  final TextEditingController tokenController = new TextEditingController();

  @override
  void initState() {
    canConfirm = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TokenController>(
      create: (context) => TokenController(),
      child: BlocConsumer<TokenController, TokenStates>(
        listener: (context, state) {
          if (state is TokenStateConnected)
            Navigator.pushReplacementNamed(context, MAIN_PAGE);
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
                    colors: bgColorLogin,
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
                body: Stack(children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            onChanged: (value) => setState(() {
                              canConfirm = value.isNotEmpty ? true : false;
                            }),
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
                        ],
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: LoadingButton(
                          text: 'Login',
                          enable: canConfirm && state is! TokenStateLoading,
                          isWaiting: state is TokenStateLoading,
                          callBack: () {
                            FocusScope.of(context).unfocus();
                            context
                                .read<TokenController>()
                                .getConnectionJson(tokenController.text);
                          }),
                    ),
                  )
                ])),
          );
        },
      ),
    );
  }
}
