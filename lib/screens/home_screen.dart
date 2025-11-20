import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/auth_providers.dart';
import '../providers/generation_provider.dart';
import '../providers/upload_provider.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/primary_button.dart';
import '../widgets/error_display.dart';
import '../widgets/image_source_modal.dart';
import 'gallery_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController _promptController;
  late final ScrollController _promptScrollController;
  late final ScrollController _pageScrollController;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController(
      text:
          'Create a professional profile headshot with clean background and soft lighting.',
    );
    _promptScrollController = ScrollController();
    _pageScrollController = ScrollController();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _promptScrollController.dispose();
    _pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadControllerProvider);
    final generationState = ref.watch(generationControllerProvider);
    final ensureAuth = ref.watch(ensureAuthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Profile Picture'),
        actions: [
          IconButton(
            icon: const Icon(Icons.collections_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(GalleryScreen.routeName);
            },
          ),
        ],
      ),
      body: ensureAuth.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Authentication error: $err')),
        data: (user) {
          final isLoading =
              uploadState.isUploading || generationState.isGenerating;
          final overlayMessage = generationState.isGenerating
              ? 'Generating avatar...'
              : 'Uploading image...';

          return LoadingOverlay(
            isLoading: isLoading,
            message: overlayMessage,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                final preview = _ImagePreview(
                  uploadState: uploadState,
                  onTap: () => _showImageSourceDialog(context, user.uid),
                );
                final actions = _ActionPanel(
                  promptController: _promptController,
                  promptScrollController: _promptScrollController,
                  uploadState: uploadState,
                  generationState: generationState,
                  userId: user.uid,
                  onGenerate: _onGeneratePressed,
                  isGenerating: generationState.isGenerating,
                );

                if (isWide) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: preview),
                        const SizedBox(width: 32),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: actions,
                        ),
                      ],
                    ),
                  );
                }

                return Scrollbar(
                  controller: _pageScrollController,
                  child: SingleChildScrollView(
                    controller: _pageScrollController,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      children: [
                        AspectRatio(aspectRatio: 3 / 4, child: preview),
                        const SizedBox(height: 24),
                        Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: actions,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, String uid) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ImageSourceModal(uid: uid),
    );
  }

  Future<void> _onGeneratePressed({
    required String prompt,
    required String uid,
  }) async {
    final uploadState = ref.read(uploadControllerProvider);
    final controller = ref.read(generationControllerProvider.notifier);

    if (uploadState.downloadUrl == null ||
        uploadState.storagePath == null ||
        uploadState.storagePath!.isEmpty) {
      Fluttertoast.showToast(msg: 'Please upload an image first.');
      return;
    }

    final stylePrompt = prompt.trim().isEmpty
        ? 'Professional business headshot'
        : prompt.trim();

    try {
      // Cloud Function expects imageUrl (it downloads server-side)
      await controller.generateProfileVariant(
        uid: uid,
        originalImagePath: uploadState.storagePath!,
        imageUrl: uploadState.downloadUrl!,
        stylePrompt: stylePrompt,
      );
      Fluttertoast.showToast(msg: 'Profile picture generated!');
      if (mounted) {
        Navigator.of(context).pushNamed(GalleryScreen.routeName);
      }
    } catch (error) {
      // Error will be shown in the UI via GenerationState
    }
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.uploadState,
    this.onTap,
  });

  final UploadState uploadState;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF1E293B), const Color(0xFF020617)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SizedBox.expand(
            child: uploadState.localFile != null
                ? Image.file(uploadState.localFile!, fit: BoxFit.cover)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 80,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Upload a portrait photo to begin',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Front-facing, good lighting, minimal background.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _ActionPanel extends ConsumerStatefulWidget {
  const _ActionPanel({
    required this.promptController,
    required this.promptScrollController,
    required this.uploadState,
    required this.generationState,
    required this.userId,
    required this.onGenerate,
    required this.isGenerating,
  });

  final TextEditingController promptController;
  final ScrollController promptScrollController;
  final UploadState uploadState;
  final GenerationState generationState;
  final String userId;
  final Future<void> Function({required String prompt, required String uid})
  onGenerate;
  final bool isGenerating;

  @override
  ConsumerState<_ActionPanel> createState() => _ActionPanelState();
}

class _ActionPanelState extends ConsumerState<_ActionPanel> {

  @override
  Widget build(BuildContext context) {
    final uploadState = widget.uploadState;
    final userId = widget.userId;
    final isGenerating = widget.isGenerating;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Choose your vibe',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.promptController,
          scrollController: widget.promptScrollController,
          maxLines: 4,
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            hintText: 'Describe the style you want',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: uploadState.isUploading ? 'Uploading...' : 'Upload Image',
          icon: Icons.file_upload_outlined,
          isLoading: uploadState.isUploading,
          onPressed: () async {
            try {
              await ref
                  .read(uploadControllerProvider.notifier)
                  .pickAndUpload(userId, source: ImageSource.gallery);
              Fluttertoast.showToast(msg: 'Image uploaded successfully.');
            } catch (error) {
              // Error shown in UI
            }
          },
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Take Picture',
          icon: Icons.camera_alt_outlined,
          isLoading: false,
          onPressed: () async {
            try {
              await ref
                  .read(uploadControllerProvider.notifier)
                  .pickAndUpload(userId, source: ImageSource.camera);
              Fluttertoast.showToast(msg: 'Image captured successfully.');
            } catch (error) {
              // Error shown in UI
            }
          },
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Generate Profile Picture',
          icon: Icons.auto_awesome,
          isLoading: isGenerating,
          onPressed: uploadState.downloadUrl == null || isGenerating
              ? null
              : () => widget.onGenerate(
                  prompt: widget.promptController.text.trim(),
                  uid: userId,
                ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0x14FFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x1AFFFFFF)),
          ),
          child: Text(
            'Tips:\n• Use well-lit close-up portraits.\n'
            '• Keep the background simple.\n'
            '• Face the camera directly for best identity match.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color.fromARGB(230, 255, 255, 255),
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (uploadState.error != null)
          ErrorDisplay(
            error: uploadState.error!,
            onDismiss: () {
              ref.read(uploadControllerProvider.notifier).clearError();
            },
          ),
        if (widget.generationState.error != null)
          ErrorDisplay(
            error: widget.generationState.error!,
            onDismiss: () {
              ref.read(generationControllerProvider.notifier).clearError();
            },
          ),
      ],
    );
  }
}
