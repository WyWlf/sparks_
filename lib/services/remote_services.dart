import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sparks/models/post.dart';

class RemoteService {
  final _client = http.Client();
  Future<List<Welcome>?> getPosts() async {
    try {
      final response = await _client.get(
          Uri.parse('https://optimistic-grass-92004.pktriot.net/api/getLabels'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return [Welcome.fromJson(data)];
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      rethrow; // Rethrow to allow error handling at a higher level
    }
  }
}
