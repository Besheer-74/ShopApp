// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'signUp.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Map<String, String>> boardingPages = [
      {
        "ImageUrl": "assets/images/on_board1.png",
        "Title": "SHOP ONLINE",
        "SubTitle": "Shop Now!"
      },
      {
        "ImageUrl": "assets/images/on_board2.png",
        "Title": "TRACK YOUR ORDER",
        "SubTitle": "Order become easy!"
      },
      {
        "ImageUrl": "assets/images/on_board3.png",
        "Title": "GET YOUR ORDER",
        "SubTitle": "Let's start!"
      }
    ];
    final PageController _pageController = PageController();
    int pagesLength = 1;

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: Text(
                  "SKIP",
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          Expanded(
            child: PageView.builder(
              itemCount: boardingPages.length,
              controller: _pageController,
              itemBuilder: (context, index) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  pageLayout(
                      image: boardingPages[index]["ImageUrl"]!,
                      title: boardingPages[index]["Title"]!,
                      subTitle: boardingPages[index]["SubTitle"]!),
                ],
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 65),
              SmoothPageIndicator(
                controller: _pageController,
                count: boardingPages.length,
                effect: const ExpandingDotsEffect(dotWidth: 10, dotHeight: 10),
              ),
              Spacer(),
              FloatingActionButton(
                onPressed: () {
                  pagesLength++;
                  pagesLength > 3
                      ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()))
                      : _pageController.nextPage(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                        );
                },
                backgroundColor: Colors.indigo,
                child: Icon(
                  Icons.navigate_next_sharp,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(width: 30)
            ],
          ),
          SizedBox(height: 25)
        ],
      )),
    );
  }

  Widget pageLayout({
    required String image,
    required String title,
    required String subTitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          image,
          height: 300,
        ),
        SizedBox(height: 70),
        Text(
          title,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          subTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
