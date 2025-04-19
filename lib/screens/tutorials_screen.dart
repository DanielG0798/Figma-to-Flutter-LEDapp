import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/tutorial_video.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  // List of YouTube video IDs
  final List<String> _videoIds = [
    'vui4_9kqpoA',  // Never Gonna Give You Up
    '_sSh5ui-0kI',  // Me at the zoo
    '0eGXVbAz8n4',  // Gangnam Style
    'oWuYuZZ5-iw',  // Despacito
  ];

  List<TutorialVideo> get _tutorialVideos => _videoIds.map((id) => TutorialVideo(
    id: id,
    thumbnailUrl: 'https://img.youtube.com/vi/$id/maxresdefault.jpg',
    videoUrl: 'https://www.youtube.com/watch?v=$id',
  )).toList();

  Future<void> _launchYouTubeVideo(String videoUrl) async {
    final Uri url = Uri.parse(videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $videoUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tutorials'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tutorialVideos.length,
        itemBuilder: (context, index) {
          final video = _tutorialVideos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => _launchYouTubeVideo(video.videoUrl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: const Center(
                            child: Icon(Icons.error_outline),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FutureBuilder<String>(
                      future: video.title,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            height: 32,
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        }
                        return Text(
                          snapshot.data ?? 'Loading...',
                          style: theme.textTheme.titleLarge,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 