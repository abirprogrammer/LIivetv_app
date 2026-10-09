class LogoModel {
  final String channelId;
  final String url;
  final String? format;
  final int? width;
  final int? height;

  LogoModel({
    required this.channelId,
    required this.url,
    this.format,
    this.width,
    this.height,
  });

  factory LogoModel.fromJson(Map<String, dynamic> json) {
    return LogoModel(
      channelId: json['channel'] ?? '',
      url: json['url'] ?? '',
      format: json['format'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }
}
