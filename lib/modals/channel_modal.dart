import 'video_modal.dart';

class Channel {
  late final String id;
  late final String title;
  late final String profilePictureUrl;
  late final String subscriberCount;
  late final String videoCount;
  late final String uploadPlayListId;
  late List<Video>? videos;

  Channel(
      {required this.id,
      required this.title,
      required this.profilePictureUrl,
      required this.subscriberCount,
      required this.videoCount,
      required this.uploadPlayListId,
      this.videos});


  Channel.vid({required this.videos});

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
        id: map['id'],
        title: map['snippet']['title'],
        profilePictureUrl: map['snippet']['thumbnails']['url'],
        subscriberCount: map['statistics']['subscriberCount'],
        videoCount: map['statics']['videoCount'],
        uploadPlayListId: map['contentDetails']['relatedPlaylists']['uploads']);
  }



}

