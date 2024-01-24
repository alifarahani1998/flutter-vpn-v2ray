class DetailsInfoModel {
  int? daysLeft;
  int? trafficLeft;

  DetailsInfoModel({this.daysLeft, this.trafficLeft});

  DetailsInfoModel.fromJson(Map<String, dynamic> json) {
    daysLeft = json['expire_time'];
    trafficLeft = json['remain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expire_time'] = this.daysLeft;
    data['remain'] = this.trafficLeft;
    return data;
  }
}
