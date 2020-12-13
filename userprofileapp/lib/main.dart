import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Colors.blue[900],
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final db = Firestore.instance;
  String name;
  String address;
  String email;

  void showdialog() {
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Add User profile'),
              content: Stack(
                  // ignore: deprecated_member_use
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red[900],
                        ),
                      ),
                    ),
                    Form(
                        key: formkey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                autofocus: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name'),
                                validator: (_val) {
                                  if (_val.isEmpty) {
                                    return "Fields can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (_val) {
                                  name = _val;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                autofocus: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Address'),
                                validator: (_val) {
                                  if (_val.isEmpty) {
                                    return "Fields can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (_val) {
                                  address = _val;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                autofocus: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email'),
                                validator: (_val) {
                                  if (_val.isEmpty) {
                                    return "Fields can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (_val) {
                                  email = _val;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () {
                                  db.collection('profiles').add({
                                    'Name': name,
                                    'Address': address,
                                    'Email': email
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Add'),
                              ),
                            )
                          ],
                        )),
                  ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 70),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  heroTag: "btn1",
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.camera),
                  onPressed: () {}),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 140),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  heroTag: "btn3",
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.videocam),
                  onPressed: () {}),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: Color(0XFF0D325E),
                child: Icon(Icons.add),
                onPressed: showdialog),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Container(
          color: Theme.of(context).primaryColorLight,
          child: Text(
            'Make a User Profile',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}