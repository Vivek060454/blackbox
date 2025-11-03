
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helper/snach_bar.dart';
import '../../../model/transaction_model.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_string.dart';
import '../../../utils/status_strings.dart';
import '../../../widget/app_text.dart';
import '../../../widget/ripple_effect_click_widget.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 13.sp),
      padding: EdgeInsets.symmetric(
        horizontal: 16.sp,
        vertical: 13.sp,
      ),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.sp),
        border: Border.all(color: AppColors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: transaction.vehicleNumber.toUpperCase(),
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: transaction.dispenserNo,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              AppText(
                text: '${AppString.quantity}: ${transaction.quantityFilled} L',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: AppColors.grey,
              ),
            ],
          ),
          Row(
            children: [
              AppText(
                text: "${AppString.payment}: ",
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              AppText(
                text: transaction.paymentMode,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: AppColors.grey,
              ),
            ],
          ),
          Row(
            children: [
              AppText(
                text: "${AppString.date}: ",
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              AppText(
                text: _formatDate(transaction.createdAt),
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: AppColors.grey,
              ),
            ],
          ),
          Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyRippleEffectWidget(
                onTap: () {
                  _showLocationDialog(context, transaction);
                },
                child: Image.asset(
                  "assets/map.jpg",
                  height: size.height * 0.03,
                ),
              ),
              transaction.paymentProofPath != null
                  ? MyRippleEffectWidget(
                onTap: () {
                  _openAttachment(transaction.paymentProofPath!);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.attachment,
                      color: AppColors.primaryRed,
                    ),
                    AppText(
                      text: AppString.viewAttachment,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showLocationDialog(BuildContext context, transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          text: AppString.locationDetails,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(AppString.latitude, transaction.latitude.toStringAsFixed(6)),
            _buildDetailRow(AppString.longitude, transaction.longitude.toStringAsFixed(6)),
            SizedBox(height: 16.sp),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _openMap(transaction.latitude, transaction.longitude);
                },
                icon: const Icon(Icons.map),
                label: AppText(
                  text: AppString.viewLocation,
                  fontSize: 14.sp,
                  color: AppColors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.sp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppText(
              text: 'Close',
              fontSize: 16.sp,
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _openMap(double latitude, double longitude) async {
    final urls = [
      Uri.parse('comgooglemaps://?q=$latitude,$longitude&center=$latitude,$longitude'),
      Uri.parse('google.navigation:q=$latitude,$longitude'),
      Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude'),
      Uri.parse('https://www.google.com/maps?q=$latitude,$longitude'),
      Uri.parse('https://maps.google.com/?q=$latitude,$longitude'),
    ];

    for (final url in urls) {
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          return;
        }
      } catch (e) {
        continue;
      }
    }

    try {
      final webUrl = Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      AppSnackBar.showSnackBar(
        title: StatusStrings.error,
        message: AppString.couldNotOpenMap,
      );
    }
  }
}
Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: AppText(text:
            '$label:',
              fontWeight: FontWeight.w600,
          fontSize: 16.sp,),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}


Future<void> _openAttachment(String filePath) async {
  try {
    final file = File(filePath);
    if (await file.exists()) {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        AppSnackBar.showSnackBar(
          title: StatusStrings.error,
          message: 'Failed to open file: ${result.message}',
        );
      }
    } else {
      AppSnackBar.showSnackBar(
        title: StatusStrings.error,
        message: AppString.fileNotFound,
      );
    }
  } catch (e) {
    AppSnackBar.showSnackBar(
      title: StatusStrings.error,
      message: '${AppString.failedToOpenFile}: ${e.toString()}',
    );
  }
}
