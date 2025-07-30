import 'package:flutter/material.dart';
import 'package:shopping/layout/app_layout.dart';
import 'package:shopping/screens/login/login_screen.dart';
import 'package:shopping/shared/app_theme.dart';
import 'package:shopping/shared/components/components.dart';
import 'package:shopping/shared/constraints/constants.dart';
import 'package:shopping/shared/models/boarding_model.dart';
import 'package:shopping/shared/network/local/cash_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();
  bool isLast = false;

  List<BoardingModel> boardingData = 
  [
    BoardingModel(
      image: 'assets/on_boarding/on_boarding1.png',
      title: 'Get it delivered',
      body: 'Shop from the comfort of your home and let us bring your orders to you. Our fast and reliable delivery service ensures your items arrive on time. Track your package in real-time and stay updated.',
    ),
    BoardingModel(
      image: 'assets/on_boarding/on_boarding2.png',
      title: 'Purchase online',
      body: 'Enjoy a seamless shopping experience with just a few taps. Browse thousands of products, add them to your cart, and check out securely. Your next favorite purchase is just a click away.',
    ),
    BoardingModel(
      image: 'assets/on_boarding/on_boarding3.png',
      title: 'Explore many products',
      body: 'Discover a diverse collection of products tailored to your needs. From daily essentials to unique finds, we’ve got it all. Shop with confidence and explore endless possibilities.',
    ),
  ];

  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
    if(value){
      if (token != null) {
        navigateTo(context, AppLayout());
      } else {
        navigateTo(context, LoginScreen());
      }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: Text(
              'SKIP',
              style: TextStyle(
                color: AppTheme().primaryColor,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boardingData.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) => buildBoardingItem(boardingData[index]),
                itemCount: boardingData.length,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                  SmoothPageIndicator(
                  count: boardingData.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5.0,
                  ),
                  controller: boardController,
                ),
                Spacer(),
                FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardController.nextPage(
                        duration: const Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_sharp,
                    
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget buildBoardingItem(BoardingModel boardingData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(
              boardingData.image,
            ),
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                boardingData.title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                boardingData.body,
                style: const TextStyle(
                  fontSize: 10.0,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}