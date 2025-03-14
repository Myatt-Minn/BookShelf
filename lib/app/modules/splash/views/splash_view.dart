import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_book_shelf/app/data/consts_config.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).primaryColor, // Set the background color
      body: SafeArea(
        child: Stack(
          children: [
            // Logo and centered text
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ConstsConfig
                        .splashLogo, // Replace with the path to your logo image
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    ConstsConfig.appname, // Replace with your app name
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 100),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 50),
                ],
              ),
            ),

            // Footer section
            const Positioned(
              top: 10,
              right: 10,
              child: Center(
                child: Text(
                  'Version: 1.0.0-beta.1', // Replace with your desired footer text
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const Positioned(
              bottom: 14,
              right: 0,
              left: 0,
              child: Center(
                child: Text(
                  '© 2024 App.com.mm. All rights reserved.', // Updated copyright text, // Replace with your desired footer text
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
