import 'package:flutter/material.dart';

class GstPage extends StatefulWidget {
  @override
  _GstPageState createState() => _GstPageState();
}

class _GstPageState extends State<GstPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController customGstController = TextEditingController();
  double gstPercentage = 18.0; // Default GST %
  double gstAmount = 0.0;
  double totalAmount = 0.0;

  void calculateGST() {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    double gstRate = gstPercentage;

    if (customGstController.text.isNotEmpty) {
      gstRate = double.tryParse(customGstController.text) ?? gstPercentage;
    }

    gstAmount = (amount * gstRate) / 100;
    totalAmount = amount + gstAmount;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GST Calculator")),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF272626),
          image: DecorationImage(
            image: AssetImage("assets/image/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildInfoCard(
                    title: "Enter Amount",
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => calculateGST(),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildInfoCard(
                    title: "Select GST Rate",
                    child: Wrap(
                      spacing: 10,
                      children: [5, 12, 18, 28].map((rate) {
                        return ChoiceChip(
                          label: Text("$rate%"),
                          selected: gstPercentage == rate.toDouble(),
                          onSelected: (selected) {
                            setState(() {
                              gstPercentage = rate.toDouble();
                              customGstController.clear();
                              calculateGST();
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildInfoCard(
                    title: "Custom GST (%)",
                    child: TextField(
                      controller: customGstController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Custom GST",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => calculateGST(),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildInfoCard(
                    title: "Calculation Result",
                    child: Column(
                      children: [
                        Text("GST Amount: ₹${gstAmount.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Total Amount: ₹${totalAmount.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
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

  Widget buildInfoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
