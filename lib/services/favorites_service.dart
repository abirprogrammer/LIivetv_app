import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _keyFavorites = 'videostreem_favorite_channel_ids';

  Future<Set<String>> getFavoriteChannelIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList(_keyFavorites);
    return favorites?.toSet() ?? {};
  }

  Future<bool> toggleFavorite(String channelId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = (prefs.getStringList(_keyFavorites) ?? []).toSet();

    bool isFav;
    if (favorites.contains(channelId)) {
      favorites.remove(channelId);
      isFav = false;
    } else {
      favorites.add(channelId);
      isFav = true;
    }

    await prefs.setStringList(_keyFavorites, favorites.toList());
    return isFav;
  }

  Future<bool> isFavorite(String channelId) async {
    final favorites = await getFavoriteChannelIds();
    return favorites.contains(channelId);
  }
}
