import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:flutter_vpn/controllers/connection_controller.dart';
import 'package:flutter_vpn/helpers/global.dart';
import 'package:flutter_vpn/utils/constants.dart';
// import 'package:flutter_vpn/widgets/main_drawer.dart';

class MainPage extends StatefulWidget {
  MainPage();

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final bgColorDisconnected = [Color(0xFF000000), Color(0xFFDD473D)];
  final bgColorConnected = [Color(0xFF000000), Color(0xFF37AC53)];
  final bgColorConnecting = [Color(0xFF000000), Color(0xFFCCAD00)];

  var v2rayStatus = ValueNotifier<V2RayStatus>(V2RayStatus());
  late final FlutterV2ray flutterV2ray = FlutterV2ray(
    onStatusChanged: (status) {
      v2rayStatus.value = status;
    },
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget serverConnection(context) {
    return new GestureDetector(
      onTap: null,
      child: new Row(
        children: <Widget>[
          new Container(
            width: screenAwareSize(30.0, context),
            height: screenAwareSize(30.0, context),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: new Border.all(
                width: screenAwareSize(2.0, context),
                color: Colors.white,
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/performance.png'),
                  // ...
                ),
                // ...
              ),
            ),
          ),
          SizedBox(width: screenAwareSize(10.0, context)),
          Text(
            "Fastest Server",
            style: TextStyle(
                color: Colors.white, fontFamily: "Montserrat-SemiBold"),
          ),
          SizedBox(width: screenAwareSize(5.0, context)),
          Icon(Icons.arrow_drop_up, color: Colors.white)
        ],
      ),
    );
  }

  Widget buildUi(BuildContext context, ConnectingStates state) {
    if (state is ConnectionStateConnected) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text(
                "TAP TO\nTURN OFF VPN",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat-SemiBold",
                    fontSize: 16.0),
              ),
              SizedBox(height: screenAwareSize(35.0, context)),
              InkWell(
                onTap: () => context
                    .read<ConnectionController>()
                    .disconnect(flutterV2ray),
                child: Container(
                  width: screenAwareSize(190.0, context),
                  height: screenAwareSize(190.0, context),
                  child: Icon(
                    Icons.power_settings_new,
                    size: screenAwareSize(120.0, context),
                    color: Colors.white,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: screenAwareSize(50.0, context)),
              // serverConnection(context),
            ],
          ))
        ],
      );
    } else if (state is ConnectionStateLoading) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text(
                "CONNECTING",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat-SemiBold",
                    fontSize: 16.0),
              ),
              SizedBox(height: screenAwareSize(35.0, context)),
              SpinKitRipple(
                color: Colors.white,
                size: 190.0,
              ),
              SizedBox(height: screenAwareSize(50.0, context)),
              // serverConnection(context),
            ],
          ))
        ],
      );
    } else if (state is ConnectionStateInitial) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text(
                "TAP TO\nTURN ON VPN",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat-SemiBold",
                    fontSize: 16.0),
              ),
              SizedBox(height: screenAwareSize(35.0, context)),
              InkWell(
                onTap: () => context
                    .read<ConnectionController>()
                    .connect(Global.connectionJsonModel, flutterV2ray),
                child: Container(
                  width: screenAwareSize(190.0, context),
                  height: screenAwareSize(190.0, context),
                  child: Icon(
                    Icons.power_settings_new,
                    size: screenAwareSize(120.0, context),
                    color: Colors.green,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: screenAwareSize(50.0, context)),
              // serverConnection(context),
            ],
          ))
        ],
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConnectionController>(
      create: (context) => ConnectionController(),
      child: BlocConsumer<ConnectionController, ConnectingStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/map-pattern.png"),
                  fit: BoxFit.contain,
                ),
                gradient: LinearGradient(
                    colors: state is ConnectionStateConnected
                        ? bgColorConnected
                        : state is ConnectionStateLoading
                            ? bgColorConnecting
                            : bgColorDisconnected,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    tileMode: TileMode.clamp)),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                // drawer: MainDrawer(),
                appBar: AppBar(
                  iconTheme: new IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  title: Text("VPN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenAwareSize(18.0, context),
                          fontFamily: "Montserrat-Bold")),
                  centerTitle: true,
                ),
                body: buildUi(context, state)),
          );
        },
      ),
    );
  }
}
