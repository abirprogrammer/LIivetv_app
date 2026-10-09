import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/channel_model.dart';
import '../providers/channel_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/player_screen.dart';
import 'channel_logo.dart';

class ChannelCard extends StatelessWidget {
  final Channel channel;

  const ChannelCard({
    super.key,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) {
    final channelProvider = Provider.of<ChannelProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final isFav = channelProvider.isFavorite(channel.id);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(channel: channel),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2230) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image/Logo Section with Live Badge & Favorite Button
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF12151E) : const Color(0xFFF0F3F8),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: ChannelLogo(
                        logoUrl: channel.logo,
                        channelName: channel.name,
                        size: 70,
                        borderRadius: 12,
                      ),
                    ),
                  ),

                  // Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // LIVE Tag
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE50914),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: 6,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Favorite Toggle Button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? const Color(0xFFFF2A54) : Colors.white70,
                        size: 20,
                      ),
                      onPressed: () {
                        channelProvider.toggleFavorite(channel.id);
                      },
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),

                  // Play Icon Hover Overlay
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF2A54),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF2A54).withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Channel Details Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          channel.primaryCategory,
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Country Tag if available
                      if (channel.country != null && channel.country!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E5FF).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            channel.country!.toUpperCase(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
