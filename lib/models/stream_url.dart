class StreamUrl {
  final String channelId;
  final String url;
  final String? quality;
  final String? userAgent;
  final String? httpReferrer;

  StreamUrl({
    required this.channelId,
    required this.url,
    this.quality,
    this.userAgent,
    this.httpReferrer,
  });

  factory StreamUrl.fromJson(Map<String, dynamic> json) {
    return StreamUrl(
      channelId: json['channel'] ?? '',
      url: json['url'] ?? '',
      quality: json['quality'] as String?,
      userAgent: json['user_agent'] as String?,
      httpReferrer: json['http_referrer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channelId,
      'url': url,
      'quality': quality,
      'user_agent': userAgent,
      'http_referrer': httpReferrer,
    };
  }
}
