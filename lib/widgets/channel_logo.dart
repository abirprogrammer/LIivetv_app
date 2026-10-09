import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChannelLogo extends StatelessWidget {
  final String? logoUrl;
  final String channelName;
  final double size;
  final double borderRadius;

  const ChannelLogo({
    super.key,
    required this.logoUrl,
    required this.channelName,
    this.size = 50,
    this.borderRadius = 12,
  });

  static const Map<String, String> _httpHeaders = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
  };

  String? get _sanitizedUrl {
    if (logoUrl == null || logoUrl!.trim().isEmpty) return null;
    String url = logoUrl!.trim();
    if (url.startsWith('//')) {
      url = 'https:$url';
    } else if (url.startsWith('http://')) {
      url = url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  bool get _isSvg {
    final url = _sanitizedUrl;
    if (url == null) return false;
    final cleanUrl = url.toLowerCase().split('?').first;
    return cleanUrl.endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    final url = _sanitizedUrl;

    if (url == null) {
      return _buildStyledFallback();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF141722),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: _isSvg
              ? SvgPicture.network(
                  url,
                  headers: _httpHeaders,
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) => _buildLoadingIndicator(),
                  errorBuilder: (context, error, stackTrace) => _buildStyledFallback(),
                )
              : CachedNetworkImage(
                  imageUrl: url,
                  httpHeaders: _httpHeaders,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => _buildLoadingIndicator(),
                  errorWidget: (context, url, error) {
                    // Fallback to standard Image.network if CachedNetworkImage encounters cache issues
                    return Image.network(
                      url,
                      headers: _httpHeaders,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => _buildStyledFallback(),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        width: size * 0.35,
        height: size * 0.35,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2A54)),
        ),
      ),
    );
  }

  Widget _buildStyledFallback() {
    final initials = _getInitials(channelName);
    final gradient = _getGradientForName(channelName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background TV watermark
          Positioned(
            right: -size * 0.15,
            bottom: -size * 0.15,
            child: Icon(
              Icons.tv_rounded,
              color: Colors.white.withOpacity(0.15),
              size: size * 0.7,
            ),
          ),

          // Channel Initials
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                initials,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  shadows: const [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'TV';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final first = parts[0][0].toUpperCase();
      final second = parts[1][0].toUpperCase();
      return '$first$second';
    } else if (name.length >= 3) {
      return name.substring(0, 3).toUpperCase();
    }
    return name.toUpperCase();
  }

  LinearGradient _getGradientForName(String name) {
    final gradients = [
      const LinearGradient(
        colors: [Color(0xFFE50914), Color(0xFFFF5252)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFF6200EE), Color(0xFFBB86FC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFFC2185B), Color(0xFFF06292)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFF00ACC1), Color(0xFF26C6DA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];

    final hash = name.codeUnits.fold(0, (prev, elem) => prev + elem);
    return gradients[hash % gradients.length];
  }
}
