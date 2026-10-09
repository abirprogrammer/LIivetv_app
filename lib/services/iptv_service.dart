import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/channel_model.dart';
import '../models/stream_url.dart';
import '../models/category_model.dart';
import '../models/feed_model.dart';
import '../models/logo_model.dart';

class IptvService {
  static const List<String> _channelsUrls = [
    'https://iptv-org.github.io/api/channels.json',
    'https://cdn.jsdelivr.net/gh/iptv-org/api@gh-pages/channels.json',
    'https://raw.githubusercontent.com/iptv-org/api/gh-pages/channels.json',
  ];

  static const List<String> _streamsUrls = [
    'https://iptv-org.github.io/api/streams.json',
    'https://cdn.jsdelivr.net/gh/iptv-org/api@gh-pages/streams.json',
    'https://raw.githubusercontent.com/iptv-org/api/gh-pages/streams.json',
  ];

  static const List<String> _categoriesUrls = [
    'https://iptv-org.github.io/api/categories.json',
    'https://cdn.jsdelivr.net/gh/iptv-org/api@gh-pages/categories.json',
    'https://raw.githubusercontent.com/iptv-org/api/gh-pages/categories.json',
  ];

  static const List<String> _logosUrls = [
    'https://iptv-org.github.io/api/logos.json',
    'https://cdn.jsdelivr.net/gh/iptv-org/api@gh-pages/logos.json',
    'https://raw.githubusercontent.com/iptv-org/api/gh-pages/logos.json',
  ];

  static const List<String> _feedsUrls = [
    'https://iptv-org.github.io/api/feeds.json',
    'https://cdn.jsdelivr.net/gh/iptv-org/api@gh-pages/feeds.json',
    'https://raw.githubusercontent.com/iptv-org/api/gh-pages/feeds.json',
  ];

  static const Map<String, String> _requestHeaders = {
    'User-Agent': 'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
    'Accept': 'application/json, text/plain, */*',
    'Accept-Encoding': 'gzip, deflate',
  };

  // Fallback / Featured Channels with high-reliability live streams
  static final List<Channel> _featuredFallbackChannels = [
    Channel(
      id: 'AlJazeeraEnglish.qa',
      name: 'Al Jazeera English',
      network: 'Al Jazeera Media Network',
      country: 'QA',
      languages: ['eng'],
      categories: ['news'],
      logo: 'https://upload.wikimedia.org/wikipedia/en/thumb/7/75/Al_Jazeera_English_logo.svg/1200px-Al_Jazeera_English_logo.svg.png',
      website: 'https://www.aljazeera.com',
      streams: [
        StreamUrl(
          channelId: 'AlJazeeraEnglish.qa',
          url: 'https://live-hls-web-aje.getaj.net/AJE/index.m3u8',
          quality: '1080p',
        ),
      ],
    ),
    Channel(
      id: 'DWEnglish.de',
      name: 'DW English',
      network: 'Deutsche Welle',
      country: 'DE',
      languages: ['eng'],
      categories: ['news'],
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Deutsche_Welle_logo.svg/1024px-Deutsche_Welle_logo.svg.png',
      website: 'https://www.dw.com',
      streams: [
        StreamUrl(
          channelId: 'DWEnglish.de',
          url: 'https://dwamdstream102.akamaized.net/hls/live/2015525/dwstream102/index.m3u8',
          quality: '1080p',
        ),
      ],
    ),
    Channel(
      id: 'France24English.fr',
      name: 'France 24 English',
      network: 'France Médias Monde',
      country: 'FR',
      languages: ['eng'],
      categories: ['news'],
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/France24_2013_logo.svg/1200px-France24_2013_logo.svg.png',
      website: 'https://www.france24.com',
      streams: [
        StreamUrl(
          channelId: 'France24English.fr',
          url: 'https://static.france24.com/live/F24_EN_LO_HLS/live_tv.m3u8',
          quality: '720p',
        ),
      ],
    ),
    Channel(
      id: 'RedBullTV.us',
      name: 'Red Bull TV',
      network: 'Red Bull',
      country: 'US',
      languages: ['eng'],
      categories: ['sports', 'entertainment'],
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Red_Bull_TV_logo.svg/1200px-Red_Bull_TV_logo.svg.png',
      website: 'https://www.redbull.com/tv',
      streams: [
        StreamUrl(
          channelId: 'RedBullTV.us',
          url: 'https://rbmn-live.akamaized.net/hls/live/591232/FL_LIVE_3/master_1080p.m3u8',
          quality: '1080p',
        ),
      ],
    ),
    Channel(
      id: 'NASATV.us',
      name: 'NASA TV Public',
      network: 'NASA',
      country: 'US',
      languages: ['eng'],
      categories: ['science', 'education'],
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/NASA_logo.svg/1200px-NASA_logo.svg.png',
      website: 'https://www.nasa.gov/multimedia/nasatv',
      streams: [
        StreamUrl(
          channelId: 'NASATV.us',
          url: 'https://ntv1.akamaized.net/hls/live/2014075/NASA-NTV1-HLS/master.m3u8',
          quality: '1080p',
        ),
      ],
    ),
    Channel(
      id: 'EuroNewsEnglish.fr',
      name: 'Euronews English',
      network: 'Euronews',
      country: 'FR',
      languages: ['eng'],
      categories: ['news'],
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Euronews_2016_logo.svg/1200px-Euronews_2016_logo.svg.png',
      website: 'https://www.euronews.com',
      streams: [
        StreamUrl(
          channelId: 'EuroNewsEnglish.fr',
          url: 'https://euronews-euronews-eng-3-us.samsung.wurl.tv/manifest/playlist.m3u8',
          quality: '1080p',
        ),
      ],
    ),
  ];

