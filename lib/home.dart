import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:voting/select.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _message = "Not Authorized";
  bool isAuth = false;
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        title: const Text("Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("images/fprint.png"),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Fingerprint Auth",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'رقم الناخب',
                    labelStyle:
                        TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
             /*   final LocalAuthentication auth = LocalAuthentication();

                final bool canAuthenticateWithBiometrics =
                    await auth.canCheckBiometrics;
                final bool canAuthenticate = canAuthenticateWithBiometrics ||
                    await auth.isDeviceSupported();
                print(canAuthenticate);
                final List<BiometricType> availableBiometrics =
                    await auth.getAvailableBiometrics();

                if (availableBiometrics.isNotEmpty) {
                  print("device not low this");
                }

                if (availableBiometrics.contains(BiometricType.strong) ||
                    availableBiometrics.contains(BiometricType.face)) {
                  print("select one :");
                }
                final bool didAuthenticate = await auth.authenticate(
                    localizedReason:
                        'Please authenticate to show account balance',
                    options: const AuthenticationOptions(biometricOnly: true));
                if(didAuthenticate){
                }*/
                FirebaseFirestore.instance
                    .collection('users')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    print(doc["vnumber"]);
                    if(doc["age"]<18&&doc["vnumber"]==_controller.text){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Your Age under 18"),
                      ));
                    }else if(doc["isvoting"]==true&&doc["vnumber"]==_controller.text){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Your are already vote"),
                      ));
                    }else{
                      if(doc["vnumber"]==_controller.text){
                        is_vote(doc.id,doc["age"],true,doc["name"],doc["vnumber"]);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => SelectPage()),
                            ModalRoute.withName('/')
                        );
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Authentication not Valid"),
                        ));
                      }
                    }
                  });
                });

              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Login'), // <-- Text
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    // <-- Icon
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

  is_vote(String id,int age,bool isvoting,String name,String vnumber){
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(id)
        .set({'isvoting':isvoting, "name": name, "age": age,"vnumber":vnumber});
  }

  void _checkBiometric() async {}

  @override
  void initState() {
    super.initState();
  }
}
