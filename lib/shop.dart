import 'package:flutter/material.dart';
import 'ring.dart';
import 'home.dart';
import 'shop.dart';
import 'contact.dart';// Import the Ring screen

class Shop extends StatefulWidget {
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {


  final List<Map<String, String>> items = [
    {"title": "Mang Tika", "image": "assets/image/mang.jpg"},
    {"title": "Earing", "image": "assets/image/earing.jpg"},
    {"title": "Bali", "image": "assets/image/bali.jpg"},
    {"title": "Tops", "image": "assets/image/tops.jpg"},
    {"title": "Kanoti", "image": "assets/image/kanoti.jpg"},
    {"title": "Katiya", "image": "assets/image/katiya.jpg"},
    {"title": "Nath", "image": "assets/image/nath.jpg"},
    {"title": "Necklace", "image": "assets/image/necklace.jpg"},
    {"title": "Locket", "image": "assets/image/locket.jpg"},
    {"title": "Double Locket", "image": "assets/image/dl.jpg"},
    {"title": "Single Locket", "image": "assets/image/sl.jpg"},
    {"title": "Chain", "image": "assets/image/ch.jpg"},
    {"title": "Tie Chain", "image": "assets/image/tc.jpg"},
    {"title": "Haar", "image": "assets/image/har.jpg"},
    {"title": "Long Haar", "image": "assets/image/lh.jpg"},
    {"title": "Chokar", "image": "assets/image/chokr.jpg"},
    {"title": "MS Patta", "image": "assets/image/msp.jpg"},
    {"title": "Short MS Patta", "image": "assets/image/sms.jpg"},
    {"title": "Ring", "image": "assets/image/ring.jpg"},
    {"title": "Jodha Ring", "image": "assets/image/jr.jpg"},
    {"title": "Turkish Ring", "image": "assets/image/tr.jpg"},
    {"title": "Men's Ring", "image": "assets/image/mr.jpg"},
    {"title": "Bracelet", "image": "assets/image/brac.jpg"},
    {"title": "Kada", "image": "assets/image/kad.jpg"},
  ];

  void _onItemClick(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RingPage(category: items[index]['title']!), // Match Cloudinary format
      ),
    );
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                color: Colors.white,
                shadowColor: Colors.white,
                child: InkWell(
                  onTap: () => _onItemClick(index),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.asset(
                            items[index]['image']!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          items[index]['title']!,
                          style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold,color: Color(0xFFC39660),),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),

    );
  }
}
