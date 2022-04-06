import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube/modals/video_modal.dart';
import 'package:youtube/modals/channel_modal.dart';
import 'package:youtube/utilities/keys.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({ required String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    };

    Uri uri = Uri.https(_baseUrl, '/youtube/v3/channels', parameters);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    //Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> data = json.decode(response.body)['item'][0];
      Channel channel = Channel.fromMap(data);

      //fetchfirst batch of vido from uploads playlist
      channel.videos =
          await fetchVideosFromPlayList(playlistId: channel.uploadPlayListId);

      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
  Future<List<Video>> fetchVideosFromPlayList({required String playlistId}) async
  {
    Map<String,String> parameters = {
      'part':'snippet',
      'playlistId': playlistId,
      'maxRestlts': '8',
      'pageToken' : _nextPageToken,
      'key': API_KEY,
    };

    Uri uri =Uri.https(_baseUrl, '/youtube/v3/playlistItems',parameters);

    Map<String,String> headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    //Get playlist videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videoJson = data['item'];

      //Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      videoJson.forEach(
          (json) => videos.add(Video.fromMap(json['snippet'])),
      );
      return videos;

    } else {
      throw json.decode(response.body)['error']['message'];
    }

  }
}
