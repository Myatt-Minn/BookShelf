import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_book_shelf/app/modules/gate/controllers/gate_controller.dart';

import '../controllers/no_internet_controller.dart';

class NoInternetView extends GetView<NoInternetController> {
  const NoInternetView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Internet Connection'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/no_connection.jpg', height: 200),
            const SizedBox(height: 20),
            const Text(
              'You are not connected to the internet.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.find<GateController>().retryConnection();
              },
              child: Obx(
                () =>
                    (Get.find<GateController>().isLoading.value)
                        ? const CircularProgressIndicator()
                        : const Text('Try Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