  Future<http.Response?> _fetchUrlWithMirrors(List<String> urls) async {
    for (String url in urls) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: _requestHeaders,
        ).timeout(const Duration(seconds: 20));

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          return response;
        }
      } catch (_) {
        // Try next mirror
      }
    }
    return null;
  }

  Future<List<Channel>> fetchChannels() async {
    try {
      final responses = await Future.wait([
        _fetchUrlWithMirrors(_channelsUrls),
        _fetchUrlWithMirrors(_streamsUrls),
        _fetchUrlWithMirrors(_logosUrls),
      ]);

      final channelsResponse = responses[0];
      final streamsResponse = responses[1];
      final logosResponse = responses[2];

      if (channelsResponse != null && streamsResponse != null) {
        final List<dynamic> channelsJson = jsonDecode(channelsResponse.body);
        final List<dynamic> streamsJson = jsonDecode(streamsResponse.body);

        // Map extra logos from logos.json
        final Map<String, String> logoMap = {};
        if (logosResponse != null) {
          try {
            final List<dynamic> logosJson = jsonDecode(logosResponse.body);
            for (var l in logosJson) {
              final logo = LogoModel.fromJson(l);
              if (logo.channelId.isNotEmpty && logo.url.isNotEmpty) {
                logoMap.putIfAbsent(logo.channelId, () => logo.url);
              }
            }
          } catch (_) {}
        }

        // Group streams by channel ID
        final Map<String, List<StreamUrl>> streamMap = {};
        for (var s in streamsJson) {
          try {
            final stream = StreamUrl.fromJson(s);
            if (stream.channelId.isNotEmpty && stream.url.isNotEmpty) {
              streamMap.putIfAbsent(stream.channelId, () => []).add(stream);
            }
          } catch (_) {}
        }

        final List<Channel> channelList = [];
        for (var c in channelsJson) {
          try {
            final channelId = c['id']?.toString() ?? '';
            final streams = streamMap[channelId] ?? [];
            if (streams.isNotEmpty) {
              var channel = Channel.fromJson(c, streams: streams);
              // Fallback to logos.json if channel.logo is empty
              if ((channel.logo == null || channel.logo!.isEmpty) && logoMap.containsKey(channelId)) {
                channel = channel.copyWith(logo: logoMap[channelId]);
              }
              if (!channel.isNsfw) {
                channelList.add(channel);
              }
            }
          } catch (_) {}
        }

        if (channelList.isNotEmpty) {
          // Merge featured high-reliability channels at top if not present
          final Set<String> existingIds = channelList.map((e) => e.id).toSet();
          for (var fallback in _featuredFallbackChannels) {
            if (!existingIds.contains(fallback.id)) {
              channelList.insert(0, fallback);
            }
          }
          return channelList;
        }
      }
    } catch (_) {}

    return _featuredFallbackChannels;
  }

  Future<List<FeedModel>> fetchFeeds() async {
    try {
      final response = await _fetchUrlWithMirrors(_feedsUrls);
      if (response != null && response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((e) => FeedModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _fetchUrlWithMirrors(_categoriesUrls);
      if (response != null && response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((e) => CategoryModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return [
      CategoryModel(id: 'news', name: 'News'),
      CategoryModel(id: 'sports', name: 'Sports'),
      CategoryModel(id: 'movies', name: 'Movies'),
      CategoryModel(id: 'music', name: 'Music'),
      CategoryModel(id: 'entertainment', name: 'Entertainment'),
      CategoryModel(id: 'kids', name: 'Kids'),
      CategoryModel(id: 'education', name: 'Education'),
      CategoryModel(id: 'documentary', name: 'Documentary'),
      CategoryModel(id: 'general', name: 'General'),
    ];
  }
}
