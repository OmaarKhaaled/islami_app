import 'package:flutter/material.dart';
import 'package:islami/app_theme.dart';
import 'package:islami/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreens extends StatefulWidget {
  static const routeName = '/onboarding-details';

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final List<Map<String, String>> boardingData = [
    {
      'image': 'assets/images/welcome.png',
      'title': 'Welcome To Islami App',
      'description': '',
    },
    {
      'image': 'assets/images/kaaba.png',
      'title': 'Welcome To Islami',
      'description': 'We Are Very Excited To Have You In Our Community',
    },
    {
      'image': 'assets/images/quran_sebha.png',
      'title': 'Reading the Quran',
      'description': 'Read, and your Lord is the Most Generous',
    },
    {
      'image': 'assets/images/doaa.png',
      'title': 'Bearish',
      'description': 'Praise the name of your Lord, the Most High',
    },
    {
      'image': 'assets/images/radio.png',
      'title': 'Holy Quran Radio',
      'description':
          'You can listen to the Holy Quran Radio through the application for free and easily',
    },
  ];

  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset('assets/images/header.png'),
            SizedBox(height: screenSize.height * .05),
            Expanded(
              child: PageView.builder(
                physics: ScrollPhysics(),
                controller: pageController,
                itemCount: boardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = boardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Image.asset(
                          item['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: screenSize.height * .4,
                        ),
                        item['description'] == ''
                            ? SizedBox(height: screenSize.height * .11)
                            : SizedBox(height: screenSize.height * .04),
                        Text(
                          item['title']!,
                          style: textTheme.headlineSmall!.copyWith(
                            color: AppTheme.primary,
                          ),
                        ),
                        SizedBox(height: screenSize.height * .05),
                        Text(
                          item['description']!,
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium!.copyWith(
                            color: AppTheme.primary,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentPage > 0
                      ? TextButton(
                          onPressed: onBack,
                          child: Text(
                            'Back',
                            style: textTheme.titleMedium!.copyWith(
                              color: AppTheme.primary,
                            ),
                          ),
                        )
                      : SizedBox(width: screenSize.width * .15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      boardingData.length,
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: currentPage == index ? 18 : 9,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? AppTheme.primary
                              : Color(0xff707070),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onNext,
                    child: Text(
                      currentPage < boardingData.length - 1 ? 'Next' : 'Finish',
                      style: textTheme.titleMedium!.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
  }

  void onNext() async {
    if (currentPage < boardingData.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      await setOnboardingSeen();
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  void onBack() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }
}
