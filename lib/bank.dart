import 'package:flutter/material.dart';

class Bank extends StatefulWidget {
  @override
  State<Bank> createState() => _BankState();
}

class _BankState extends State<Bank> {
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
                    title: "Payment Details",
                    children: [
                      buildDetailRow("A/c No:", "99908726913625"),
                      buildDetailRow("Bank:", "HDFC BANK LTD"),
                      buildDetailRow("IFSC CODE:", "HDFC0009136"),
                      buildDetailRow("Area:", "BHULANA VARANASI"),
                    ],
                  ),
                  SizedBox(height: 20),
              Container(
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
                child: Column(
                  children: [  Image.asset("assets/image/qr.jpg",fit: BoxFit.cover),
                    SizedBox(height: 10,),
                    Text("Payment QR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  ],
                ),
              ),
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
    List<Widget>? children,
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
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          SizedBox(height: 10),
          if (children != null) ...children,
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
