import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication   _localAuthentication = LocalAuthentication();
  String _message = "Not Authorized";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        title: const Text("Login Page"),
      ),
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("images/fprint.png"),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Fingerprint Auth",
              style: TextStyle(
                fontSize:21,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child:TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'رقم الناخب',
                    labelStyle:TextStyle(
                        fontSize:21,
                        fontWeight: FontWeight.bold
                    )
                  ),
                ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {

              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Login'), // <-- Text
                  SizedBox(
                    width: 5,
                  ),
                  Icon( // <-- Icon
                    Icons.fingerprint,
                    size: 35.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    checkingForBioMetrics();
    super.initState();
  }


  Future<void> _authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, // native process
      );

      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }
}
