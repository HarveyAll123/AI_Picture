import 'package:flutter/material.dart';

import '../models/scene_preset.dart';

const List<ScenePreset> scenePresets = [
  ScenePreset(
    id: 'forest',
    title: 'Forest Escape',
    subtitle: 'Golden-hour woodland',
    icon: Icons.park_outlined,
    gradient: [Color(0xFF064E3B), Color(0xFF132A13)],
    prompt:
        'Transform this portrait into a cinematic outdoor portrait set inside a sunlit evergreen forest at golden hour. '
        'Soft amber light filters through tall pine trees, with gentle mist, mossy rocks, and blurred foliage in the background. '
        'Keep the outfit natural, enhance freckles and skin tone with warm highlights, and add subtle depth-of-field bokeh.',
  ),
  ScenePreset(
    id: 'coffee',
    title: 'Cafe Glow',
    subtitle: 'Cozy latte-side ambience',
    icon: Icons.local_cafe_outlined,
    gradient: [Color(0xFF4B2C20), Color(0xFF0F172A)],
    prompt:
        'Reimagine this person sitting near a large cafe window with warm afternoon light and creamy bokeh lights in the background. '
        'Place a ceramic cup of latte or cappuccino on the table, add wooden textures, indoor plants, and a soft-focus city street outside. '
        'Make the scene feel artisanal, cozy, and sophisticated.',
  ),
  ScenePreset(
    id: 'drive',
    title: 'Executive Drive',
    subtitle: 'Luxury EV + city lights',
    icon: Icons.directions_car_filled_outlined,
    gradient: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
    prompt:
        'Stage the subject beside a sleek luxury electric car parked in front of a minimalist smart home driveway at twilight. '
        'Add subtle reflections on the car body, neon edge lights, and a softly lit skyline in the background. '
        'Keep wardrobe polished, accentuate metallic blues and cool grays for a premium, modern vibe.',
  ),
  ScenePreset(
    id: 'future',
    title: 'Future Skyline',
    subtitle: 'Neon rooftop energy',
    icon: Icons.location_city_outlined,
    gradient: [Color(0xFF0F172A), Color(0xFF312E81)],
    prompt:
        'Place the subject on a rooftop terrace overlooking a futuristic skyline at dusk. '
        'Add neon signage, holographic billboards, volumetric light beams, and reflective glass architecture. '
        'Blend magenta, cyan, and indigo lighting for a slick sci-fi portrait with cinematic contrast.',
  ),
  ScenePreset(
    id: 'beach',
    title: 'Beach Sunset',
    subtitle: 'Tropical golden hour',
    icon: Icons.beach_access_outlined,
    gradient: [Color(0xFFF59E0B), Color(0xFFDC2626)],
    prompt:
        'Place the subject on a pristine sandy beach during golden hour sunset. '
        'Warm orange and pink sky, gentle ocean waves in the background, soft sand textures, and natural beach lighting. '
        'Keep the atmosphere relaxed and summery with natural skin tones enhanced by sunset glow.',
  ),
  ScenePreset(
    id: 'studio',
    title: 'Studio Portrait',
    subtitle: 'Professional lighting',
    icon: Icons.camera_alt_outlined,
    gradient: [Color(0xFF1F2937), Color(0xFF111827)],
    prompt:
        'Create a professional studio portrait with soft, even lighting and a clean neutral background. '
        'Use professional portrait lighting techniques, subtle shadows for depth, and crisp focus on the face. '
        'Perfect for business profiles, headshots, and professional networking.',
  ),
  ScenePreset(
    id: 'mountain',
    title: 'Mountain Vista',
    subtitle: 'Alpine adventure',
    icon: Icons.landscape_outlined,
    gradient: [Color(0xFF1E40AF), Color(0xFF0F172A)],
    prompt:
        'Position the subject against a dramatic mountain landscape with snow-capped peaks and clear blue sky. '
        'Natural outdoor lighting, crisp mountain air atmosphere, and breathtaking scenic backdrop. '
        'Keep the subject well-lit with natural colors and outdoor adventure vibes.',
  ),
  ScenePreset(
    id: 'library',
    title: 'Library Study',
    subtitle: 'Classic academic',
    icon: Icons.menu_book_outlined,
    gradient: [Color(0xFF78350F), Color(0xFF0F172A)],
    prompt:
        'Set the subject in a cozy library with tall bookshelves, warm reading lamps, and vintage furniture. '
        'Soft ambient lighting from table lamps, rich wooden textures, and an intellectual, scholarly atmosphere. '
        'Create a sophisticated, timeless portrait with warm browns and gold tones.',
  ),
  ScenePreset(
    id: 'urban',
    title: 'Urban Street',
    subtitle: 'City life energy',
    icon: Icons.location_on_outlined,
    gradient: [Color(0xFF475569), Color(0xFF1E293B)],
    prompt:
        'Place the subject on a vibrant urban street with modern architecture, street art, and city life in the background. '
        'Natural daylight, dynamic city atmosphere, and contemporary urban style. '
        'Capture the energy and movement of city life with sharp details and modern aesthetics.',
  ),
  ScenePreset(
    id: 'garden',
    title: 'Garden Bloom',
    subtitle: 'Floral paradise',
    icon: Icons.local_florist_outlined,
    gradient: [Color(0xFF059669), Color(0xFF064E3B)],
    prompt:
        'Surround the subject with a beautiful garden full of blooming flowers, lush greenery, and natural sunlight. '
        'Soft natural lighting filtering through leaves, colorful flower arrangements, and a peaceful garden setting. '
        'Create a fresh, vibrant portrait with natural colors and botanical beauty.',
  ),
];
