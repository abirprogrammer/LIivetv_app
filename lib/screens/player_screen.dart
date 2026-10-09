import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/channel_model.dart';
import '../models/stream_url.dart';
import '../providers/channel_provider.dart';
import '../widgets/channel_logo.dart';

class PlayerScreen extends StatefulWidget {
  final Channel channel;

  const PlayerScreen({
    super.key,
    required this.channel,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  int _currentStreamIndex = 0;
  bool _isInitializing = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    setState(() {
      _isInitializing = true;
      _hasError = false;
      _errorMessage = '';
    });

    if (widget.channel.streams.isEmpty) {
      setState(() {
        _isInitializing = false;
        _hasError = true;
        _errorMessage = 'No live stream source available for this channel.';
      });
      return;
    }

    final StreamUrl currentStream = widget.channel.streams[_currentStreamIndex];

    try {
      // Safely dispose existing controllers
      _chewieController?.dispose();
      await _videoPlayerController?.dispose();

      final uri = Uri.parse(currentStream.url);

      Map<String, String> httpHeaders = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      };
      if (currentStream.userAgent != null && currentStream.userAgent!.isNotEmpty) {
        httpHeaders['User-Agent'] = currentStream.userAgent!;
      }
      if (currentStream.httpReferrer != null && currentStream.httpReferrer!.isNotEmpty) {
        httpHeaders['Referer'] = currentStream.httpReferrer!;
      }

      _videoPlayerController = VideoPlayerController.networkUrl(
        uri,
        httpHeaders: httpHeaders,
      );

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true,
        isLive: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio > 0
            ? _videoPlayerController!.value.aspectRatio
            : 16 / 9,
        allowFullScreen: true,
        allowMuting: true,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFFF2A54),
          handleColor: const Color(0xFFFF2A54),
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white38,
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, color: Color(0xFFFF2A54), size: 48),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Failed to load stream: $errorMessage',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _initializePlayer,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry Stream'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2A54),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      setState(() {
        _isInitializing = false;
        _hasError = true;
        _errorMessage = 'Unable to play live stream. Tap retry or select another stream source.';
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channelProvider = Provider.of<ChannelProvider>(context);
    final isFav = channelProvider.isFavorite(widget.channel.id);
    final relatedChannels = channelProvider.filteredChannels
        .where((c) => c.id != widget.channel.id)
        .take(10)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141722),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE50914),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.channel.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? const Color(0xFFFF2A54) : Colors.white70,
            ),
            onPressed: () {
              channelProvider.toggleFavorite(widget.channel.id);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // VIDEO PLAYER AREA
              // -------------------------------------------------------------
              Container(
                width: double.infinity,
                height: 230,
                color: Colors.black,
                child: _isInitializing
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2A54)),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Connecting to Live Stream...',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : _hasError
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: Color(0xFFFF2A54),
                                    size: 44,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _errorMessage,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                  const SizedBox(height: 14),
                                  ElevatedButton.icon(
                                    onPressed: _initializePlayer,
                                    icon: const Icon(Icons.refresh_rounded, size: 16),
                                    label: const Text('Retry Stream'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF2A54),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _chewieController != null
                            ? Chewie(controller: _chewieController!)
                            : const SizedBox.shrink(),
              ),

              // -------------------------------------------------------------
              // MULTI STREAM SWITCHER BAR (If channel has > 1 stream)
              // -------------------------------------------------------------
              if (widget.channel.streams.length > 1) ...[
                Container(
                  color: const Color(0xFF181B26),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.tune_rounded, color: Color(0xFF00E5FF), size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Streams:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              widget.channel.streams.length,
                              (index) {
                                final isSelected = _currentStreamIndex == index;
                                final stream = widget.channel.streams[index];
                                final label = stream.quality ?? 'Stream ${index + 1}';
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(label),
                                    selected: isSelected,
                                    selectedColor: const Color(0xFFFF2A54),
                                    backgroundColor: const Color(0xFF232838),
                                    labelStyle: TextStyle(
                                      color: isSelected ? Colors.white : Colors.grey[300],
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                    onSelected: (selected) {
                                      if (selected && _currentStreamIndex != index) {
                                        setState(() {
                                          _currentStreamIndex = index;
                                        });
                                        _initializePlayer();
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // -------------------------------------------------------------
              // CHANNEL META DETAILS
              // -------------------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Channel Logo Avatar
                        ChannelLogo(
                          logoUrl: widget.channel.logo,
                          channelName: widget.channel.name,
                          size: 60,
                          borderRadius: 12,
                        ),
                        const SizedBox(width: 14),

                        // Title, Network, Badges
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.channel.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (widget.channel.network != null &&
                                  widget.channel.network!.isNotEmpty) ...[
                                Text(
                                  'Network: ${widget.channel.network}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                              ],
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF2A54).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      widget.channel.primaryCategory,
                                      style: const TextStyle(
                                        color: Color(0xFFFF2A54),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (widget.channel.country != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00E5FF).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'COUNTRY: ${widget.channel.country!.toUpperCase()}',
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
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 16),

                    // -------------------------------------------------------------
                    // RELATED / MORE LIVE CHANNELS
                    // -------------------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'More Live Channels',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${relatedChannels.length} available',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      height: 150,
                      child: relatedChannels.isEmpty
                          ? const Center(
                              child: Text(
                                'No related channels found.',
                                style: TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: relatedChannels.length,
                              itemBuilder: (context, index) {
                                final relChannel = relatedChannels[index];
                                return Container(
                                  width: 120,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayerScreen(channel: relChannel),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1B1E2B),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.08),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: ChannelLogo(
                                                logoUrl: relChannel.logo,
                                                channelName: relChannel.name,
                                                size: 50,
                                                borderRadius: 10,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            relChannel.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
