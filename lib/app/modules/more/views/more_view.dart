import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/more_controller.dart';

class MoreView extends GetView<MoreController> {
  const MoreView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.settings_accessibility),
        title: Text(
          "more".tr,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // More Options List
            Expanded(
              child: Column(
                children: [
                  _buildMoreOption(
                    icon: Icons.favorite,
                    title: 'favorites'.tr,
                    onTap: () => Get.toNamed('/favourites'),
                  ),
                  _buildMoreOption(
                    icon: Icons.star_rate_rounded,
                    title: 'give_rating_play_store'.tr,
                    onTap:
                        () => controller.openUrl(
                          "https://play.google.com/store/apps/details?id=YOUR_APP_ID",
                        ),
                  ),
                  _buildMoreOption(
                    icon: Icons.share_rounded,
                    title: "share_app".tr,
                    onTap: () {},
                  ),
                  _buildMoreOption(
                    icon: Icons.apps_rounded,
                    title: "other_app".tr,
                    onTap:
                        () => controller.openUrl(
                          "https://play.google.com/store/apps/developer?id=YOUR_COMPANY_ID",
                        ),
                  ),
                  _buildMoreOption(
                    icon: Icons.feedback_rounded,
                    title: "give_suggestions".tr,
                    onTap: () {
                      // controller.uploadFeedbackToSupabase(feedback);
                    },
                  ),
                  _buildMoreOption(
                    icon: Icons.info_rounded,
                    title: "credits".tr,
                    onTap:
                        () => Get.defaultDialog(
                          title: "Credits",
                          middleText: "Developed by Tech4mm",
                        ),
                  ),
                ],
              ),
            ),

            // Divider & Footer
            const Divider(thickness: 1),
            const SizedBox(height: 12),
            Column(
              children: [
                Text(
                  "Tech4mm",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Version: 1.1",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 28),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
