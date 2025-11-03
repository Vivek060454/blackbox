import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_string.dart';
import 'app_text.dart';

class NoDataFoundHelper extends StatelessWidget {
  const NoDataFoundHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        text: AppString.noDataFound,
        fontSize: 14.dp,
      ),
    );
  }
}
