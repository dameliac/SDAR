
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:sdar/app_provider.dart';
import 'package:sdar/auth/login.dart';
import 'package:sdar/home.dart';
import 'package:sdar/main.dart';
import 'package:sdar/util.dart';
import 'package:toastification/toastification.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateSignupPage();
  }
}

class _StateSignupPage extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
    final FRadioSelectGroupController<VehicleType> controller =
      FRadioSelectGroupController();
  final FRadioSelectGroupController<OptimizationPriority> opController =
      FRadioSelectGroupController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
  
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    opController.dispose();
    controller.dispose();
  
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return FScaffold(
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Sign up to get started",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 40),
              FTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                controller: _nameController,
                clearable: (value) => value.text.isNotEmpty,
                enabled: true,
                label: const Text('Full Name'),
                hint: 'John Doe',
                description: const Text(
                  'Enter your full name',
                  style: TextStyle(fontSize: 13),
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              FTextField(
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                controller: _emailController,
                clearable: (value) => value.text.isNotEmpty,
                enabled: true,
                label: const Text('Email'),
                hint: 'john@doe.com',
                description: const Text(
                  'Enter your email for your SDAR account.',
                  style: TextStyle(fontSize: 13),
                ),
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              FTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
                prefixBuilder: (context, value, child) {
                  if (isPasswordVisible) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: FButton.icon(
                        child: FIcon(FAssets.icons.eye),
                        onPress: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
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
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  );
                },
                controller: _passwordController,
                clearable: (value) => value.text.isNotEmpty,
                enabled: true,
                label: const Text('Password'),
                hint: '********',
                description: const Text(
                  'Password must be at least 8 characters',
                  style: TextStyle(fontSize: 13),
                ),
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.none,
                maxLines: 1,
                obscureText: !isPasswordVisible,
              ),
              const SizedBox(height: 20),
              FTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                prefixBuilder: (context, value, child) {
                  if (isConfirmPasswordVisible) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: FButton.icon(
                        child: FIcon(FAssets.icons.eye),
                        onPress: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
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
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  );
                },
                controller: _confirmPasswordController,
                clearable: (value) => value.text.isNotEmpty,
                enabled: true,
                label: const Text('Confirm Password'),
                hint: '********',
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.none,
                maxLines: 1,
                obscureText: !isConfirmPasswordVisible,
              ),
              const SizedBox(height: 20),

              FSelectTileGroup(
                groupController: controller,
                label: const Text('Vehicle Type'),
                description: const Text('Select your vehicle type.'),
                validator:
                    (values) =>
                        values?.isEmpty ?? true
                            ? 'Please select a value.'
                            : null,
                children: [
                  FSelectTile(
                    title: const Text('Electric'),
                    value: VehicleType.electric,
                  ),
                  FSelectTile(
                    title: const Text('Hybrid'),
                    value: VehicleType.hybrid,
                  ),
                  FSelectTile(title: const Text('Gas'), value: VehicleType.gas),
                ],
              ),
              const SizedBox(height: 20),
              FSelectTileGroup(
                groupController: opController,
                label: const Text('Optimization Priority'),
                description: const Text('Select your priority.'),
                validator:
                    (values) =>
                        values?.isEmpty ?? true
                            ? 'Please select a value.'
                            : null,
                children: [
                  FSelectTile(
                    title: const Text('Normal'),
                    value: OptimizationPriority.normal,
                  ),
                  FSelectTile(
                    title: const Text('Fastest Route'),
                    value: OptimizationPriority.fast,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              FButton(
                onPress: () async {
                  if (_formKey.currentState!.validate()) {
                    String optimization = "";
                    String type = "";
                    if (opController.value.contains(
                      OptimizationPriority.normal,
                    )) {
                      optimization = "normal";
                    } else {
                      optimization = "fst";
                    }

                    if (controller.value.contains(VehicleType.electric)) {
                      type = "electric";
                    } else if (controller.value.contains(VehicleType.hybrid)) {
                      type = "hybrid";
                    } else {
                      type = "gas";
                    }

                    final password = _passwordController.text;
                    final confirmPassword = _confirmPasswordController.text;
                    final email = _emailController.text;

                    final success = await Provider.of<AppProvider>(
                      context,
                      listen: false,
                    ).createUser(
                      password,
                      confirmPassword,
                      email,
            
                    );
                    if (success) {
                      toastification.show(
                        title: Text('Success'),
                        autoCloseDuration: const Duration(seconds: 1),
                        type: ToastificationType.success,
                        style: ToastificationStyle.flat,
                      );

                      _confirmPasswordController.clear();
                      _emailController.clear();
                      _emailController.clear();
                      _nameController.clear();

                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> MyHomePage(title: 'SDAR')));
                  
                    }
                  }
                },
                label: const Text("Signup"),
              ),
              const SizedBox(height: 20,),
              FButton(
  label: const Text('Login'),
  style: FButtonStyle.secondary,
  onPress: () {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> LoginPage()));

  },
),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
