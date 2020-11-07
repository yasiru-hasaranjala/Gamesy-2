import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 20),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        border: Border.all(color: kTextColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          icon: SvgPicture.asset("assets/icons/search.svg"),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
