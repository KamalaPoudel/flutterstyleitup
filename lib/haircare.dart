import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HairCare extends StatefulWidget {
  @override
  _HairCareState createState() => _HairCareState();
}

class _HairCareState extends State<HairCare> {
//   @override
//   void initState() {
// getOrgainzation();
//     super.initState();
//   }

//   void getOrgainzation() async{
//     Firestore.instance.collection("Organizationinfo").getDocuments();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hair Care"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Organizationinfo').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: new FittedBox(
                          child: Material(
                            color: Colors.white,
                            elevation: 20.0,
                            borderRadius: BorderRadius.circular(24.0),
                            shadowColor: Color(0x802196F3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text(
                                      document['organizationName'],
                                      style: TextStyle(fontSize: 24.0),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 8, bottom: 4),
                                      child: Container(
                                        height: 50,
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/details');
                                          },
                                          child: Text("View Details"),
                                          color: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4, right: 8, bottom: 8),
                                      child: Container(
                                        height: 50,
                                        child: RaisedButton(
                                          onPressed: () {},
                                          child: Text("Show in Map"),
                                          color: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
            }
          },
        )

        // ListView.builder(
        //   itemCount: 10,
        //   itemBuilder: (context, index) {
        //     return Padding(
        //       padding: const EdgeInsets.all(16.0),
        //       child: Container(
        //         child: new FittedBox(
        //           child: Material(
        //             color: Colors.white,
        //             elevation: 20.0,
        //             borderRadius: BorderRadius.circular(24.0),
        //             shadowColor: Color(0x802196F3),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: <Widget>[
        //                 Container(
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(left: 15.0),
        //                     child: Text(
        //                       "Organization Name",
        //                       style: TextStyle(fontSize: 24.0),
        //                     ),
        //                   ),
        //                 ),
        //                 Column(
        //                   children: <Widget>[
        //                     Padding(
        //                       padding: const EdgeInsets.only(
        //                           top: 8, right: 8, bottom: 4),
        //                       child: Container(
        //                         height: 50,
        //                         child: RaisedButton(
        //                           onPressed: () {
        //                             Navigator.of(context).pushNamed('/details');
        //                           },
        //                           child: Text("View Details"),
        //                           color: Colors.amber,
        //                           shape: RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(15.0)),
        //                         ),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.only(
        //                           top: 4, right: 8, bottom: 8),
        //                       child: Container(
        //                         height: 50,
        //                         child: RaisedButton(
        //                           onPressed: () {},
        //                           child: Text("Show in Map"),
        //                           color: Colors.amber,
        //                           shape: RoundedRectangleBorder(
        //                               borderRadius: BorderRadius.circular(15.0)),
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        );
  }
}
