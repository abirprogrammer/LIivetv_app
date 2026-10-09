class FeedModel {
  final String channelId;
  final String url;
  final String? format;
  final String? quality;

  FeedModel({
    required this.channelId,
    required this.url,
    this.format,
    this.quality,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      channelId: json['channel'] ?? '',
      url: json['url'] ?? '',
      format: json['format'] as String?,
      quality: json['quality'] as String?,
    );
  }
}
