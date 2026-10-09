import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/feed_model.dart';
import '../models/channel_model.dart';
import '../providers/channel_provider.dart';
import '../providers/theme_provider.dart';
import '../services/iptv_service.dart';
import '../widgets/channel_logo.dart';
import 'player_screen.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final IptvService _iptvService = IptvService();
  List<FeedModel> _allFeeds = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['All', '1080p', '720p', 'HLS', 'M3U8'];

  @override
  void initState() {
    super.initState();
    _loadFeeds();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFeeds() async {
    setState(() {
      _isLoading = true;
    });
    final fetchedFeeds = await _iptvService.fetchFeeds();
    setState(() {
      _allFeeds = fetchedFeeds;
      _isLoading = false;
    });
  }

  List<FeedModel> _getFilteredFeeds(Map<String, Channel> channelMap) {
    return _allFeeds.where((feed) {
      final channel = channelMap[feed.channelId];
      final title = channel?.name ?? feed.channelId;

      // Search Filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = title.toLowerCase().contains(q);
        final matchesFormat = feed.format?.toLowerCase().contains(q) ?? false;
        final matchesQuality = feed.quality?.toLowerCase().contains(q) ?? false;
        if (!matchesTitle && !matchesFormat && !matchesQuality) return false;
      }

      // Quality / Format Filter
      if (_selectedFilter != 'All') {
        final filterLower = _selectedFilter.toLowerCase();
        final matchesQuality = feed.quality?.toLowerCase().contains(filterLower) ?? false;
        final matchesFormat = feed.format?.toLowerCase().contains(filterLower) ?? false;
        if (!matchesQuality && !matchesFormat) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final channelProvider = Provider.of<ChannelProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final allChannels = channelProvider.filteredChannels;

    final Map<String, Channel> channelMap = {
      for (var c in allChannels) c.id: c
    };

    final filteredFeeds = _getFilteredFeeds(channelMap);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1117) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF141722) : Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF2A54).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.rss_feed_rounded, color: Color(0xFFFF2A54), size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Live Stream Feeds',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: isDark ? Colors.white70 : Colors.black54),
            onPressed: _loadFeeds,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Stats Summary Banner
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF231834), const Color(0xFF141724)]
                      : [const Color(0xFFFF2A54), const Color(0xFFFF6584)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('FEEDS', '${_allFeeds.length}', isDark ? const Color(0xFFFF2A54) : Colors.white),
                  Container(height: 24, width: 1, color: Colors.white24),
                  _buildStatItem('QUALITY', 'FULL HD', const Color(0xFF00E5FF)),
                  Container(height: 24, width: 1, color: Colors.white24),
                  _buildStatItem('STATUS', 'ONLINE', Colors.greenAccent),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2230) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: isDark ? Colors.white38 : Colors.black38, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search feed channel or stream quality...',
                          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        child: Icon(Icons.clear_rounded, color: isDark ? Colors.white54 : Colors.black54, size: 18),
                      ),
                  ],
                ),
              ),
            ),

            // Filter Chips Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: _filters.map((f) {
                  final isSelected = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: isSelected,
                      selectedColor: const Color(0xFFFF2A54),
                      backgroundColor: isDark ? const Color(0xFF1E2230) : Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : (isDark ? Colors.grey[400] : Colors.black87),
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFilter = f;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Main Feeds List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2A54)),
                      ),
                    )
                  : filteredFeeds.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.rss_feed_rounded, color: isDark ? Colors.white38 : Colors.black38, size: 56),
                              const SizedBox(height: 12),
                              Text(
                                'No stream feeds matched your selection.',
                                style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedFilter = 'All';
                                    _searchQuery = '';
                                    _searchController.clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF2A54),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Reset Filters'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: const Color(0xFFFF2A54),
                          backgroundColor: isDark ? const Color(0xFF141722) : Colors.white,
                          onRefresh: _loadFeeds,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredFeeds.length,
                            itemBuilder: (context, index) {
                              final feed = filteredFeeds[index];
                              final channel = channelMap[feed.channelId];
                              final title = channel?.name ?? feed.channelId;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E2230) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  leading: ChannelLogo(
                                    logoUrl: channel?.logo,
                                    channelName: title,
                                    size: 50,
                                    borderRadius: 12,
                                  ),
                                  title: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Row(
                                      children: [
                                        // Quality Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF00E5FF).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            feed.quality ?? 'HD STREAM',
                                            style: const TextStyle(
                                              color: Color(0xFF00E5FF),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),

                                        // Format Badge
                                        if (feed.format != null &&
                                            feed.format!.isNotEmpty) ...[
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              feed.format!.toUpperCase(),
                                              style: TextStyle(
                                                color: isDark ? Colors.grey[300] : Colors.black87,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  trailing: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFF2A54), Color(0xFFFF6584)],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF2A54).withOpacity(0.4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  onTap: () {
                                    if (channel != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayerScreen(channel: channel),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Preparing live feed stream...'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
