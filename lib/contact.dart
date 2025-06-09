import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:om_ornament/address.dart';
import 'package:om_ornament/bank.dart';
import 'package:om_ornament/gst.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home.dart';
import 'shop.dart';

class Contact extends StatefulWidget {
  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  int _selectedIndex = 2; // Default to Contact page

  final List<Widget> _pages = [
    Home(),
    Shop(),
    Contact(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Get.off(_pages[index]);

    }
  }

  void onItemClick(int index) {
    if (index == 0) {
      Get.to (() => GstPage());
    } else if (index == 1) {
      Get.to ( () => Bank());
    } else {
      Get.to (() => Address()); // Corrected
    }
  }

  List<Map<String, String>> images = [
    {'image': 'assets/image/gst.jpg', 'Title': 'Gst Calculator'},
    {'image': 'assets/image/bank.jpg', 'Title': 'Bank Detail'},
    {'image': 'assets/image/detail.jpg', 'Title': 'Contact'}, // Corrected title
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF272626),
          image: DecorationImage(
            image: AssetImage("assets/image/bgn.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                elevation: 5,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => onItemClick(index), // Fixed: Pass function reference
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset(images[index]['image']!),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      images[index]['Title']!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color:  Color(0xFF4F250B)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),


    );
  }
}
