import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  String _errorMessage;
  bool _isLoading = false;
  TextEditingController collectionName = TextEditingController();
  final databaseReference = Firestore.instance;

  Future<void> getImage() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,

        selectedAssets: images,

        // ),
      );
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }

    if (!mounted) return;
    setState(() {
      images = resultList;
      _errorMessage = _errorMessage;
    });
  }

  void uploadImages() async {
    if (images.isNotEmpty && collectionName.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      for (var imageFile in images) {
        await postImage(imageFile).then((downloadUrl) {
          imageUrls.add(downloadUrl.toString());
          if (imageUrls.length == images.length) {
            Firestore.instance.collection('Gallery').document().setData({
              'Pictures': imageUrls,
              'Collection name': collectionName.text.trim(),
            }).then((_) {
              setState(() {
                images = [];
                imageUrls = [];
                collectionName.clear();
                _isLoading = false;
              });
            });
          }
        }).catchError((err) {
          setState(() {
            _isLoading = false;
          });
          print(err);
        });
      }
    } else {}
  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference =
        FirebaseStorage.instance.ref().child('Gallery').child(fileName);
    StorageUploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0xff, 241, 241, 254),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Images To Gallery',
          style: GoogleFonts.notoSans(fontSize: 25.0, color: Colors.black87),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15),
                    TextFormField(
                      controller: collectionName,
                      decoration: InputDecoration(
                        labelText: "Collection Name",
                        hintText: "Collection Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 1.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: (images.isNotEmpty)
                            ? GridView.count(
                                crossAxisCount: 2,
                                children: List.generate(images.length, (index) {
                                  Asset asset = images[index];

                                  return Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      // height: 50,
                                      // width: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        child: AssetThumb(
                                          asset: asset,
                                          width: 300,
                                          height: 300,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              )
                            : Container(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Choose a pictures",
                                    style: GoogleFonts.notoSans(
                                        fontSize: 20.0, color: Colors.black87),
                                  ),
                                ),
                              ),
                        //  Text("Tap to Choose or Take Picture"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());

                        uploadImages();
                      },
                      child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            _isLoading
                ? Positioned.fill(
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              backgroundColor: Colors.green,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Uploading! Please Wait :)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
