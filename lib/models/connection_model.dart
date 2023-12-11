class ConnectionJsonModel {
  Dns? dns;
  List<Inbounds>? inbounds;
  Log? log;
  List<Outbounds>? outbounds;
  Routing? routing;

  ConnectionJsonModel(
      {this.dns, this.inbounds, this.log, this.outbounds, this.routing});

  ConnectionJsonModel.fromJson(Map<String, dynamic> json) {
    dns = json['dns'] != null ? new Dns.fromJson(json['dns']) : null;
    if (json['inbounds'] != null) {
      inbounds = <Inbounds>[];
      json['inbounds'].forEach((v) {
        inbounds!.add(new Inbounds.fromJson(v));
      });
    }
    log = json['log'] != null ? new Log.fromJson(json['log']) : null;
    if (json['outbounds'] != null) {
      outbounds = <Outbounds>[];
      json['outbounds'].forEach((v) {
        outbounds!.add(new Outbounds.fromJson(v));
      });
    }
    routing =
        json['routing'] != null ? new Routing.fromJson(json['routing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dns != null) {
      data['dns'] = this.dns!.toJson();
    }
    if (this.inbounds != null) {
      data['inbounds'] = this.inbounds!.map((v) => v.toJson()).toList();
    }
    if (this.log != null) {
      data['log'] = this.log!.toJson();
    }
    if (this.outbounds != null) {
      data['outbounds'] = this.outbounds!.map((v) => v.toJson()).toList();
    }
    if (this.routing != null) {
      data['routing'] = this.routing!.toJson();
    }
    return data;
  }
}

class Dns {
  Hosts? hosts;
  List<String>? servers;

  Dns({this.hosts, this.servers});

  Dns.fromJson(Map<String, dynamic> json) {
    hosts = json['hosts'] != null ? new Hosts.fromJson(json['hosts']) : null;
    servers = json['servers'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hosts != null) {
      data['hosts'] = this.hosts!.toJson();
    }
    data['servers'] = this.servers;
    return data;
  }
}

class Hosts {
  String? domainGoogleapisCn;

  Hosts({this.domainGoogleapisCn});

  Hosts.fromJson(Map<String, dynamic> json) {
    domainGoogleapisCn = json['domain:googleapis.cn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domain:googleapis.cn'] = this.domainGoogleapisCn;
    return data;
  }
}

class Inbounds {
  String? listen;
  int? port;
  String? protocol;
  InboundSettings? settings;
  Sniffing? sniffing;
  String? tag;

  Inbounds(
      {this.listen,
      this.port,
      this.protocol,
      this.settings,
      this.sniffing,
      this.tag});

  Inbounds.fromJson(Map<String, dynamic> json) {
    listen = json['listen'];
    port = json['port'];
    protocol = json['protocol'];
    settings = json['settings'] != null
        ? new InboundSettings.fromJson(json['settings'])
        : null;
    sniffing = json['sniffing'] != null
        ? new Sniffing.fromJson(json['sniffing'])
        : null;
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listen'] = this.listen;
    data['port'] = this.port;
    data['protocol'] = this.protocol;
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    if (this.sniffing != null) {
      data['sniffing'] = this.sniffing!.toJson();
    }
    data['tag'] = this.tag;
    return data;
  }
}

class InboundSettings {
  String? auth;
  bool? udp;
  int? userLevel;

  InboundSettings({this.auth, this.udp, this.userLevel});

  InboundSettings.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
    udp = json['udp'];
    userLevel = json['userLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this.auth;
    data['udp'] = this.udp;
    data['userLevel'] = this.userLevel;
    return data;
  }
}

class Sniffing {
  List<String>? destOverride;
  bool? enabled;

  Sniffing({this.destOverride, this.enabled});

  Sniffing.fromJson(Map<String, dynamic> json) {
    destOverride = json['destOverride'].cast<String>();
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['destOverride'] = this.destOverride;
    data['enabled'] = this.enabled;
    return data;
  }
}

class Log {
  String? loglevel;

  Log({this.loglevel});

  Log.fromJson(Map<String, dynamic> json) {
    loglevel = json['loglevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loglevel'] = this.loglevel;
    return data;
  }
}

class Outbounds {
  Mux? mux;
  String? protocol;
  Settings? settings;
  StreamSettings? streamSettings;
  String? tag;

  Outbounds(
      {this.mux, this.protocol, this.settings, this.streamSettings, this.tag});

  Outbounds.fromJson(Map<String, dynamic> json) {
    mux = json['mux'] != null ? new Mux.fromJson(json['mux']) : null;
    protocol = json['protocol'];
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
    streamSettings = json['streamSettings'] != null
        ? new StreamSettings.fromJson(json['streamSettings'])
        : null;
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mux != null) {
      data['mux'] = this.mux!.toJson();
    }
    data['protocol'] = this.protocol;
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    if (this.streamSettings != null) {
      data['streamSettings'] = this.streamSettings!.toJson();
    }
    data['tag'] = this.tag;
    return data;
  }
}

