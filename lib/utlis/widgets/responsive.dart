import 'package:flutter/cupertino.dart';

class Responsive {
  final BuildContext context;
  final double _width;
  final double _height;

  Responsive(this.context)
      : _width = MediaQuery.of(context).size.width,
        _height = MediaQuery.of(context).size.height;

  double wp(double percent) => _width * (percent / 100);
  double hp(double percent) => _height * (percent / 100);

  /// Responsive font with a max limit
  double sp(double percent, {double max = 22}) {
    final size = _width * (percent / 100);
    return size > max ? max : size; // Prevent oversized fonts
  }
}

