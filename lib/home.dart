import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:om_ornament/Signup.dart';
import 'package:om_ornament/address.dart';
import 'package:om_ornament/bank.dart';
import 'package:om_ornament/controller/navigationbarcontroller.dart';
import 'package:om_ornament/shop.dart';
import 'package:om_ornament/contact.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math'; // ✅ Import math functions


class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isAppReady = false;


  navigationcontroller controller= Get.put(navigationcontroller());
  Random random = Random();
  String gold = "", gold2 = "", silver = "", rtnl = "";
  var time= 0; String t= "";
  String updatet= "";
  String goldApi = "", silverApi = "";
  bool isLoading = true, hasError = false;

  double hg = 0, lg = double.infinity;
  double hg1 = 0, lg1 = double.infinity;
  double hs = 0, ls = double.infinity;
  double rth = 0, rtl = double.infinity;


  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 1;
  Timer? _timer;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loadSavedValues();
    fetchData();
    fetchMetalRates();
    _initializeApp();



    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      fetchMetalRates();
    });

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % 3;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void fetchData() {
    final databaseref = FirebaseDatabase.instance.ref("data/rates");
    databaseref.onValue.listen((event) {
      final dynamic rates = event.snapshot.value;
      print("Fetched Data: $rates");

      if (rates is Map) {
        setState(() {
          gold = rates["नंबर Rate"]?.toString() ?? "N/A";
          gold2 = rates["ब्रेड Rate"]?.toString() ?? "N/A";
          silver = rates["चांदी बटिया Rate"]?.toString() ?? "N/A";
          rtnl = rates["RTGS Rate"]?.toString() ?? "N/A";
          time = rates['time'] ?? 0;
          goldApi = rates["Gold api"]?.toString() ?? "N/A";
          silverApi = rates["Silver api"]?.toString() ?? "N/A";

          double? goldValue = double.tryParse(gold);
          double? goldValue2 = double.tryParse(gold2);
          double? silverValue = double.tryParse(silver);
          double? rtnlValue = double.tryParse(rtnl);
          updatet = formatTimestamp(time);


          // 🔹 Fix: Ensure high/low updates correctly on every fetch
          if (goldValue != null) {
            hg = hg == 0 ? goldValue : max(hg, goldValue);
            lg = lg == double.infinity ? goldValue : min(lg, goldValue);
          }
          if (goldValue2 != null) {
            hg1 = hg1 == 0 ? goldValue2 : max(hg1, goldValue2);
            lg1 = lg1 == double.infinity ? goldValue2 : min(lg1, goldValue2);
          }
          if (silverValue != null) {
            hs = hs == 0 ? silverValue : max(hs, silverValue);
            ls = ls == double.infinity ? silverValue : min(ls, silverValue);
          }
          if (rtnlValue != null) {
            rth = rth == 0 ? rtnlValue : max(rth, rtnlValue);
            rtl = rtl == double.infinity ? rtnlValue : min(rtl, rtnlValue);
          }

          saveMinMaxValues(); // Save updated values
        });
      }
    });
  }

  String formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} sec ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hrs ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";//////
    } else {
      return "${difference.inDays} days ago";
    }
  }


  Future<void> loadSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gold = prefs.getString('gold') ?? "N/A";
      gold2 = prefs.getString('gold2') ?? "N/A";
      silver = prefs.getString('silver') ?? "N/A";
      rtnl = prefs.getString('rtnl') ?? "N/A";

      // Load saved high & low values
      hg = prefs.getDouble('hg') ?? 0;
      lg = prefs.getDouble('lg') ?? double.infinity;
      hg1 = prefs.getDouble('hg1') ?? 0;
      lg1 = prefs.getDouble('lg1') ?? double.infinity;
      hs = prefs.getDouble('hs') ?? 0;
      ls = prefs.getDouble('ls') ?? double.infinity;
      rth = prefs.getDouble('rth') ?? 0;
      rtl = prefs.getDouble('rtl') ?? double.infinity;
    });
  }
  Future<void> saveMinMaxValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ensure values are saved correctly
    await prefs.setString('gold', gold ?? "N/A");
    await prefs.setString('gold2', gold2 ?? "N/A");
    await prefs.setString('silver', silver ?? "N/A");
    await prefs.setString('rtnl', rtnl ?? "N/A");

    await prefs.setDouble('hg', hg);
    await prefs.setDouble('lg', lg);
    await prefs.setDouble('hg1', hg1);
    await prefs.setDouble('lg1', lg1);
    await prefs.setDouble('hs', hs);
    await prefs.setDouble('ls', ls);
    await prefs.setDouble('rth', rth);
    await prefs.setDouble('rtl', rtl);

    // ✅ Fix: Store API values correctly
    await prefs.setString('goldApi', goldApi ?? "N/A");
    await prefs.setString('silverApi', silverApi ?? "N/A");
  }


  Future<void> fetchMetalRates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    goldApi = prefs.getString('goldApi') ?? "N/A";
    silverApi = prefs.getString('silverApi') ?? "N/A";
    setState(() {
      isLoading = true;
      hasError = false;
    });


    controller.goldApiValue.value = double.tryParse(goldApi) ?? 0.0;
    controller.silverApiValue.value = double.tryParse(silverApi) ?? 0.0;
    int changes = random.nextInt(41) - 20; // Random -20 to +20

    controller.updaterate(changes);
   isLoading= false;



  }




  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }



  void _signOut() async {
    await _auth.signOut();
    Get.off( Signup());
  }


  Future<void> _initializeApp() async {
    await loadSavedValues();
    await fetchMetalRates();
    fetchData();
    setState(() {
      _isAppReady = true;
    });
  }
  @override
  Widget build(BuildContext context) {

    final homepage = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/image/bgn.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: PageView(
                  controller: _pageController,
                  children: [
                    buildCard("assets/image/left.jpg",),
                    buildCard("assets/image/center.jpg", ),
                    buildCard("assets/image/right.jpg", ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text("updated $updatet", style: TextStyle(fontSize: 16,  color: Color(0xFF4F250B)))),
                    ),
                    buildListTile("99.99 Retail", "assets/image/gold.jpg", "नंबर", gold, hg,lg),
                    buildListTile("99.50 Retail", "assets/image/gold2.png", "ब्रेड", gold2, hg1, lg1),
                    buildListTile("99.99 Retail", "assets/image/silver.png", "चांदी बटिया", silver, hs, ls),
                    buildListTile("RTGS", "assets/image/gpay.png", "99.50 Inc. GST", rtnl, rth, rtl),

                    SizedBox(height: 10),
                    Text(" 📈  Live Rates", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color:Color(0xFF4F250B) )),

                    isLoading
                        ? CircularProgressIndicator()
                        : hasError
                        ? Text("Failed to fetch data", style: TextStyle(color: Colors.red))
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(()=> buildInfoCard(controller.goldApi.value, "assets/image/gold.jpg","GOLD")),
                        SizedBox(width: 30),
                        Obx(()=> buildInfoCard(controller.silverApi.value, "assets/image/silver.png","SILVER")),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final List<Widget>pages=
    [   homepage,
      Shop(),
      Contact(),



    ];

    return Obx(
        () => Scaffold(

        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset("assets/image/title.png",fit: BoxFit.cover, ),

          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF272626),
           centerTitle: true,

        ),

        body:IndexedStack(
          index: controller.selectedindex.value,
          children: pages,
        ),


       bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color(0xFF272626),
            selectedItemColor: Color(0xFFD6B574),
            unselectedItemColor: Colors.white,
            currentIndex: controller.selectedindex.value,
            onTap:(index)=> controller.changetab(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                label: "Shop",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business_center),
                label: "Detail",
              ),
            ],
          ),
        ),

    );
  }
}

