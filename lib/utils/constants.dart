import 'package:flutter/material.dart';

double baseHeight = 640.0;

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

// constants
const String moodiboom = 'moodiboom';
const String disconnectedText = 'Your internet is not private';
const String connectedText = 'Your internet is private';
const String connectingText = 'Securing your connection...';
const String TOKEN = 'TOKEN';

// icons & images
const String qr_svg = 'assets/icons/qr.svg';
const String arrow_up = 'assets/icons/arrow_up.svg';
const String calendar = 'assets/icons/calendar.svg';
const String traffic = 'assets/icons/traffic.svg';
const String maskUpRight = 'assets/images/mask_ur.png';
const String maskDownLeft = 'assets/images/mask_dl.png';
const String maskRight = 'assets/images/mask_right.png';
const String disconnectedGlobe = 'assets/images/DisconnectedGlobe.png';
const String connectingGlobe = 'assets/images/ConnectingGlobe.png';
const String connectedGlobe = 'assets/images/ConnectedGlobe.png';

// colors
const Color blackColor = Color(0xFF000000);
const Color baseViewColor = Color(0xFF343434);
const Color errorColor = Color(0xFFE63946);
const Color deepBlueColor = Color(0xFF185BFF);
const Color whiteColor = Color(0xFFF0F5F5);
const Color connectingColor = Color(0xFFFFA133);
const Color baseColor = Color(0xFFCAFD39);

// pages
const String SPLASH_PAGE = "SPLASH_PAGE";
const String MAIN_PAGE = 'MAIN_PAGE';
const String QR_SCANNER_PAGE = 'QR_SCANNER_PAGE';


// global variables
const String jsonReady = '''
{
    "dns": {
        "servers": [
            "8.8.8.8",
            "8.8.4.4",
            "1.1.1.1"
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
                        "address": "storage01.moodiboom.com",
                        "port": 8406,
                        "users": [
                            {
                                "encryption": "none",
                                "flow": "xtls-rprx-vision",
                                "id": "95954773-ab0c-4860-8864-67d2b2222d6a",
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
                    "publicKey": "nIOC91cRHv2CkFF_vPRaByMEQE244-p8HeEQxi1WrzQ",
                    "serverName": "www.zula.ir",
                    "shortId": "212b",
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
                    "8.8.4.4",
                    "8.8.8.8",
                    "1.1.1.1"
                ],
                "outboundTag": "direct",
                "port": "53",
                "type": "field"
            },
            {
                "type": "field",
                "outboundTag": "direct",
                "ip": [
                    "10.0.0.0/8",
                    "172.16.0.0/12",
                    "192.168.0.0/16"
                ]
            },
            {
                "type": "field",
                "outboundTag": "direct",
                "domain": [
                    "regexp:.*\\.ir\$",
                    "digikala.com",
                    "aparat.com",
                    "torob.com",
                    "skyroom.online",
                    "zi-tel.com",
                    "eitaa.com",
                    "filimo.com",
                    "varzesh3.com",
                    "bale.ai",
                    "emofid.com",
                    "yektanet.com",
                    "zhaket.com",
                    "rtl-theme.com",
                    "iranecar.com",
                    "tasnimnews.com",
                    "netafraz.com",
                    "blogfa.com",
                    "basalam.com",
                    "faradars.org",
                    "namasha.com",
                    "taaghche.com",
                    "tgju.org",
                    "telewebion.com",
                    "tarafdari.com",
                    "fidibo.com",
                    "donya-e-eqtesad.com",
                    "mehrnews.com",
                    "parspack.com",
                    "iranserver.com",
                    "mihanwebhost.com",
                    "music-fa.com",
                    "yasdl.com",
                    "sheypoor.com",
                    "maktabkhooneh.org",
                    "arzdigital.com",
                    "banimode.com",
                    "iran-tejarat.com",
                    "irantalent.com",
                    "meghdadit.com",
                    "alopeyk.com",
                    "khanoumi.com"
                ]
            },
            {
                "type": "field",
                "outboundTag": "block",
                "protocol": [
                    "bittorrent"
                ]
            },
            {
                "type": "field",
                "inboundTag": [
                    "socks",
                    "http"
                ],
                "outboundTag": "proxy"
            }
        ]
    }
}
''';
