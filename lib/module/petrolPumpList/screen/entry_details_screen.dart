import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petrolpumpdispensing/utils/app_color.dart';
import 'package:petrolpumpdispensing/widget/ripple_effect_click_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../widget/app_text.dart';
import '../controller/entry_details_controller.dart';
import '../../../helper/internet_realtime_connection.dart';
import '../../../utils/app_string.dart';
import '../../../utils/status_strings.dart';

class EntryDetailsScreen extends StatelessWidget {
  EntryDetailsScreen({super.key});

  final EntryDetailsController controller = Get.put(EntryDetailsController());
  final _formKey = GlobalKey<FormState>();

  NetworkController get networkController {
    if (Get.isRegistered<NetworkController>()) {
      return Get.find<NetworkController>();
    } else {
      return Get.put(NetworkController());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: AppString.addTransaction,
          color: AppColors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
      ),
      bottomSheet: _buildNetworkIndicator(size),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(19.sp),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedDispenser.value.isEmpty
                            ? null
                            : controller.selectedDispenser.value,
                        decoration: InputDecoration(
                          labelText: AppString.dispenserNo,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.local_gas_station),
                        ),
                        items: controller.dispenserOptions
                            .map(
                              (option) => DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                        onChanged: controller.setDispenser,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppString.pleaseSelectDispenser;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.023),

                    TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: AppString.quantityFilled,
                        hintText: AppString.quantityExample,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.water_drop),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        final quantity = double.tryParse(value);
                        if (quantity == null || quantity <= 0) {
                          return 'Please enter a valid quantity';
                        }
                        return null;
                      },
                      onChanged: (value) =>
                          controller.quantityController.value = value,
                    ),
                    SizedBox(height: size.height * 0.023),

                    // Vehicle Number
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: AppString.vehicleNumber,
                        hintText: 'Enter vehicle registration number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primaryRed,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primaryRed),
                        ),
                        prefixIcon: const Icon(Icons.directions_car),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppString.pleaseEnterVehicleNumber;
                        }

                        final pattern = r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$';
                        final regExp = RegExp(pattern);

                        if (!regExp.hasMatch(
                          value.toUpperCase().replaceAll(' ', ''),
                        )) {
                          return AppString.enterValidVehicleNumber;
                        }

                        return null;
                      },
                      onChanged: (value) =>
                          controller.vehicleNumberController.value = value
                              .toUpperCase(),
                    ),
                    SizedBox(height: size.height * 0.023),

                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedPaymentMode.value.isEmpty
                            ? null
                            : controller.selectedPaymentMode.value,
                        decoration: InputDecoration(
                          labelText: AppString.paymentMode,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.payment),
                        ),
                        items: controller.paymentModeOptions
                            .map(
                              (option) => DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                        onChanged: controller.setPaymentMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppString.pleaseSelectPaymentMode;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.023),

                    AppText(
                      text: AppString.paymentProof,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: size.height * 0.015),
                    OutlinedButton.icon(
                      onPressed: () {
                        _showAttachmentOptions(context);
                      },
                      icon: const Icon(Icons.attach_file),
                      label: AppText(
                        text: AppString.addAttachment,
                        fontSize: 14.sp,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.sp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.016),

                    Obx(() {
                      if (controller.paymentProofPath.value.isNotEmpty) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                if (!controller.isPdfFile.value)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(controller.paymentProofPath.value),
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.lightRed,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.picture_as_pdf,
                                      size: 40,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.isPdfFile.value
                                            ? AppString.pdfSelected
                                            : AppString.imageSelected,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        controller.paymentProofPath.value
                                            .split('/')
                                            .last,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.darkGrey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: controller.clearPaymentProof,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    }),

                    SizedBox(height: size.height * 0.023),

                    // Save Button
                    Obx(
                      () => ElevatedButton(
                        onPressed:
                            (controller.isLoading.value ||
                                controller.isCapturingLocation.value)
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  controller.saveTransaction();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isCapturingLocation.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  AppText(text: AppString.capturingLocation),
                                ],
                              )
                            : controller.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : AppText(
                                text: AppString.saveTransaction,
                                fontSize: 16.sp,
                                color: AppColors.white,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkIndicator(Size size) {
    return Obx(() {
      if (!networkController.isConnected.value) {
        return Container(
          height: size.height * 0.022,
          width: size.width,
          decoration: BoxDecoration(color: AppColors.errorColor),
          child: Center(
            child: AppText(
              text: StatusStrings.noInternetConnection,
              fontSize: 14.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else if (networkController.showBackOnline.value) {
        Future.delayed(const Duration(seconds: 3), () {
          networkController.showBackOnline.value = false;
        });
        return Container(
          height: size.height * 0.022,
          width: size.width,
          decoration: BoxDecoration(color: AppColors.successGreen),
          child: Center(
            child: AppText(
              text: StatusStrings.backOnline,
              fontSize: 14.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.sp,
                height: 8.sp,
                margin: EdgeInsets.only(bottom: 20.sp),
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2.sp),
                ),
              ),
              AppText(
                text: AppString.selectAttachmentSource,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20.sp),
              MyRippleEffectWidget(
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage();
                },
                child: _paymentProofWidget(
                  context,
                  AppString.camera,
                  Icons.camera_alt,
                ),
              ),
              MyRippleEffectWidget(
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImageFromGallery();
                },
                child: _paymentProofWidget(
                  context,
                  AppString.gallery,
                  Icons.photo_library,
                ),
              ),
              MyRippleEffectWidget(
                onTap: () {
                  Navigator.pop(context);
                  controller.pickPdf();
                },
                child: _paymentProofWidget(
                  context,
                  AppString.pdf,
                  Icons.picture_as_pdf,
                ),
              ),

              SizedBox(height: 10.sp),
            ],
          ),
        );
      },
    );
  }

  Widget _paymentProofWidget(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 13.sp),
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.sp),
        border: Border.all(color: AppColors.grey),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryRed, size: 24.sp),
          SizedBox(width: 24.sp),
          AppText(text: title, fontSize: 16.sp, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }
}
