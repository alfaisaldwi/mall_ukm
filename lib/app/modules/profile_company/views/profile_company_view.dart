import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mall_ukm/app/style/styles.dart';

import '../controllers/profile_company_controller.dart';

class ProfileCompanyView extends GetView<ProfileCompanyController> {
  var _profileController = Get.put(ProfileCompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Syarat dan Ketentuan ',
          style: Styles.headerStyles(weight: FontWeight.w500, size: 16),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white, // Tambahkan background putih
        child: Obx(
          () => _profileController.profileCompany.value.id != null
              ? Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Syarat dan Ketentuan:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            _profileController.profileCompany.value.terms!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Kondisi Penggunaan:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            _profileController.profileCompany.value.conditions!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
