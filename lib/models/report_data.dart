class ReportData {
  final String plate;
  final String issue;
  final String description;
  final List<String> images;

  ReportData({
    required this.plate,
    required this.issue,
    required this.description,
    required this.images,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      plate: json['plate'],
      issue: json['issue'],
      description: json['description'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plate': plate,
      'issue': issue,
      'description': description,
      'images': images,
    };
  }
}
