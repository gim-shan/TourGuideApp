class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

// These are the 3 pages for your slider
List<OnboardingContent> contents = [
  OnboardingContent(
    image: 'assets/images/guide.png',
    title: 'Meet your perfect\nLocal Guide',
    description: 'Get personalized tours and insider tips from guides who live where you\'re going.',
  ),
  OnboardingContent(
    image: 'assets/images/vr.png',
    title: 'Experience it\nbefore you go.',
    description: 'Step into your destination with immersive VR. See the sights before you even arrive!',
  ),
  OnboardingContent(
    image: 'assets/images/mood.png',
    title: 'Mood-based\nDestinations.\nJust for You',
    description: 'Happy, relaxed, or adventurous, we\'ll find a place that matches your vibe.',
  ),
];