import 'package:youtube/modals/channel_modal.dart';

class Video {
  late final String id;
  late final String title;
  late final String thumbnailUrl;
  late final String channelTitle;

  Video(
      {required this.id,
      required this.title,
      required this.thumbnailUrl,
      required this.channelTitle});

  factory Video.fromMap(Map<String, dynamic> snippet) {
    return Video(
        id: snippet['resourceId']['videoId'],
        title: snippet['title'],
        thumbnailUrl: snippet['thumbnails']['high']['url'],
        channelTitle: snippet['channelTitle']);
  }
}
