import 'package:flutter/cupertino.dart';

extension SizeExtensions on BuildContext {
  Size get size => MediaQuery.of(this).size;
  double get width => MediaQuery.of(this).size.width;
  double get heigth => MediaQuery.of(this).size.height;
}
