import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AutoScrollable extends StatefulWidget {
  List<Widget> widgetList;
  int listHeight;

  AutoScrollable(this.widgetList, this.listHeight);

  @override
  State<AutoScrollable> createState() => _AutoScrollableState();
}

class _AutoScrollableState extends State<AutoScrollable> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      infiniteScrollLoop(300, 4, _scrollController);
    });
  }

  void infiniteScrollLoop(double scrollDistance, int sec,
      ScrollController scrollController) {
    scrollController.animateTo(scrollDistance,
        duration: Duration(seconds: sec), curve: Curves.linear).then((value) {
      infiniteScrollLoop(scrollDistance + 300, sec, scrollController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.black, // You can adjust this color as needed
              Colors.black,
              Colors.transparent,
            ],
            stops: [0.0, 0.1, 0.9, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemBuilder: (context, index) {
            return widget.widgetList[index % widget.widgetList.length];
          },
        ),
      ),
    );
  }
}
