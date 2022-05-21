import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VotingPage extends StatefulWidget {
  @override
  createState() {
    return VotingPageState();
  }
}

class VotingPageState extends State<VotingPage> {
  List<RadioModel> sampleData = [];
  Stream<QuerySnapshot>? _usersStream;

  _widget(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (sampleData.isEmpty) {
      snapshot.data!.docs.forEach((element) {
        sampleData.add(RadioModel(
          false,
          "${element["id"]}",
          "${element["name"]}",
          element.id,
          "${element["voters"]}",
        ));
      });
    }
    return ListView.builder(
      itemCount: sampleData.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          splashColor: Colors.blueAccent,
          onTap: () {
            setState(() {
              sampleData.forEach((element) => element.isSelected = false);
              sampleData[index].isSelected = true;
            });
          },
          child: RadioItem(sampleData[index]),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('voter').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voting Page"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: const [Text('Something went wrong')],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                children: const [CircularProgressIndicator()],
              ),
            );
          }
          return Column(
            children: [
              Expanded(child: _widget(snapshot)),
              ElevatedButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Successful vote"),
                  ));
                  for (RadioModel v in sampleData) {
                    if (v.isSelected) {
                      int z = int.parse(v.voters) + 1;
                      addUser(v.id, z,v.text,v.id);
                    }
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('              vote now             '), // <-- Text
                    SizedBox(
                      width: 5,
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> addUser(String id, int v, String name, String idd) {
    CollectionReference users = FirebaseFirestore.instance.collection('voter');
    return users
        .doc(id)
        .set({'voters': v, "name": name, "id": idd})
        .then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Successful vote"),
            )))
        .catchError((error) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Filed voting"),
            )));
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            child: Center(
              child: Text(_item.buttonText,
                  style: TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Text(
              _item.text,
              style: TextStyle(fontSize: 19),
            ),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;
  final String id;
  final String voters;

  RadioModel(
    this.isSelected,
    this.buttonText,
    this.text,
    this.id,
    this.voters,
  );
}
