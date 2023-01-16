import 'dart:convert';

Camera? cameraFromJson(String str) => Camera.fromJson(json.decode(str));

String cameraToJson(Camera? data) => json.encode(data!.toJson());

class Camera {
  Camera({
    this.displayName,
    this.enabled,
    this.id,
    this.name,
    this.channel,
  });

  String? displayName;
  bool? enabled;
  String? id;
  String? name;
  int? channel;

  factory Camera.fromJson(Map<String, dynamic> json) => Camera(
        displayName: json['displayName'],
        enabled: json['enabled'],
        id: json['id'],
        name: json['name'],
        channel: json['channel'],
      );

  Map<String, dynamic> toJson() => {
        'displayNam': displayName,
        'enabled': enabled,
        'id': id,
        'name': name,
        'channel': channel,
      };
}
