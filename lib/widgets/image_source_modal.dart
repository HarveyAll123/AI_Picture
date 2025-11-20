import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/upload_provider.dart';

class ImageSourceModal extends ConsumerWidget {
  const ImageSourceModal({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Select Image Source',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.photo_library_outlined,
                      label: 'Gallery',
                      onTap: () async {
                        Navigator.pop(context);
                        try {
                          await ref
                              .read(uploadControllerProvider.notifier)
                              .pickAndUpload(uid, source: ImageSource.gallery);
                          Fluttertoast.showToast(
                            msg: 'Image uploaded successfully.',
                          );
                        } catch (error) {
                          // Error shown in UI
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Camera',
                      onTap: () async {
                        Navigator.pop(context);
                        try {
                          await ref
                              .read(uploadControllerProvider.notifier)
                              .pickAndUpload(uid, source: ImageSource.camera);
                          Fluttertoast.showToast(
                            msg: 'Image captured successfully.',
                          );
                        } catch (error) {
                          // Error shown in UI
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.indigoAccent.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.indigoAccent,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

