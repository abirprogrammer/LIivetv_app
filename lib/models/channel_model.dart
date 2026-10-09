import 'stream_url.dart';

class Channel {
  final String id;
  final String name;
  final String? nativeName;
  final String? network;
  final String? country;
  final List<String> languages;
  final List<String> categories;
  final String? logo;
  final String? website;
  final bool isNsfw;
  final List<StreamUrl> streams;

  Channel({
    required this.id,
    required this.name,
    this.nativeName,
    this.network,
    this.country,
    required this.languages,
    required this.categories,
    this.logo,
    this.website,
    this.isNsfw = false,
    this.streams = const [],
  });

  factory Channel.fromJson(Map<String, dynamic> json, {List<StreamUrl>? streams}) {
    List<String> parseList(dynamic val) {
      if (val is List) {
        return val.map((e) => e.toString()).toList();
      }
      return [];
    }

    return Channel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Channel',
      nativeName: json['native_name'] as String?,
      network: json['network'] as String?,
      country: json['country'] as String?,
      languages: parseList(json['languages']),
      categories: parseList(json['categories']),
      logo: json['logo'] as String?,
      website: json['website'] as String?,
      isNsfw: json['is_nsfw'] ?? false,
      streams: streams ?? [],
    );
  }

  String get primaryStreamUrl {
    if (streams.isNotEmpty) {
      return streams.first.url;
    }
    return '';
  }

  bool get hasStream => streams.isNotEmpty && primaryStreamUrl.isNotEmpty;

  String get primaryCategory {
    if (categories.isNotEmpty) {
      final cat = categories.first;
      return cat[0].toUpperCase() + cat.substring(1);
    }
    return 'General';
  }

  Channel copyWith({
    String? id,
    String? name,
    String? nativeName,
    String? network,
    String? country,
    List<String>? languages,
    List<String>? categories,
    String? logo,
    String? website,
    bool? isNsfw,
    List<StreamUrl>? streams,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      network: network ?? this.network,
      country: country ?? this.country,
      languages: languages ?? this.languages,
      categories: categories ?? this.categories,
      logo: logo ?? this.logo,
      website: website ?? this.website,
      isNsfw: isNsfw ?? this.isNsfw,
      streams: streams ?? this.streams,
    );
  }
}
