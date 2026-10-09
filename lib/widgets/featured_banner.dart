import 'dart:async';
import 'package:flutter/material.dart';
import '../models/channel_model.dart';
import '../screens/player_screen.dart';
import 'channel_logo.dart';

class FeaturedBanner extends StatefulWidget {
  final List<Channel> channels;

  const FeaturedBanner({
    super.key,
    required this.channels,
  });

  @override
  State<FeaturedBanner> createState() => _FeaturedBannerState();
}

class _FeaturedBannerState extends State<FeaturedBanner> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.channels.length > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (_pageController.hasClients) {
          final nextPage = (_currentPage + 1) % widget.channels.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.channels.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.channels.length,
            itemBuilder: (context, index) {
              final channel = widget.channels[index];
              return _buildBannerItem(channel);
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.channels.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == index ? 20 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFFFF2A54)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem(Channel channel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1B3D), Color(0xFF141824)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF2A54).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Design Elements
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF2A54).withOpacity(0.12),
              ),
            ),
          ),

          // Content Layout
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Left text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Featured Badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF2A54),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.local_fire_department, color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'FEATURED LIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (channel.country != null)
                            Text(
                              channel.country!.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF00E5FF),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Channel Title
                      Text(
                        channel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        channel.network ?? channel.primaryCategory,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Watch Now Button
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerScreen(channel: channel),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF2A54), Color(0xFFFF6584)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF2A54).withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                              SizedBox(width: 4),
                              Text(
                                'WATCH NOW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Logo Container
                ChannelLogo(
                  logoUrl: channel.logo,
                  channelName: channel.name,
                  size: 80,
                  borderRadius: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
