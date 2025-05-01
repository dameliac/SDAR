import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:sdar/app_provider.dart';
import 'package:sdar/auth/signup.dart';
import 'package:sdar/main.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateLoginPage();
  }
}

class _StateLoginPage extends State<LoginPage> {
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Welcome",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Login to access your account",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 40),
            FTextField(
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 8) {
                  return 'Please enter a valid email';
                }
                return null;
              },

              controller: _loginEmailController, // TextEditingController
              clearable: (value) => value.text.isNotEmpty,
              enabled: true,
              label: const Text('Email'),
              hint: 'john@doe.com',
              description: const Text(
                'Enter your email associated with your SDAR account.',
                style: TextStyle(fontSize: 13),
              ),
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              maxLines: 1,
            ),
            const SizedBox(height: 20),

            FTextField(
              validator: (value) {
                if (value == null || value.isEmpty || value.isEmpty) {
                  return 'Please enter a valid password';
                }
                return null;
              },
              prefixBuilder: (context, value, child) {
                if (isVisible) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: FButton.icon(
                      child: FIcon(FAssets.icons.eye),
                      onPress: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: FButton.icon(
                    child: FIcon(FAssets.icons.eyeClosed),
                    onPress: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                  ),
                );
              },
              controller: _loginPasswordController, // TextEditingController
              clearable: (value) => value.text.isNotEmpty,
              enabled: true,
              label: const Text('Password'),
              hint: '********',
              keyboardType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.none,
              maxLines: 1,
              obscureText: !isVisible,
            ),
            const SizedBox(height: 40),

            FButton(
              onPress: () async{
                if (_formKey.currentState!.validate()) {
                  final success = await Provider.of<AppProvider>(context,listen: false).login(_loginEmailController.text, _loginPasswordController.text);
                  if (success){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: 'SDAR')));
                  } else {
                    toastification.show(
                      autoCloseDuration: const Duration(seconds: 1),
                      type: ToastificationType.error,
                      title: const Text('Failed to login, Please try again')
                    );
                  }
                }
              },
              label: const Text("Login"),
            ),
            const SizedBox(height: 20,),
             FButton(
  label: const Text('Signup Instead'),
  style: FButtonStyle.secondary,
  onPress: () {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> SignupPage()));

  },
),
          ],
        ),
      ),
    );
  }
}
