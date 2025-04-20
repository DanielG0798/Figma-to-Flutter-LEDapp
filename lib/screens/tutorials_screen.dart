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
  static const _videoIds = [
    'vui4_9kqpoA',
    '_sSh5ui-0kI',
    '0eGXVbAz8n4',
    'oWuYuZZ5-iw',
  ];

  List<TutorialVideo> get _tutorialVideos => _videoIds.map((id) => TutorialVideo(
    id: id,
    thumbnailUrl: 'https://img.youtube.com/vi/$id/maxresdefault.jpg',
    videoUrl: 'https://www.youtube.com/watch?v=$id',
  )).toList();

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
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
          return _VideoCard(
            video: video,
            onTap: () => _launchVideo(video.videoUrl),
          );
        },
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final TutorialVideo video;
  final VoidCallback onTap;

  const _VideoCard({
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                video.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(child: Icon(Icons.error_outline)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<String>(
                future: video.title,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 32,
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
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
  }
} 