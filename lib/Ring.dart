import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RingPage extends StatefulWidget {
  final String category;

  const RingPage({required this.category, Key? key}) : super(key: key);

  @override
  _RingPageState createState() => _RingPageState();
}

class _RingPageState extends State<RingPage> {
  final databaseRef = FirebaseDatabase.instance.ref('assetimage');
  List<String> imageUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages(widget.category);
  }

  Future<void> fetchImages(String category) async {
    try {
      DatabaseReference categoryRef = databaseRef.child(category);
      DatabaseEvent event = await categoryRef.once();
      final dataSnapshot = event.snapshot;
      List<String> urls = [];

      if (dataSnapshot.value != null) {
        if (dataSnapshot.value is Map) {
          Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
          values.forEach((key, value) {
            if (value is String) {
              urls.add(value);
            }
          });
        } else if (dataSnapshot.value is List) {
          List<dynamic> values = List<dynamic>.from(dataSnapshot.value as List);
          for (var value in values) {
            if (value is String) {
              urls.add(value);
            }
          }
        }
      }

      setState(() {
        imageUrls = urls;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching images: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void openFullScreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} Collection",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,

      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : imageUrls.isEmpty
          ? Center(
        child: Text(
          "No images available for ${widget.category}",
          style: TextStyle(fontSize: 16),
        ),
      )
          :  Container(
        decoration: BoxDecoration(
          color: Color(0xFF272626),
          image: DecorationImage(
            image: AssetImage("assets/image/background.png"),
            fit: BoxFit.cover
            ,
          ),
        ),
            child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
                    ),
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
            return InkWell(
              onTap: () => openFullScreenImage(imageUrls[index]),
              child: Card(
                elevation: 4,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.broken_image, size: 50),
                      );
                    },
                  ),
                ),
              ),
            );
                    },
                  ),
          ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}
