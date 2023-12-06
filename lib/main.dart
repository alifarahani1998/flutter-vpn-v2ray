import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:flutter_vpn/controllers/token_controller.dart';
import 'package:flutter_vpn/pages/main_page.dart';
import 'package:flutter_vpn/pages/splash_page.dart';
import 'package:flutter_vpn/utils/constants.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<TokenController>(
        create: (context) => TokenController()),
  ], child: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, widget) {
          return MultiBlocListener(listeners: [
            BlocListener<TokenController, TokenStates>(
                listener: (context, state) => null),
          ], child: widget!);
        },
        title: "VPN",
        theme: ThemeData(
            primaryColor: Colors.blue[600], primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        initialRoute: SPLASH_PAGE,
        routes: {
          SPLASH_PAGE: (context) => SplashPage(),
          MAIN_PAGE: (context) => MainPage()
        });
  }
}
















class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FlutterV2ray flutterV2ray = FlutterV2ray(
    onStatusChanged: (status) {
      v2rayStatus.value = status;
    },
  );
  final config = TextEditingController();
  String json = '''
                  {
                    "dns": {
                      "hosts": {
                        "domain:googleapis.cn": "googleapis.com"
                      },
                      "servers": [
                        "8.8.8.8"
                      ]
                    },
                    "inbounds": [
                      {
                        "listen": "127.0.0.1",
                        "port": 1080,
                        "protocol": "socks",
                        "settings": {
                          "auth": "noauth",
                          "udp": true,
                          "userLevel": 8
                        },
                        "sniffing": {
                          "destOverride": [
                            "http",
                            "tls"
                          ],
                          "enabled": true
                        },
                        "tag": "socks"
                      },
                      {
                        "listen": "127.0.0.1",
                        "port": 1084,
                        "protocol": "http",
                        "settings": {
                          "userLevel": 8
                        },
                        "tag": "http"
                      }
                    ],
                    "log": {
                      "loglevel": "warning"
                    },
                    "outbounds": [
                      {
                        "mux": {
                          "concurrency": 8,
                          "enabled": false
                        },
                        "protocol": "vless",
                        "settings": {
                          "vnext": [
                            {
                              "address": "stream.manobebar.com",
                              "port": 8443,
                              "users": [
                                {
                                  "encryption": "none",
                                  "flow": "xtls-rprx-vision",
                                  "id": "89177026-d7fb-49ec-ca5d-636c87d04447",
                                  "level": 8,
                                  "security": "auto"
                                }
                              ]
                            }
                          ]
                        },
                        "streamSettings": {
                          "network": "tcp",
                          "realitySettings": {
                            "allowInsecure": false,
                            "fingerprint": "chrome",
                            "publicKey": "4comh-7Jm_wZXJQ5QiLSCbVGQIbMUzHUIBdb0aFtLzM",
                            "serverName": "www.zula.ir",
                            "shortId": "4680",
                            "show": false,
                            "spiderX": ""
                          },
                          "security": "reality",
                          "tcpSettings": {
                            "header": {
                              "type": "none"
                            }
                          }
                        },
                        "tag": "proxy"
                      },
                      {
                        "protocol": "freedom",
                        "settings": {},
                        "tag": "direct"
                      },
                      {
                        "protocol": "blackhole",
                        "settings": {
                          "response": {
                            "type": "http"
                          }
                        },
                        "tag": "block"
                      }
                    ],
                    "routing": {
                      "domainStrategy": "IPIfNonMatch",
                      "rules": [
                        {
                          "ip": [
                            "8.8.8.8"
                          ],
                          "outboundTag": "proxy",
                          "port": "53",
                          "type": "field"
                        }
                      ]
                    }
                  }
                ''';
  bool proxyOnly = false;
  var v2rayStatus = ValueNotifier<V2RayStatus>(V2RayStatus());

  String remark = "Default Remark";

  void connect() async {
    if (await flutterV2ray.requestPermission()) {
      flutterV2ray.startV2Ray(
        remark: remark,
        config: json,
        proxyOnly: proxyOnly,
      );
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission Denied'),
          ),
        );
      }
    }
  }

  void importConfig() async {
    if (await Clipboard.hasStrings()) {
      try {
        final String link =
            (await Clipboard.getData('text/plain'))?.text?.trim() ?? '';
        final V2RayURL v2rayURL = FlutterV2ray.parseFromURL(link);
        remark = v2rayURL.remark;
        json = v2rayURL.getFullConfiguration();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Success',
              ),
            ),
          );
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: $error',
              ),
            ),
          );
        }
      }
    }
  }

  void delay() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${(await flutterV2ray.getServerDelay(config: json))}ms',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    flutterV2ray.initializeV2Ray();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Text(
              'V2Ray Config (json):',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: config,
              maxLines: 10,
              minLines: 10,
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: v2rayStatus,
              builder: (context, value, child) {
                return Column(
                  children: [
                    Text("value.state"),
                    const SizedBox(height: 10),
                    Text("value.duration"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Speed:'),
                        const SizedBox(width: 10),
                        Text("value.uploadSpeed"),
                        const Text('↑'),
                        const SizedBox(width: 10),
                        Text("value.downloadSpeed"),
                        const Text('↓'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Traffic:'),
                        const SizedBox(width: 10),
                        Text("value.upload"),
                        const Text('↑'),
                        const SizedBox(width: 10),
                        Text("value.download"),
                        const Text('↓'),
                      ],
                    )
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  ElevatedButton(
                    onPressed: connect,
                    child: const Text('Connect'),
                  ),
                  ElevatedButton(
                    onPressed: () => flutterV2ray.stopV2Ray(),
                    child: const Text('Disconnect'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => proxyOnly = !proxyOnly),
                    child: Text(proxyOnly ? 'Proxy Only' : 'VPN Mode'),
                  ),
                  ElevatedButton(
                    onPressed: importConfig,
                    child: const Text(
                      'Import from v2ray share link (clipboard)',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: delay,
                    child: const Text('Server Delay'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
