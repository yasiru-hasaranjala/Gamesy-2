import 'package:agora_flutter_quickstart/screens/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:agora_flutter_quickstart/screens/as_admin.dart';
import 'package:agora_flutter_quickstart/screens/create_event.dart';
import 'package:agora_flutter_quickstart/screens/scheduled.dart';
import 'package:agora_flutter_quickstart/screens/watch_now.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';

class Home extends StatefulWidget {

  final titles = ['New Event', 'Watch Now', 'As admin', 'Scheduled'];
  final colors = [kPrimaryColor,kPrimaryColor,Colors.indigo,kPrimaryColor];
  final icons = [
    Icons.playlist_add,
    Icons.play_circle_outline,
    Icons.adjust,
    Icons.date_range,
  ];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  PageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;

  @override
  void initState() {
    _menuPositionController = MenuPositionController(initPosition: 0);

    _pageController = PageController(
        initialPage: 0,
        keepPage: false,
        viewportFraction: 1.0
    );
    _pageController.addListener(handlePageChange);

    super.initState();
  }

  void handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  void checkUserDragging(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification && scrollNotification.direction != ScrollDirection.idle) {
      userPageDragging = true;
    } else if (scrollNotification is ScrollEndNotification) {
      userPageDragging = false;
    }
    if (userPageDragging) {
      _menuPositionController.findNearestTarget(_pageController.page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        endDrawer: DrawerRight(),
        body: NotificationListener<ScrollNotification>(
          // ignore: missing_return
          onNotification: (scrollNotification) {
            checkUserDragging(scrollNotification);
          },
          child: PageView(
            controller: _pageController,
            //children: widget.colors.map((Color c) => Container(color: c)).toList(),
            children: <Widget>[
              CreateEvent(),
              WatchNow(),
              AsAdmin(),
              Scheduled(),
            ],
            onPageChanged: (page) {
            },
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(top: 10.0,bottom: 8),
          decoration: BoxDecoration(
            color: kLightColor,
            borderRadius: BorderRadius.only(
              topRight:  Radius.circular(25),
              topLeft:  Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: kShadowColor,
                spreadRadius: 0.3,
                blurRadius: 3,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: BubbledNavigationBar(
            controller: _menuPositionController,
            initialIndex: 0,
            itemMargin: EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: kLightColor,
            defaultBubbleColor: kPrimaryColor,
            onTap: (index) {
              _pageController.animateToPage(
                  index,
                  curve: Curves.easeInOutQuad,
                  duration: Duration(milliseconds: 300)
              );
            },
            items: widget.titles.map((title) {
              var index = widget.titles.indexOf(title);
              var color = widget.colors[index];
              return BubbledNavigationBarItem(
                icon: getIcon(index, color),
                activeIcon: getIcon(index, kLightColor),
                bubbleColor: color,
                title: Text(
                  title,
                  style: TextStyle(color: kLightColor, fontSize: 12),
                ),
              );
            }).toList(),
          ),
        )
      ),
    );
  }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Icon(widget.icons[index], size: 30, color: color),
    );
  }
}
