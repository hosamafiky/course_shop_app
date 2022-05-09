import 'package:flutter/material.dart';
import 'package:shop_app/models/onboarding_models.dart';
import 'package:shop_app/modules/login_module/login_screen.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../shared/components/components.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var pageController = PageController();
  bool isLast = false;

  void submit() {
    CacheHelper.saveData(key: 'offBoard', value: true).then((value) {
      navigateAndFinish(context, const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Text(
              'SKIP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: submit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  if (index == onBoardPages.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    title: onBoardPages[index].title,
                    subtitle: onBoardPages[index].subtitle,
                    imgPath: onBoardPages[index].imgPath,
                  );
                },
                itemCount: onBoardPages.length,
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: onBoardPages.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.deepOrange,
                    dotWidth: 10.0,
                    dotHeight: 10.0,
                    radius: 10.0,
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      pageController.nextPage(
                        duration: const Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: isLast
                      ? const Icon(
                          IconData(0xe3b2, fontFamily: 'MaterialIcons'))
                      : const Icon(Icons.arrow_forward_ios_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
