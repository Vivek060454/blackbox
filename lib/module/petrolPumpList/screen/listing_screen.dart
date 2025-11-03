import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petrolpumpdispensing/utils/app_color.dart';
import 'package:petrolpumpdispensing/widget/app_text.dart';
import 'package:petrolpumpdispensing/widget/ripple_effect_click_widget.dart';
import 'package:sizer/sizer.dart';
import '../controller/transaction_controller.dart';
import '../service/database_service.dart';
import '../../auth/service/auth_service.dart';
import '../../../utils/app_string.dart';
import '../../../utils/status_strings.dart';
import '../../../helper/check_internet_connection.dart';
import '../../../helper/snach_bar.dart';
import '../../../helper/internet_realtime_connection.dart';
import '../../../helper/shared_prefrence.dart';
import '../widget/transaction_card.dart';

class ListingScreen extends StatelessWidget {
  ListingScreen({super.key});

  final TransactionController controller = Get.find<TransactionController>();
  final AuthService _authService = AuthService();

  NetworkController get networkController {
    if (Get.isRegistered<NetworkController>()) {
      return Get.find<NetworkController>();
    } else {
      return Get.put(NetworkController());
    }
  }

  String _getUserInitial() {
    final email = AppSharedPreference.email ?? _authService.currentUser?.email ?? '';
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: size.width * 0.18,
        leading:
        Padding(
          padding:  EdgeInsets.symmetric(vertical: 8.sp,horizontal: 16
              .sp),
          child: CircleAvatar(
            backgroundColor: AppColors.white,
            radius: 18.sp,
            child: AppText(
              text: _getUserInitial(),
              color: AppColors.primaryRed,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        title: AppText(
          text: AppString.allTransactions,
          color: AppColors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        actions: [
          SizedBox(width: 8.sp),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            color: AppColors.white,
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (BuildContext context) => [
               PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.primaryRed),
                    SizedBox(width: 8),
                    Text(AppString.logout),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: _buildNetworkIndicator(size),
      body: Column(
        children: [
          _buildFilters(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.transactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 80,
                        color: AppColors.mediumGrey,
                      ),
                      const SizedBox(height: 16),
                      AppText(text:
                        AppString.noDataFound,
                        fontSize: 16.sp,
                        color: AppColors.darkGrey,
                      ),
                      const SizedBox(height: 16),

                      MyRippleEffectWidget(
                          onTap: (){
                            Get.toNamed('/entry-details');

                          },
                          child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.sp,horizontal: 16.sp),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(13.sp)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(text: AppString.letStart,fontWeight: FontWeight.w500,color: AppColors.white,),
                            SizedBox(width: 10.sp,),
                            Icon(Icons.arrow_right_alt,color: AppColors.white,)
                          ],
                        ),
                      ))
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = controller.transactions[index];
                  return TransactionCard(transaction: transaction,);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/entry-details');
        },
        backgroundColor: AppColors.primaryRed,
        icon:  Icon(Icons.add, color: AppColors.white),
        label: AppText(
          text: AppString.addEntry,
          color: AppColors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNetworkIndicator(Size size) {
    return Obx(() {
      if (!networkController.isConnected.value) {
        return Container(
          height: size.height * 0.022,
          width: size.width,
          decoration:  BoxDecoration(color: AppColors.errorColor),
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
          decoration:  BoxDecoration(color: AppColors.successGreen),
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

  Widget _buildFilters(BuildContext context) {
    final List<String> dispenserOptions = [
      'Dispenser 1',
      'Dispenser 2',
      'Dispenser 3',
      'Dispenser 4',
    ];
    final List<String> paymentModeOptions = ['Cash', 'Credit Card', 'UPI'];
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(16.sp),
      color: AppColors.lightGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedDispenserFilter.value.isEmpty
                        ? null
                        : controller.selectedDispenserFilter.value,
                    decoration: InputDecoration(
                      labelText: AppString.filterByDispenser,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.sp,
                        vertical: 12.sp,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: AppText(text: AppString.all, fontSize: 15.sp),
                      ),
                      ...dispenserOptions.map(
                        (option) => DropdownMenuItem<String>(
                          value: option,
                          child: AppText(text: option, fontSize: 15.sp),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      controller.applyFilters(
                        value ?? '',
                        controller.selectedPaymentModeFilter.value,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedPaymentModeFilter.value.isEmpty
                        ? null
                        : controller.selectedPaymentModeFilter.value,
                    decoration: InputDecoration(
                      labelText: AppString.filterByPayment,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.sp,
                        vertical: 12.sp,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: AppText(text: AppString.all, fontSize: 15.sp),
                      ),
                      ...paymentModeOptions.map(
                        (option) => DropdownMenuItem<String>(
                          value: option,
                          child: AppText(text: option, fontSize: 15.sp),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      controller.applyFilters(
                        controller.selectedDispenserFilter.value,
                        value ?? '',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          Obx(() {
            if (controller.selectedDispenserFilter.value.isNotEmpty ||
                controller.selectedPaymentModeFilter.value.isNotEmpty) {
              return SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.clearFilters,
                  icon: Icon(Icons.clear, size: 18.sp),
                  label: AppText(text: AppString.clearFilters, fontSize: 13.sp),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }








  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  AppText(text: AppString.logout,fontSize: 19.sp,fontWeight: FontWeight.w600,),
          content:  AppText(text: AppString.areYouSureLogout,fontSize: 16.sp,),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppString.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();

                if (!await CheckInternetConnection().internetAvailable()) {
                  AppSnackBar.noInterNetSnackBar();
                  return;
                }

                // Clear database
                try {
                  await DatabaseService.instance.clearAllTransactions();
                } catch (e) {
                  // Continue with logout even if clearing database fails
                }

                await _authService.signOut();
                Get.offAllNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
              ),
              child: Text(AppString.ok),
            ),
          ],
        );
      },
    );
  }
}