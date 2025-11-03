import 'package:get/get.dart';
import '../../../model/transaction_model.dart';
import '../../../utils/app_color.dart';
import '../service/database_service.dart';
import '../service/location_service.dart';
import '../../../helper/snach_bar.dart';
import '../../../utils/app_string.dart';
import '../../../utils/status_strings.dart';

class TransactionController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;
  final LocationService _locationService = LocationService();

  final transactions = <TransactionModel>[].obs;
  final isLoading = false.obs;
  
  // Filter controllers
  final selectedDispenserFilter = ''.obs;
  final selectedPaymentModeFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    isLoading.value = true;
    try {
      List<TransactionModel> result;
      
      if (selectedDispenserFilter.value.isEmpty && selectedPaymentModeFilter.value.isEmpty) {
        result = await _databaseService.getAllTransactions();
      } else {
        result = await _databaseService.getFilteredTransactions(
          dispenserNo: selectedDispenserFilter.value.isEmpty ? null : selectedDispenserFilter.value,
          paymentMode: selectedPaymentModeFilter.value.isEmpty ? null : selectedPaymentModeFilter.value,
        );
      }
      
      transactions.value = result;
    } catch (e) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: StatusStrings.somethingWentWrong);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    isLoading.value = true;
    try {
      await _databaseService.insertTransaction(transaction);
      await loadTransactions();
      AppSnackBar.showSnackBar(
        title: StatusStrings.success,
        message: AppString.transactionSavedSuccessfully,
        backgroundColor: AppColors.successGreen,
      );
      Get.back();
    } catch (e) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: StatusStrings.somethingWentWrong);
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, double>?> getLocation() async {
    try {
      return await _locationService.getLocation();
    } catch (e) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: AppString.failedToGetLocationShort);
      return null;
    }
  }

  void applyFilters(String? dispenserNo, String? paymentMode) {
    selectedDispenserFilter.value = dispenserNo ?? '';
    selectedPaymentModeFilter.value = paymentMode ?? '';
    loadTransactions();
  }

  void clearFilters() {
    selectedDispenserFilter.value = '';
    selectedPaymentModeFilter.value = '';
    loadTransactions();
  }
}

