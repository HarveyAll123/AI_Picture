import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/cloud_functions_service.dart';
import 'service_providers.dart';

class GenerationState {
  const GenerationState({
    this.isGenerating = false,
    this.generatedUrl,
    this.error,
  });

  final bool isGenerating;
  final String? generatedUrl;
  final String? error;

  GenerationState copyWith({
    bool? isGenerating,
    String? generatedUrl,
    String? error,
  }) {
    return GenerationState(
      isGenerating: isGenerating ?? this.isGenerating,
      generatedUrl: generatedUrl ?? this.generatedUrl,
      error: error,
    );
  }

  factory GenerationState.initial() => const GenerationState();
}

class GenerationController extends StateNotifier<GenerationState> {
  GenerationController(this._cloudFunctionsService)
    : super(GenerationState.initial());

  final CloudFunctionsService _cloudFunctionsService;

  Future<String> generateProfileVariant({
    required String uid,
    required String originalImagePath,
    required String imageUrl,
    required String stylePrompt,
  }) async {
    state = state.copyWith(isGenerating: true, error: null);
    try {
      // Call Firebase Cloud Function which handles:
      // 1) Gemini image generation
      // 2) Uploading to Storage at users/{uid}/generated/{resultId}.jpg
      // 3) Saving metadata to Firestore at users/{uid}/results
      final generatedUrl = await _cloudFunctionsService.generateProfilePicture(
        imageUrl: imageUrl,
        prompt: stylePrompt,
      );

      state = state.copyWith(isGenerating: false, generatedUrl: generatedUrl);
      return generatedUrl;
    } catch (error) {
      state = state.copyWith(isGenerating: false, error: error.toString());
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final generationControllerProvider =
    StateNotifierProvider<GenerationController, GenerationState>(
      (ref) => GenerationController(ref.watch(cloudFunctionsServiceProvider)),
    );
