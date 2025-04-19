import 'package:http/http.dart' as http;
import 'dart:convert';

class TutorialVideo {
  final String id;
  final String thumbnailUrl;
  final String videoUrl;
  String? _title;

  TutorialVideo({
    required this.id,
    required this.thumbnailUrl,
    required this.videoUrl,
  });

  Future<String> get title async {
    if (_title == null) {
      try {
        final response = await http.get(
          Uri.parse('https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=$id&format=json')
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          _title = data['title'] as String;
        }
      } catch (e) {
        print('Error fetching video title: $e');
      }
      _title ??= 'Video $id';
    }
    return _title!;
  }
} 