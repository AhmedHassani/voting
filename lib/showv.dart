import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Showv extends StatefulWidget {
  @override
  createState() {
    return ShowvState();
  }
}

class ShowvState extends State<Showv> {
  List<RadioModel> sampleData = [];
  Stream<QuerySnapshot>? _usersStream;

  _widget(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (sampleData.isEmpty) {
      snapshot.data!.docs.forEach((element) {
        sampleData.add(RadioModel(
          false,
          "${element["voters"]}",
          "${element["name"]}",
          element.id,
          "${element["voters"]}",
        ));
      });
    }
    return ListView.separated(
      itemCount: sampleData.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          splashColor: Colors.blueAccent,
          onTap: () {
          },
          child: RadioItem(sampleData[index]),
        );
      }, separatorBuilder: (BuildContext context, int index) {
        return Divider();
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
        title: const Text("Statistics"),
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
            ],
          );
        },
      ),
    );
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
