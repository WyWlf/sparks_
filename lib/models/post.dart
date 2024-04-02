import 'dart:convert';
import 'dart:typed_data';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  List<Row> row;

  Welcome({
    required this.row,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        row: List<Row>.from(json["row"].map((x) => Row.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "row": List<dynamic>.from(row.map((x) => x.toJson())),
      };
}

class Row {
  int id;
  int parkingId;
  String sectionName;
  int labelCount;
  String? sectionImg; // Made nullable to handle cases without image data
  String? sectionLabels;
  String? cameraId;
  String? type;

  Row({
    required this.id,
    required this.parkingId,
    required this.sectionName,
    required this.labelCount,
    required this.sectionImg,
    this.sectionLabels,
    this.cameraId,
    this.type,
  });

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        id: json["id"],
        parkingId: json["parking_id"],
        sectionName: json["section_name"],
        labelCount: json["label_count"],
        sectionImg: json["section_img"],
        sectionLabels: json["section_labels"],
        cameraId: json["cameraId"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parking_id": parkingId,
        "section_name": sectionName,
        "label_count": labelCount,
        "section_labels": sectionLabels,
        "cameraId": cameraId,
        "type": type,
      };
}
