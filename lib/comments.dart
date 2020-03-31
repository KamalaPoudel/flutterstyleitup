import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  List comments;

  CommentPage({Key key, this.comments}) : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final commentController = TextEditingController();
  final databaseReference = Firestore.instance;
  @override


  Future<String> createCommentDb() async {
    Firestore.instance
        .collection('Comments')
        .document()
        .setData()

  }
  getComment() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CommentPage(
                comments: widget.comments,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0xff, 241, 241, 254),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Your Feedbacks Here"),
      ),
      body: SingleChildScrollView
      (
         child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08),
                            blurRadius: 20.0,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          widget.comments != null
                              ? Text(
                                  'Comment Section',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Container(),
                          Divider(),
                          widget.comments != null
                              ? Column(
                                  children: widget.comments
                                      .asMap()
                                      .map((index, comment) => MapEntry(
                                          index,
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: ListTile(
                                                title: Text(
                                                  comment["name"],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle:
                                                    Text(comment["comment"]),
                                              ))))
                                      .values
                                      .toList())
                              : Container(),
                          Divider(),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: TextFormField(
                                    controller: commentController,
                                    cursorColor: Colors.black,
                                    decoration: new InputDecoration(
                                        hintText: "Add Comments",
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                RaisedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text("Posts"),
                                  ),
                                  onPressed: () async {
                                    print(commentController.text);

                                    await databaseReference
                                        .collection(Comments)
                                        .document()
                                        .updateData({
                                      'test': FieldValue.arrayUnion([
                                        {
                                          "comment": commentController.text,
                                          
                                        }
                                      ]),
                                    });
                                    Future.delayed(Duration.zero);
                                    commentController.clear();
                                    
                                  },
                                  color: Colors.blue[800],
                                  textColor: Colors.white,
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  splashColor: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
