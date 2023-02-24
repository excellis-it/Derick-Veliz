class CmsModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  CmsModel({this.status, this.statusCode, this.message, this.data});

  CmsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Cms? cms;

  Data({this.cms});

  Data.fromJson(Map<String, dynamic> json) {
    cms = json['cms'] != null ? new Cms.fromJson(json['cms']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cms != null) {
      data['cms'] = this.cms!.toJson();
    }
    return data;
  }
}

class Cms {
  int? id;
  String? title;
  String? description;
  String? image;

  Cms({this.id, this.title, this.description, this.image});

  Cms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}
