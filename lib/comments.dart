import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_it_up/details.dart';

class CommentPage extends StatefulWidget {
  // comment class
  // List comments;
  String collectionName; // declaring variable
  String documentid; // declaring variable

  CommentPage(
      {Key key,
      this.collectionName,
      this.documentid}) //parameter in constructor
      : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List comment = []; // declaring comment as list variable
  String userEmail; // declaring variable
  String fullName; // declaring variable

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      // storing comments in database with reference to current users
      setState(() {
        userEmail = user.email;
        print(userEmail);
      });
      getData();
    });
    super.initState();
    getComments();
  }

  void getData() async {
    // function to get the fullname data from users collection
    await Firestore.instance
        .collection('users')
        .document(userEmail)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        fullName = ds.data["fullName"];
        // print(fullName);
      });
    });
  }

  void getComments() async {
    // function to store comments in database
    var docref = Firestore.instance
        .collection(widget.collectionName)
        .document(widget.documentid);
    docref.get().then((doc) {
      this.setState(() {
        comment = doc.data['comments'];
      });
    });
  }

  final commentController = TextEditingController();
  final databaseReference = Firestore.instance;
  //TextEditingController yourFullName = TextEditingController(text: fullName);
  @override
  Widget build(BuildContext context) {
    String id1 = widget.documentid;
    return Scaffold(
        backgroundColor: Color.fromARGB(0xff, 241, 241, 254),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Your Feedbacks Here",
            style: GoogleFonts.notoSans(fontSize: 25.0, color: Colors.white),
          ),
          //automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => Details(
                //             collectionName: widget.collectionName,
                //             documentid: widget.documentid,
                //           )),
                // );
              },
              child: Icon(Icons.chevron_left)),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Comment Section',
                style:
                    GoogleFonts.notoSans(fontSize: 25.0, color: Colors.black),
              ),
            ),
            comment != null
                ? Expanded(
                    child: Card(
                      child: ListView.builder(
                          itemCount: comment.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    comment[index]['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(comment[index]['comment']),
                                ],
                              ),
                            );
                          }),
                    ),
                  )
                : Text('No Comments'),
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextFormField(
                      controller: commentController,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                          hintText: "Add Comments",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Text("Posts"),
                      ),
                      onPressed: () async {
                        if (commentController.text.isEmpty) {
                          print('Comment is empty');
                        } else {
                          await databaseReference
                              .collection(widget.collectionName)
                              .document(id1)
                              .setData({
                            'comments': FieldValue.arrayUnion([
                              // comments in the form of array
                              {
                                "comment": commentController.text,
                                "name": fullName,
                              }
                            ]),
                          });
                          commentController.clear();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Comment successfull"),
                                  content: Text("Thank You for Your Feedback!"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OKAY"),
                                    ),
                                  ],
                                );
                              });
                          Navigator.of(context).pop();

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => CommentPage(
                          //             collectionName: widget.collectionName,
                          //             documentid: widget.documentid,
                          //           )),
                          // );

                        }
                      },
                      color: Colors.blue[800],
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                      splashColor: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
