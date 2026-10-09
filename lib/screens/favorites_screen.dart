import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/channel_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/channel_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChannelProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final favoriteChannels = provider.filteredChannels
        .where((c) => provider.isFavorite(c.id))
        .toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1117) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF141722) : Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.favorite_rounded, color: Color(0xFFFF2A54), size: 22),
            const SizedBox(width: 10),
            Text(
              'Favorite Channels (${favoriteChannels.length})',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: favoriteChannels.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2A54).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          color: Color(0xFFFF2A54),
                          size: 56,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'No favorite channels added yet',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the heart icon on any channel card to bookmark your favorite live streams for fast access.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
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
                itemCount: favoriteChannels.length,
                itemBuilder: (context, index) {
                  return ChannelCard(channel: favoriteChannels[index]);
                },
              ),
      ),
    );
  }
}
