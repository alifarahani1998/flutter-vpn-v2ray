import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:flutter_vpn/controllers/authorization_controller.dart';

class MainDrawer extends StatelessWidget {
  final FlutterV2ray flutterV2ray;
  MainDrawer({required this.flutterV2ray});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: Container(
              width: 60,
              height: 60,
              child: Icon(
                Icons.person,
                size: 40,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
            ),
            accountName: Text(
              "user01",
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              "@user01",
              style: TextStyle(color: Colors.white),
            ),
          ),
          new ListTile(
            onTap: () async {
              await flutterV2ray.stopV2Ray();
              context
                  .read<AuthorizationController>()
                  .emit(AuthorizationStatesUnauthorizedAndSignedOut());
            },
            title: Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
            ),
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
