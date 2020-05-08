import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerGallery extends StatefulWidget {
  @override
  _CustomerGalleryState createState() => _CustomerGalleryState();
}

class _CustomerGalleryState extends State<CustomerGallery> {
  Widget _buildGalleryItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: [
            new BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 20.0,
            ),
          ]),
      height: 300,
      width: MediaQuery.of(context).size.width / 1.1,
      margin: EdgeInsets.only(top: 10),
      child: Carousel(
          boxFit: BoxFit.cover,
          autoplay: true,
          animationCurve: Curves.linear,
          animationDuration: Duration(milliseconds: 700),
          dotSize: 6.0,
          dotIncreasedColor: Colors.orange,
          dotBgColor: Colors.transparent,
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 0.0,
          showIndicator: true,
          indicatorBgPadding: 7.0,
          images: document['Pictures'].map((image) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl: image,
              ),
            );
          }).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
              stream: Firestore.instance.collection('Gallery').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return LinearProgressIndicator(
                    backgroundColor: Colors.green,
                  );
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => _buildGalleryItem(
                    context,
                    snapshot.data.documents[index],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
