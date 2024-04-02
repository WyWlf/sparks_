import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchData() async {
  final response =
      await http.get(Uri.parse('http://192.168.254.104:5173/api/getLabels'));
  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);

    if (jsonBody.isNotEmpty) {
      return jsonBody;
    }
  }
  return [];
}
