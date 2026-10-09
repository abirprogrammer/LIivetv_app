import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/channel_model.dart';
import '../providers/channel_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/player_screen.dart';
import 'channel_logo.dart';

class ChannelListCard extends StatelessWidget {
  final Channel channel;

  const ChannelListCard({
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
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (context, animation, secondaryAnimation) =>
                PlayerScreen(channel: channel),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2230) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Left Logo Container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: ChannelLogo(
                logoUrl: channel.logo,
                channelName: channel.name,
                size: 64,
                borderRadius: 14,
              ),
            ),
            const SizedBox(width: 14),

            // Center Channel Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          channel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2A54).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          channel.primaryCategory,
                          style: const TextStyle(
                            color: Color(0xFFFF2A54),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Country Tag
                      if (channel.country != null && channel.country!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E5FF).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            channel.country!.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF00E5FF),
                              fontSize: 11,
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

            const SizedBox(width: 8),

            // Right Actions: Favorite Heart & Play Button
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? const Color(0xFFFF2A54) : (isDark ? Colors.white38 : Colors.black38),
                    size: 22,
                  ),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                  onPressed: () {
                    channelProvider.toggleFavorite(channel.id);
                  },
                ),
                const SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
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
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