class Mux {
  int? concurrency;
  bool? enabled;

  Mux({this.concurrency, this.enabled});

  Mux.fromJson(Map<String, dynamic> json) {
    concurrency = json['concurrency'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['concurrency'] = this.concurrency;
    data['enabled'] = this.enabled;
    return data;
  }
}

class Settings {
  List<Vnext>? vnext;
  Response? response;

  Settings({this.vnext, this.response});

  Settings.fromJson(Map<String, dynamic> json) {
    if (json['vnext'] != null) {
      vnext = <Vnext>[];
      json['vnext'].forEach((v) {
        vnext!.add(new Vnext.fromJson(v));
      });
    }
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vnext != null) {
      data['vnext'] = this.vnext!.map((v) => v.toJson()).toList();
    }
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Vnext {
  String? address;
  int? port;
  List<Users>? users;

  Vnext({this.address, this.port, this.users});

  Vnext.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    port = json['port'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['port'] = this.port;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? encryption;
  String? flow;
  String? id;
  int? level;
  String? security;

  Users({this.encryption, this.flow, this.id, this.level, this.security});

  Users.fromJson(Map<String, dynamic> json) {
    encryption = json['encryption'];
    flow = json['flow'];
    id = json['id'];
    level = json['level'];
    security = json['security'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['encryption'] = this.encryption;
    data['flow'] = this.flow;
    data['id'] = this.id;
    data['level'] = this.level;
    data['security'] = this.security;
    return data;
  }
}

class Response {
  String? type;

  Response({this.type});

  Response.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    return data;
  }
}

class StreamSettings {
  String? network;
  RealitySettings? realitySettings;
  String? security;
  TcpSettings? tcpSettings;

  StreamSettings(
      {this.network, this.realitySettings, this.security, this.tcpSettings});

  StreamSettings.fromJson(Map<String, dynamic> json) {
    network = json['network'];
    realitySettings = json['realitySettings'] != null
        ? new RealitySettings.fromJson(json['realitySettings'])
        : null;
    security = json['security'];
    tcpSettings = json['tcpSettings'] != null
        ? new TcpSettings.fromJson(json['tcpSettings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['network'] = this.network;
    if (this.realitySettings != null) {
      data['realitySettings'] = this.realitySettings!.toJson();
    }
    data['security'] = this.security;
    if (this.tcpSettings != null) {
      data['tcpSettings'] = this.tcpSettings!.toJson();
    }
    return data;
  }
}

class RealitySettings {
  bool? allowInsecure;
  String? fingerprint;
  String? publicKey;
  String? serverName;
  String? shortId;
  bool? show;
  String? spiderX;

  RealitySettings(
      {this.allowInsecure,
      this.fingerprint,
      this.publicKey,
      this.serverName,
      this.shortId,
      this.show,
      this.spiderX});

  RealitySettings.fromJson(Map<String, dynamic> json) {
    allowInsecure = json['allowInsecure'];
    fingerprint = json['fingerprint'];
    publicKey = json['publicKey'];
    serverName = json['serverName'];
    shortId = json['shortId'];
    show = json['show'];
    spiderX = json['spiderX'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allowInsecure'] = this.allowInsecure;
    data['fingerprint'] = this.fingerprint;
    data['publicKey'] = this.publicKey;
    data['serverName'] = this.serverName;
    data['shortId'] = this.shortId;
    data['show'] = this.show;
    data['spiderX'] = this.spiderX;
    return data;
  }
}

class TcpSettings {
  Response? header;

  TcpSettings({this.header});

  TcpSettings.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Response.fromJson(json['header']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header!.toJson();
    }
    return data;
  }
}

class Routing {
  String? domainStrategy;
  List<Rules>? rules;

  Routing({this.domainStrategy, this.rules});

  Routing.fromJson(Map<String, dynamic> json) {
    domainStrategy = json['domainStrategy'];
    if (json['rules'] != null) {
      rules = <Rules>[];
      json['rules'].forEach((v) {
        rules!.add(new Rules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domainStrategy'] = this.domainStrategy;
    if (this.rules != null) {
      data['rules'] = this.rules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rules {
  List<String>? ip;
  String? outboundTag;
  String? port;
  String? type;

  Rules({this.ip, this.outboundTag, this.port, this.type});

  Rules.fromJson(Map<String, dynamic> json) {
    ip = json['ip'].cast<String>();
    outboundTag = json['outboundTag'];
    port = json['port'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ip'] = this.ip;
    data['outboundTag'] = this.outboundTag;
    data['port'] = this.port;
    data['type'] = this.type;
    return data;
  }
}
