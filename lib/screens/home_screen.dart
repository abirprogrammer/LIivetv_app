import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/channel_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/channel_card.dart';
import '../widgets/channel_list_card.dart';
import '../widgets/featured_banner.dart';
import '../widgets/category_chip.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/channel_logo.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ChannelProvider>(context, listen: false);
      if (provider.filteredChannels.isEmpty && !provider.isLoading) {
        provider.init();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCountryFilterModal(BuildContext context) {
    final provider = Provider.of<ChannelProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;
    final countries = provider.availableCountries;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF141722) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter by Country',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: isDark ? Colors.white70 : Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    final isSelected = provider.selectedCountry == country;
                    return ListTile(
                      title: Text(
                        country == 'All' ? 'Worldwide (All Countries)' : country,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFFFF2A54) : (isDark ? Colors.white : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: Color(0xFFFF2A54))
                          : null,
                      onTap: () {
                        provider.setSelectedCountry(country);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChannelProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final favoriteChannels = provider.filteredChannels
        .where((c) => provider.isFavorite(c.id))
        .toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1117) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF141722) : Colors.white,
        elevation: 0,
        titleSpacing: 12,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search channel or category...',
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear_rounded, color: isDark ? Colors.white70 : Colors.black54, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      provider.setSearchQuery('');
                      setState(() {
                        _isSearching = false;
                      });
                    },
                  ),
                ),
                onChanged: (val) {
                  provider.setSearchQuery(val);
                },
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Icon Badge
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF2A54), Color(0xFFFF6584)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF2A54).withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // App Title
                  Text(
                    'LiveTv',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // LIVE Counter Badge
                  if (!provider.isLoading) ...[
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E5FF).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF00E5FF).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00E5FF),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${provider.filteredChannels.length} LIVE',
                                style: const TextStyle(
                                  color: Color(0xFF00E5FF),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
        actions: [
          if (!_isSearching) ...[
            // Theme Mode Switcher Icon
            IconButton(
              icon: Icon(
                isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                color: isDark ? Colors.amber : const Color(0xFFFF2A54),
                size: 20,
              ),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
            IconButton(
              icon: Icon(Icons.search_rounded, color: isDark ? Colors.white : Colors.black87, size: 20),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.public_rounded,
                color: provider.selectedCountry != 'All'
                    ? const Color(0xFF00E5FF)
                    : (isDark ? Colors.white70 : Colors.black54),
                size: 20,
              ),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
              onPressed: () => _showCountryFilterModal(context),
            ),
            IconButton(
              icon: Icon(
                provider.showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
                color: provider.showOnlyFavorites ? const Color(0xFFFF2A54) : (isDark ? Colors.white70 : Colors.black54),
                size: 20,
              ),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
              onPressed: () {
                provider.toggleShowOnlyFavorites();
              },
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
      body: provider.isLoading
          ? const Column(
              children: [
                SizedBox(height: 20),
                Expanded(child: ShimmerLoadingGrid()),
              ],
            )
          : RefreshIndicator(
              color: const Color(0xFFFF2A54),
              backgroundColor: isDark ? const Color(0xFF141722) : Colors.white,
              onRefresh: () async {
                await provider.init();
              },
              child: CustomScrollView(
                slivers: [
                  // -------------------------------------------------------------
                  // FEATURED HERO BANNER (Only when not searching or in favorites view)
                  // -------------------------------------------------------------
                  if (!provider.showOnlyFavorites &&
                      provider.searchQuery.isEmpty &&
                      provider.selectedCategory == 'All' &&
                      provider.featuredChannels.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: FeaturedBanner(channels: provider.featuredChannels),
                      ),
                    ),
                  ],

                  // -------------------------------------------------------------
                  // CATEGORIES FILTER HORIZONTAL LIST
                  // -------------------------------------------------------------
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: provider.categories.map((cat) {
                                final isSelected =
                                    provider.selectedCategory.toLowerCase() == cat.name.toLowerCase() ||
                                        (provider.selectedCategory == 'All' && cat.name == 'All');
                                return CategoryChip(
                                  label: cat.name,
                                  isSelected: isSelected,
                                  onTap: () {
                                    provider.setSelectedCategory(cat.name);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // -------------------------------------------------------------
                  // FAVORITE CHANNELS CAROUSEL (Show right below categories)
                  // -------------------------------------------------------------
                  if (!provider.showOnlyFavorites &&
                      provider.searchQuery.isEmpty &&
                      favoriteChannels.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.favorite_rounded, color: Color(0xFFFF2A54), size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'My Favorite Channels',
                                      style: TextStyle(
                                        color: isDark ? Colors.white : Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF2A54).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${favoriteChannels.length} SAVED',
                                    style: const TextStyle(
                                      color: Color(0xFFFF2A54),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: favoriteChannels.length,
                              itemBuilder: (context, index) {
                                final fav = favoriteChannels[index];
                                return Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayerScreen(channel: fav),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF1E2230) : Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ChannelLogo(
                                            logoUrl: fav.logo,
                                            channelName: fav.name,
                                            size: 44,
                                            borderRadius: 10,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            fav.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: isDark ? Colors.white : Colors.black87,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],

                  // -------------------------------------------------------------
                  // SECTION TITLE & VIEW TOGGLE
                  // -------------------------------------------------------------
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                provider.showOnlyFavorites
                                    ? 'Favorite Channels'
                                    : '${provider.selectedCategory} Channels',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (provider.selectedCountry != 'All') ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00E5FF).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    provider.selectedCountry,
                                    style: const TextStyle(
                                      color: Color(0xFF00E5FF),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.grid_view_rounded,
                                  color: _isGridView ? const Color(0xFFFF2A54) : (isDark ? Colors.white38 : Colors.black38),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isGridView = true;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.view_list_rounded,
                                  color: !_isGridView ? const Color(0xFFFF2A54) : (isDark ? Colors.white38 : Colors.black38),
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isGridView = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // -------------------------------------------------------------
                  // CHANNEL GRID OR LIST
                  // -------------------------------------------------------------
                  if (provider.filteredChannels.isEmpty) ...[
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                provider.showOnlyFavorites
                                    ? Icons.favorite_border_rounded
                                    : Icons.tv_off_rounded,
                                color: isDark ? Colors.white38 : Colors.black38,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                provider.showOnlyFavorites
                                    ? 'No favorite channels saved yet.'
                                    : 'No channels found for your selection.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  provider.setSelectedCategory('All');
                                  provider.setSelectedCountry('All');
                                  provider.setSearchQuery('');
                                  if (provider.showOnlyFavorites) {
                                    provider.toggleShowOnlyFavorites();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF2A54),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Reset Filters'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else if (_isGridView) ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final channel = provider.filteredChannels[index];
                            return ChannelCard(channel: channel);
                          },
                          childCount: provider.filteredChannels.length,
                        ),
                      ),
                    ),
                  ] else ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final channel = provider.filteredChannels[index];
                            return ChannelListCard(channel: channel);
                          },
                          childCount: provider.filteredChannels.length,
                        ),
                      ),
                    ),
                  ],

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 40),
                  ),
                ],
              ),
            ),
    );
  }
}
