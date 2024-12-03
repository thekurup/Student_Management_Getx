import 'dart:io';
import 'package:get/get.dart';
import '../db_control/student.dart';

class DetailsController extends GetxController {
  // Database helper instance
  final DatabaseHelper dbHelper = DatabaseHelper();

  // Reactive variables to store student details
  final RxString name = ''.obs;
  final RxString place = ''.obs;
  final RxInt contact = 0.obs;
  final Rx<String?> imagePath = Rx<String?>(null);
  final RxInt studentId = 0.obs;  // Added to track the student's ID

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      loadStudentDetails(Get.arguments);
    }
  }

  // Enhanced method to load student details
  void loadStudentDetails(Map<String, dynamic> studentData) {
    studentId.value = studentData['id'] ?? 0;
    name.value = studentData['name'] ?? '';
    place.value = studentData['place'] ?? '';
    contact.value = studentData['contact'] ?? 0;
    imagePath.value = studentData['imagePath'];
  }

  // Added method to update student details in database
  Future<void> updateStudentDetails() async {
    try {
      final studentData = {
        'id': studentId.value,
        'name': name.value,
        'place': place.value,
        'contact': contact.value,
        'imagePath': imagePath.value,
      };

      final result = await dbHelper.update(studentData);
      if (result > 0) {
        Get.snackbar(
          'Success',
          'Student details updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update student details: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Added method to delete student
  Future<void> deleteStudent() async {
    try {
      final result = await dbHelper.delete(studentId.value);
      if (result > 0) {
        Get.snackbar(
          'Success',
          'Student deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/home');  // Navigate back to home after deletion
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete student: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Existing methods remain the same
  bool doesImageExist() {
    if (imagePath.value != null) {
      return File(imagePath.value!).existsSync();
    }
    return false;
  }

  String getFormattedContact() {
    return contact.value.toString();
  }

  void goBack() {
    Get.back();
  }
}