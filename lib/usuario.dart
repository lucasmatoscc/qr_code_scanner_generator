// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) {
  final jsonData = json.decode(str);
  return Usuario.fromJson(jsonData);
}

String usuarioToJson(Usuario data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Usuario {
  String data;
  String link;
  String email;

  Usuario({
    this.data,
    this.link,
    this.email,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => new Usuario(
    data: json["data"],
    link: json["link"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "link": link,
    "email": email,
  };
}
