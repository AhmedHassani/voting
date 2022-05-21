import 'package:flutter/material.dart';
import 'package:voting/showv.dart';
import 'package:voting/voting.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Home Page Voting",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=>Showv()
                      )
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('show number of votes'), // <-- Text
                    SizedBox(
                      width: 5,
                      height: 40,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=>VotingPage()
                      )
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('              voting              '), // <-- Text
                    SizedBox(
                      width: 5,
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
