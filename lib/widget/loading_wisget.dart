import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class Loading extends StatelessWidget {
  final Color? colors;

  const Loading({this.colors, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          color: colors ?? AppColors.red,
        ),
      ),
    );
  }
}
