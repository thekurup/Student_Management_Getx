import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../db_control/student.dart';

class HomeController extends GetxController {
  // Reactive variables - using RxBool and RxList from get package
  final isLoading = false.obs;
  final students = <Map<String, dynamic>>[].obs;
  
  // Database helper instance
  final DatabaseHelper dbHelper = DatabaseHelper();

  // Form controllers
  final nameController = TextEditingController();
  final placeController = TextEditingController();
  final contactController = TextEditingController();
  final selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchAllStudents();
  }

  @override
  void onClose() {
    nameController.dispose();
    placeController.dispose();
    contactController.dispose();
    super.onClose();
  }

  // Fetch all students method
  Future<void> fetchAllStudents() async {
    isLoading.value = true;
    try {
      final results = await dbHelper.searchAll('');
      students.value = results;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch students: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete student method
  Future<void> deleteStudent(int id) async {
    isLoading.value = true;
    try {
      final rowsDeleted = await dbHelper.delete(id);
      if (rowsDeleted > 0) {
        await fetchAllStudents();
        Get.snackbar(
          'Success',
          'Student deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete student: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update student method
  Future<void> updateStudent(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      final rowsUpdated = await dbHelper.update(data);
      if (rowsUpdated > 0) {
        await fetchAllStudents();
        Get.snackbar(
          'Success',
          'Student updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        clearForm();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update student: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form method
  void clearForm() {
    nameController.clear();
    placeController.clear();
    contactController.clear();
    selectedImage.value = null;
  }

  // Navigate to details
  void navigateToDetails(Map<String, dynamic> student) {
    Get.toNamed('/details', arguments: student);
  }
}