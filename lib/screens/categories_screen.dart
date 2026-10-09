import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/channel_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/channel_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _selectedCategory;

  static const Map<String, String> _categoryImages = {
    'news': 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=600&auto=format&fit=crop&q=80',
    'sports': 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=600&auto=format&fit=crop&q=80',
    'movies': 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=600&auto=format&fit=crop&q=80',
    'music': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600&auto=format&fit=crop&q=80',
    'entertainment': 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600&auto=format&fit=crop&q=80',
    'kids': 'https://images.unsplash.com/photo-1566492031773-4f4e44671857?w=600&auto=format&fit=crop&q=80',
    'education': 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=600&auto=format&fit=crop&q=80',
    'documentary': 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=600&auto=format&fit=crop&q=80',
    'general': 'https://images.unsplash.com/photo-1593784991095-a201069571cd?w=600&auto=format&fit=crop&q=80',
    'science': 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&auto=format&fit=crop&q=80',
    'lifestyle': 'https://images.unsplash.com/photo-1511988617509-a57c8a288659?w=600&auto=format&fit=crop&q=80',
  };

  static const Map<String, IconData> _categoryIcons = {
    'news': Icons.newspaper_rounded,
    'sports': Icons.sports_soccer_rounded,
    'movies': Icons.movie_rounded,
    'music': Icons.music_note_rounded,
    'entertainment': Icons.theater_comedy_rounded,
    'kids': Icons.child_care_rounded,
    'education': Icons.school_rounded,
    'documentary': Icons.menu_book_rounded,
    'general': Icons.tv_rounded,
    'science': Icons.science_rounded,
    'lifestyle': Icons.style_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChannelProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final categories = provider.categories.where((c) => c.id != 'all').toList();

    if (_selectedCategory != null) {
      final categoryChannels = provider.filteredChannels.where((channel) {
        final lowerCat = _selectedCategory!.toLowerCase();
        return channel.categories.any(
          (c) => c.toLowerCase() == lowerCat || c.toLowerCase().contains(lowerCat),
        );
      }).toList();

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F1117) : const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF141722) : Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : Colors.black87,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _selectedCategory = null;
              });
            },
          ),
          title: Text(
            '${_selectedCategory![0].toUpperCase()}${_selectedCategory!.substring(1)} Channels',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: categoryChannels.isEmpty
            ? Center(
                child: Text(
                  'No channels found in this category.',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: categoryChannels.length,
                itemBuilder: (context, index) {
                  return ChannelCard(channel: categoryChannels[index]);
                },
              ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1117) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF141722) : Colors.white,
        elevation: 0,
        title: Text(
          'Live TV Categories',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.15,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final catId = cat.id.toLowerCase();
            final icon = _categoryIcons[catId] ?? Icons.live_tv_rounded;
            final imageUrl = _categoryImages[catId] ?? _categoryImages['general']!;

            final count = provider.filteredChannels.where((c) {
              return c.categories.any((catName) => catName.toLowerCase().contains(catId));
            }).length;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = cat.name;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Category Background Image
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFF1E2230),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFF1E2230),
                          ),
                        ),
                      ),

                      // Dark Overlay Gradient for text readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF2A54),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF2A54).withOpacity(0.4),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Icon(icon, color: Colors.white, size: 20),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Text(
                                    '$count LIVE',
                                    style: const TextStyle(
                                      color: Color(0xFF00E5FF),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              cat.name[0].toUpperCase() + cat.name.substring(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }
}
