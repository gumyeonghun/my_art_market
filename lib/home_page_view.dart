import 'package:flutter/material.dart';
import 'package:my_art_market/home_page_appbar.dart';
import 'package:my_art_market/home_page_body.dart';
import 'package:my_art_market/pages/search_page.dart';
import 'package:my_art_market/pages/profile_page.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('MY ART MARKET', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize:25)),
        centerTitle: true,
        actions: [
          HomePageAppbar(),
        ],
      ),
      body:IndexedStack(
        index: index,
        children: [
          HomePageBody(),
          const SearchPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 115,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedFontSize: 20,
            selectedFontSize: 22,
            selectedItemColor: Colors.red,
            currentIndex: index,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home,size: 30,),label: '홈'),
              BottomNavigationBarItem(icon: Icon(Icons.search,size: 30,),label: '검색'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline,size: 30,),label: '마이페이지'),
            ]
        ),
      )
    );
  }
}
