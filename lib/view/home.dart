// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:shopapp/view/onboarding.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controller/getdata.dart';
import '../model/itemmodel.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetData data = GetData();
  int activeIndex = 0;
  int currentIndex = 0;
  final controller = CarouselController();

  List<BannerAd> banner = [];

  List<Category> category = [];

  List<Product> product = [];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _onChangeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _getData() async {
    banner = await data.fetchBanner();
    product = await data.fetchProduct();
    category = await data.fetchCategory();
    await _cacheImages();
    setState(() {});
  }

  Future<void> _cacheImages() async {
    //cacheImagesBanner
    for (var image in banner) {
      await image.cacheImagesBanner();
    }
    //cacheImagesCategory
    for (var image in category) {
      await image.cacheImagesCategory();
    }
    //cacheImagesProduct
    for (var image in product) {
      await image.cacheImagesProduct();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shop App",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => Onboarding(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: banner.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 70, top: 70),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Stack(
                        children: [
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: CarouselSlider.builder(
                                itemCount: banner.length,
                                itemBuilder: (context, index, realIndex) {
                                  final urlImage = banner[index].localImagePath;
                                  return buildImage(urlImage, index);
                                },
                                options: CarouselOptions(
                                    height: 400,
                                    autoPlay: true,
                                    enableInfiniteScroll: false,
                                    autoPlayAnimationDuration:
                                        Duration(seconds: 2),
                                    enlargeCenterPage: true,
                                    onPageChanged: (index, reason) =>
                                        setState(() => activeIndex = index))),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 75,
                            child: buildIndicator(),
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              category.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 70, top: 70),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          return categoriesList(category[index]);
                        },
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      "Products",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              product.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 70, top: 70),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(
                      height: 720,
                      width: double.infinity,
                      child: GridView.builder(
                          itemCount: product.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 290,
                          ),
                          itemBuilder: (context, index) =>
                              productCard(product[index])),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black38,
        showUnselectedLabels: true,
        elevation: 10,
        currentIndex: currentIndex,
        onTap: _onChangeIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget buildImage(String? urlImage, int index) {
    if (urlImage == null) {
      return CircularProgressIndicator();
    }
    return Container(
      child: Image.file(File(urlImage), fit: BoxFit.fill),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: ExpandingDotsEffect(
            dotColor: Colors.white, activeDotColor: Colors.orange),
        activeIndex: activeIndex,
        count: banner.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);

  Widget categoriesList(Category category) {
    return Container(
      height: 130,
      width: 130,
      decoration: BoxDecoration(
          border: Border(
        right: BorderSide(color: Colors.black26),
        bottom: BorderSide(color: Colors.black26),
      )),
      child: Stack(
        children: [
          Image.file(
            File(category.localImagePath!),
            fit: BoxFit.fill,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                height: 30,
                color: Colors.grey,
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget productCard(Product product) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        right: BorderSide(color: Colors.black26),
        bottom: BorderSide(color: Colors.black26),
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (product.discount != 0)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 7.0),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                  ),
                  child: Text("${product.discount}% DISCOUNT"),
                ),
              ],
            ),
          product.localImagePath == null
              ? CircularProgressIndicator()
              : Image.file(
                  File(product.localImagePath!),
                  height: 150,
                ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 2),
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.price.toString(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              if (product.discount != 0)
                Text(
                  product.oldPrice.toString(),
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    product.isFav = !product.isFav;
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: product.isFav ? Colors.blue : Colors.grey,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
