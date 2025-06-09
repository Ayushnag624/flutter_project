import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Address extends StatefulWidget {
  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final double latitude = 25.314061;
  final double longitude = 83.011670;
  final String phoneNumber = "8765432109"; // Main contact
  final String phoneNumber2 = "7052748889"; // Alternative contact

  Future<void> _openMaps() async {
    String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackbar('Could not open the map');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {

      final Uri dialPadUri = Uri(scheme: "tel", path: phoneNumber);

      if (await canLaunchUrl(dialPadUri)) {
        await launchUrl(dialPadUri);
      } else {
        print('Could not open dial pad');
      }
    }


  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF272626),
          image: DecorationImage(
            image: AssetImage("assets/image/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  buildInfoCard(
                    title: "Address",
                    onPressed: _openMaps,
                    icon: Icons.location_on,
                    extraText: "C.K.20/8 Magala Bhawan (Sarda ji Katra Dosa wale Ground floor Thatheri bazar Chowk Varanasi)",
                    hasImage: true, // Show image for Address
                  ),
                  SizedBox(height: 20),
                  buildInfoCard(
                    title: "Contact",
                    children: [
                      Text("Amit Verma", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(height: 10),
                      buildPhoneRow(phoneNumber),
                      SizedBox(height: 10),
                      Text("Harsh Verma", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      SizedBox(height: 10),
                      buildPhoneRow(phoneNumber2),
                    ],
                    hasImage: false, // No image for Contact
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required String title,
    VoidCallback? onPressed,
    IconData? icon,
    String? extraText,
    List<Widget>? children,
    bool hasImage = false,
  }) {
    return Container(
      width: 320,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            SizedBox(height: 10),
            if (hasImage) // Conditionally display the image
              GestureDetector(
                onTap: onPressed,
                child: Container(
                  height: 120,

                  decoration: BoxDecoration(
                    border: Border.all(),
                    image: DecorationImage(
                      image: AssetImage("assets/image/map.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            if (hasImage) SizedBox(height: 10),
            if (extraText != null) ...[
              Row(
                children: [
                  Icon(icon ?? Icons.info, size: 40, color: Color(0xFF272626)),
                  SizedBox(width: 10),
                  Expanded(child: Text(extraText, style: TextStyle(fontSize: 16))),
                ],
              ),
            ],
            if (children != null) ...children,
          ],
        ),
      ),
    );
  }

  Widget buildPhoneRow(String number,
      {IconData icon = Icons.call, Color color = Colors.green}) {
    return GestureDetector(
      onTap: () => _makePhoneCall(number),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          SizedBox(width: 10),
          Text(
            number,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
