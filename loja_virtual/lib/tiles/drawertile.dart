import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final _iconData;
  final _textData;
  final PageController _pageController;
  final int page;
  DrawerTile(this._iconData, this._textData, this._pageController, this.page);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          _pageController.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              Icon(_iconData,
                  size: 32.0,
                  color: _pageController.page.round() == page
                      ? Colors.blue
                      : Colors.black),
              SizedBox(
                width: 32.0,
              ),
              Text(
                _textData,
                style: TextStyle(
                    fontSize: 16.0,
                    color: _pageController.page.round() == page
                        ? Colors.blue
                        : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
