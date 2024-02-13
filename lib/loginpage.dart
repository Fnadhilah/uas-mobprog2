import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_crud/homepage.dart'; // Assuming this is the home page file

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<bool> _login() async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.25.157/flutterapi/crudflutter/api/login/login.php'),
      body: {
        "email": email.text,
        "password": password.text,
      },
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your email";
                  }
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: password,
                obscureText: true, // Password field should be obscured
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your password";
                  }
                },
              ),
              SizedBox(
                height: 24,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Background color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _login().then((value) {
                      if (value) {
                        final snackBar = SnackBar(
                          content: const Text("Login Successful"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      } else {
                        final snackBar = SnackBar(
                          content: const Text("Login Failed"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                  }
                },
                child: Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
