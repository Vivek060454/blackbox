import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../model/transaction_model.dart';
import 'transaction_controller.dart';
import '../service/location_service.dart';
import '../../../helper/snach_bar.dart';
import '../../../utils/app_string.dart';
import '../../../utils/status_strings.dart';

class EntryDetailsController extends GetxController {
  final LocationService _locationService = LocationService();
  
  TransactionController get _transactionController {
    if (Get.isRegistered<TransactionController>()) {
      return Get.find<TransactionController>();
    } else {
      return Get.put(TransactionController());
    }
  }

  // Form controllers
  final selectedDispenser = ''.obs;
  final quantityController = ''.obs;
  final vehicleNumberController = ''.obs;
  final selectedPaymentMode = ''.obs;
  final paymentProofPath = ''.obs;
  final isPdfFile = false.obs;

  final isLoading = false.obs;
  final isCapturingLocation = false.obs;

  // Options
  final List<String> dispenserOptions = [
    'Dispenser 1',
    'Dispenser 2',
    'Dispenser 3',
    'Dispenser 4',
  ];

  final List<String> paymentModeOptions = [
    'Cash',
    'Credit Card',
    'UPI',
  ];

  void setDispenser(String? value) {
    selectedDispenser.value = value??"";
  }

  void setPaymentMode(String? value) {
    selectedPaymentMode.value = value??"";
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      
      if (image != null) {
        paymentProofPath.value = image.path;
        isPdfFile.value = false;
      }
    } catch (e) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: AppString.failedToPickImage);
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        paymentProofPath.value = image.path;
        isPdfFile.value = false;
      }
    } catch (e) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: AppString.failedToPickImage);
    }
  }

  Future<void> pickPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        paymentProofPath.value = result.files.single.path!;
        isPdfFile.value = true;
      }
    } catch (e) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: AppString.failedToPickPdf);
    }
  }

  void clearPaymentProof() {
    paymentProofPath.value = '';
    isPdfFile.value = false;
  }

  Future<void> saveTransaction() async {
    if (selectedDispenser.value.isEmpty) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: AppString.pleaseSelectDispenser);
      return;
    }

    if (quantityController.value.trim().isEmpty) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: AppString.pleaseEnterQuantity);
      return;
    }

    final quantity = double.tryParse(quantityController.value.trim());
    if (quantity == null || quantity <= 0) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: AppString.pleaseEnterValidQuantity);
      return;
    }

    if (vehicleNumberController.value.trim().isEmpty) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: AppString.pleaseEnterVehicleNumber);
      return;
    }

    if (selectedPaymentMode.value.isEmpty) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: AppString.pleaseSelectPaymentMode);
      return;
    }

    isLoading.value = true;
    isCapturingLocation.value = true;

    try {
      // Get location
      final location = await _locationService.getLocation();
      
      if (location == null) {
        AppSnackBar.showSnackBar(title: StatusStrings.error, message: AppString.failedToGetLocation);
        isLoading.value = false;
        isCapturingLocation.value = false;
        return;
      }

      isCapturingLocation.value = false;

      final transaction = TransactionModel(
        dispenserNo: selectedDispenser.value,
        quantityFilled: quantity,
        vehicleNumber: vehicleNumberController.value.trim(),
        paymentMode: selectedPaymentMode.value,
        paymentProofPath: paymentProofPath.value.isEmpty ? null : paymentProofPath.value,
        latitude: location['latitude']!,
        longitude: location['longitude']!,
        createdAt: DateTime.now(),
      );

      await _transactionController.addTransaction(transaction);
      
      clearForm();
    } catch (e) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: StatusStrings.somethingWentWrong);
    } finally {
      isLoading.value = false;
      isCapturingLocation.value = false;
    }
  }

  void clearForm() {
    selectedDispenser.value = '';
    quantityController.value = '';
    vehicleNumberController.value = '';
    selectedPaymentMode.value = '';
    paymentProofPath.value = '';
    isPdfFile.value = false;
  }

  @override
  void onClose() {
    clearForm();
    super.onClose();
  }
}

