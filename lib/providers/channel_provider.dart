import 'package:flutter/material.dart';
import '../models/channel_model.dart';
import '../models/category_model.dart';
import '../services/iptv_service.dart';
import '../services/favorites_service.dart';

class ChannelProvider extends ChangeNotifier {
  final IptvService _iptvService = IptvService();
  final FavoritesService _favoritesService = FavoritesService();

  List<Channel> _allChannels = [];
  List<CategoryModel> _categories = [];
  Set<String> _favoriteIds = {};

  bool _isLoading = true;
  String? _errorMessage;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _selectedCountry = 'All';
  bool _showOnlyFavorites = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<CategoryModel> get categories => _categories;
  Set<String> get favoriteIds => _favoriteIds;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get selectedCountry => _selectedCountry;
  bool get showOnlyFavorites => _showOnlyFavorites;

  List<Channel> get featuredChannels {
    if (_allChannels.isEmpty) return [];
    // Select top 6 high quality/popular channels for the hero carousel banner
    return _allChannels.take(8).toList();
  }

  List<String> get availableCountries {
    final Set<String> countries = {'All'};
    for (var c in _allChannels) {
      if (c.country != null && c.country!.isNotEmpty) {
        countries.add(c.country!.toUpperCase());
      }
    }
    return countries.toList()..sort();
  }

  List<Channel> get filteredChannels {
    return _allChannels.where((channel) {
      // Favorites filter
      if (_showOnlyFavorites && !_favoriteIds.contains(channel.id)) {
        return false;
      }

      // Category filter
      if (_selectedCategory != 'All') {
        final lowerCat = _selectedCategory.toLowerCase();
        final matchesCat = channel.categories.any(
          (c) => c.toLowerCase() == lowerCat || c.toLowerCase().contains(lowerCat),
        );
        if (!matchesCat) return false;
      }

      // Country filter
      if (_selectedCountry != 'All') {
        if (channel.country?.toUpperCase() != _selectedCountry.toUpperCase()) {
          return false;
        }
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final nameMatch = channel.name.toLowerCase().contains(query);
        final networkMatch = channel.network?.toLowerCase().contains(query) ?? false;
        final countryMatch = channel.country?.toLowerCase().contains(query) ?? false;
        final catMatch = channel.categories.any((c) => c.toLowerCase().contains(query));

        if (!nameMatch && !networkMatch && !countryMatch && !catMatch) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  Future<void> init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _favoriteIds = await _favoritesService.getFavoriteChannelIds();
      final fetchedCategories = await _iptvService.fetchCategories();
      _categories = [
        CategoryModel(id: 'all', name: 'All'),
        CategoryModel(id: 'news', name: 'News'),
        CategoryModel(id: 'sports', name: 'Sports'),
        CategoryModel(id: 'movies', name: 'Movies'),
        CategoryModel(id: 'music', name: 'Music'),
        CategoryModel(id: 'entertainment', name: 'Entertainment'),
        CategoryModel(id: 'kids', name: 'Kids'),
        CategoryModel(id: 'education', name: 'Education'),
        CategoryModel(id: 'documentary', name: 'Documentary'),
        ...fetchedCategories.where((c) => ![
          'all', 'news', 'sports', 'movies', 'music', 'entertainment', 'kids', 'education', 'documentary'
        ].contains(c.id.toLowerCase())),
      ];

      _allChannels = await _iptvService.fetchChannels();
    } catch (e) {
      _errorMessage = 'Failed to load live channels. Please check network connection.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedCountry(String country) {
    _selectedCountry = country;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleShowOnlyFavorites() {
    _showOnlyFavorites = !_showOnlyFavorites;
    notifyListeners();
  }

  Future<void> toggleFavorite(String channelId) async {
    final isFav = await _favoritesService.toggleFavorite(channelId);
    if (isFav) {
      _favoriteIds.add(channelId);
    } else {
      _favoriteIds.remove(channelId);
    }
    notifyListeners();
  }

  bool isFavorite(String channelId) {
    return _favoriteIds.contains(channelId);
  }
}
