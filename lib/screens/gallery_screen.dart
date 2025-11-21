import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/results_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/result_card.dart';
import 'view_result_screen.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});
  static const routeName = '/gallery';

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  late final ScrollController _gridController;
  bool _showScrollbar = false;
  Timer? _scrollbarTimer;

  @override
  void initState() {
    super.initState();
    _gridController = ScrollController();
  }

  @override
  void dispose() {
    _scrollbarTimer?.cancel();
    _gridController.dispose();
    super.dispose();
  }

  void _onScrollStart() {
    if (!_showScrollbar && mounted) {
      setState(() => _showScrollbar = true);
    }
    _scrollbarTimer?.cancel();
  }

  void _onScrollEnd() {
    _scrollbarTimer?.cancel();
    _scrollbarTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _showScrollbar = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(resultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Gallery')),
      body: resultsAsync.when(
        data: (results) {
          if (results.isEmpty) {
            return const SafeArea(
              child: EmptyState(
                title: 'No results yet',
                subtitle: 'Generate your first AI headshot to see it here.',
              ),
            );
          }
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                final crossAxisCount = width > 1200
                    ? 4
                    : width > 900
                        ? 3
                        : width > 600
                            ? 2
                            : 1;

                return SizedBox(
                  height: height,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification) {
                        _onScrollStart();
                      } else if (notification is ScrollEndNotification) {
                        _onScrollEnd();
                      } else if (notification is ScrollUpdateNotification) {
                        // Keep scrollbar visible while scrolling
                        if (!_showScrollbar && mounted) {
                          setState(() => _showScrollbar = true);
                        }
                        _scrollbarTimer?.cancel();
                      }
                      return true; // Consume the notification to prevent parent scrolling
                    },
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        overscroll: false,
                        physics: const ClampingScrollPhysics(),
                      ),
                      child: Scrollbar(
                        controller: _gridController,
                        thumbVisibility: _showScrollbar,
                        trackVisibility: _showScrollbar,
                        child: GridView.builder(
                          controller: _gridController,
                          primary: false, // Use explicit controller
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final result = results[index];
                            return ResultCard(
                              result: result,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  ViewResultScreen.routeName,
                                  arguments: result,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () =>
            const SafeArea(child: Center(child: CircularProgressIndicator())),
        error: (error, _) => SafeArea(
          child: Center(child: Text('Failed to load gallery: $error')),
        ),
      ),
    );
  }
}
