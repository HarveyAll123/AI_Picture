import 'package:flutter/material.dart';

import '../data/scene_presets.dart';
import '../models/scene_preset.dart';

class SceneSelectionModal extends StatefulWidget {
  const SceneSelectionModal({
    super.key,
    required this.selectedSceneIds,
    required this.onSceneToggled,
    required this.onReset,
  });

  final Set<String> selectedSceneIds;
  final ValueChanged<String> onSceneToggled;
  final VoidCallback onReset;

  @override
  State<SceneSelectionModal> createState() => _SceneSelectionModalState();
}

class _SceneSelectionModalState extends State<SceneSelectionModal> {
  late Set<String> _localSelectedIds;

  @override
  void initState() {
    super.initState();
    _localSelectedIds = Set.from(widget.selectedSceneIds);
  }

  void _handleSceneToggle(String sceneId) {
    setState(() {
      if (_localSelectedIds.contains(sceneId)) {
        _localSelectedIds.remove(sceneId);
      } else {
        _localSelectedIds.add(sceneId);
      }
    });
    widget.onSceneToggled(sceneId);
  }

  @override
  Widget build(BuildContext context) {
    final selectedNames = scenePresets
        .where((p) => _localSelectedIds.contains(p.id))
        .map((p) => p.title)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Scenes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _localSelectedIds.clear();
                      });
                      widget.onReset();
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Choose your scene(s) to generate',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: PageView.builder(
                  itemCount: (scenePresets.length / 2).ceil(),
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * 2;
                    final endIndex = (startIndex + 2).clamp(
                      0,
                      scenePresets.length,
                    );
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = startIndex; i < endIndex; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: i < endIndex - 1 ? 10 : 0,
                            ),
                            child: _SceneOption(
                              preset: scenePresets[i],
                              isSelected: _localSelectedIds.contains(
                                scenePresets[i].id,
                              ),
                              onTap: () =>
                                  _handleSceneToggle(scenePresets[i].id),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              if (selectedNames.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.indigoAccent.withValues(alpha: 0.3),
                    ),
                    color: Colors.indigoAccent.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Selected: ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.indigoAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          selectedNames.length <= 3
                              ? selectedNames.join(', ')
                              : '${selectedNames.take(2).join(', ')} +${selectedNames.length - 2}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.indigoAccent,
                                fontWeight: FontWeight.w500,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                    color: Colors.white.withValues(alpha: 0.03),
                  ),
                  child: Text(
                    'No scenes selected',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white54),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SceneOption extends StatelessWidget {
  const _SceneOption({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final ScenePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.indigoAccent : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
          gradient: LinearGradient(
            colors: isSelected
                ? preset.gradient
                : const [Color(0xFF111828), Color(0xFF0B1120)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(preset.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    preset.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    preset.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.indigoAccent : Colors.white54,
                  width: 2,
                ),
                color: isSelected ? Colors.indigoAccent : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
