
import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xfff33f19),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
final BoxDecoration avatarDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.grey.shade200,
    boxShadow: [
      BoxShadow(
        color: Colors.white,
        offset: Offset(10, 10),
        blurRadius: 10,
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-10, -10),
        blurRadius: 10,
      ),
    ]
);

final Color ColorBar=Color(0xfff33133);

double widthScree(context){
  return MediaQuery.of(context).size.width;
}
double heightScree(context){
  return MediaQuery.of(context).size.height;
}