Widget buildCard(String text ) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Rounded corners for the card
    ),
    shadowColor: Colors.white, // Shadow color for the card
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15), // Ensures the image also has rounded corners
      child: Image.asset(
        (text), // Replace with your image asset path
        fit: BoxFit.cover, // Ensures the image covers the entire space without distortion
      ),
    ),
  );
}

Widget buildListTile(String title, String imagePath, String subtitle, String data, double dh, double dl) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Card(
      elevation: 5,
      shadowColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color:Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),

        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: 30,
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 20), // Adding space between avatar and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFFD6B574)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Color(0xFF4F250B)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(0xFFD6B574),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "₹ $data",
                      style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "High: ₹$dh",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                Text(
                  "Low: ₹$dl",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


Widget buildInfoCard(String number, String imagePath,String t) {
  return Card(
    elevation: 5,
    shadowColor: Colors.white,

    color: Colors.white,

    child: Container(
      height: 150,width: 120,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(

            backgroundImage: AssetImage(imagePath),
            radius: 25,
            backgroundColor: Colors.white10,
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              "₹ $number",
              style: TextStyle( fontSize: 18),
            ),
          ),
          SizedBox(height: 3),
          Text(
            t,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Color(0xFF4F250B)),
          ),
        ],
      ),
    ),
  );}