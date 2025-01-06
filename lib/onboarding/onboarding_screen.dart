import 'package:chatbot_app_project/onboarding/get_started_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingContent = [
    {
      'image': 'assets/images/splash2.png',
      'title': 'Personalized Learning',
      'content':
          'Discover a personalized learning journey tailored to your style and pace. Receive adaptive content and real-time feedback.',
    },
    {
      'image': 'assets/images/support.png',
      'title': 'Empathetic Experience',
      'content':
          'Experience empathetic learning with sentiment analysis. Stay motivated and reduce stress with mindful interventions.',
    },
    {
      'image': 'assets/images/winning.png',
      'title': 'Gamified Engagement',
      'content':
          'Make learning fun with gamified challenges. Earn rewards, climb leaderboards, and stay engaged like never before.',
    },
  ];

  void _onNextPressed() {
    if (_currentIndex < _onboardingContent.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    } else {
      Get.to(() => GetStartedScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _onboardingContent.length,
              itemBuilder: (context, index) {
                final content = _onboardingContent[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          content['image']!,
                          height: totalHeight * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: totalHeight * 0.01),
                      Text(
                        content['title']!,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: totalHeight * 0.01),
                      Text(
                        content['content']!,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: totalHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingContent.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: totalWidth * 0.03,
                height: totalWidth * 0.01,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.amber : Colors.grey,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          SizedBox(height: totalHeight * 0.01),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.white)),
                onPressed: () {
                  _onNextPressed();
                },
                child: const Text("Next"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
