import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:my_france/utils/api.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showSignInForm = true;
  bool isPasswordVisible = false;
  bool isLoading = false;
  String? emailError;
  String? passwordError;
  String? loginError;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    emailController.removeListener(_validateEmail);
    passwordController.removeListener(_validatePassword);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      final email = emailController.text;
      if (email.isEmpty) {
        emailError = null;
      } else if (!GetUtils.isEmail(email)) {
        emailError = "Invalid Email";
      } else {
        emailError = null;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      final password = passwordController.text;
      if (password.isEmpty) {
        passwordError = null;
      } else if (!_isValidPassword(password)) {
        passwordError = "Invalid Password";
      } else {
        passwordError = null;
      }
    });
  }

  bool _isValidPassword(String password) {
    if (password.length < 6) return false;

    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));

    return hasLetter && hasNumber;
  }

  Future<void> _signIn() async {
    _validateEmail();
    _validatePassword();

    if (emailError != null || passwordError != null) {
      return;
    }

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        loginError = "Please fill in both email and password";
      });
      return;
    }

    setState(() {
      isLoading = true;
      loginError = null;
    });

    try {
      final result = await ApiHelper.signIn(
        emailController.text,
        passwordController.text,
      );

      if (mounted) {
        if (result['success'] == true || result['token'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login successful!"),
              backgroundColor: Colors.green,
            ),
          );

          emailController.clear();
          passwordController.clear();
        } else {
          setState(() {
            loginError = result['message'] ?? "Login failed. Please try again.";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loginError = "Login failed. Please check your credentials.";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.account_circle_outlined, size: 128),
              TextButton(
                onPressed: () {
                  setState(() {
                    showSignInForm = true;
                  });
                },
                child: Text("Join us now"),
              ),
              Text("To discover mor sights of France"),
            ],
          ),
        ),
        Flexible(
          child: showSignInForm
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sign in/up"),
                    Form(
                      child: Column(
                        spacing: 12,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              if (emailError != null)
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    emailError!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                obscureText: !isPasswordVisible,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  border: OutlineInputBorder(),
                                  suffixIcon: GestureDetector(
                                    onTapDown: (_) {
                                      setState(() {
                                        isPasswordVisible = true;
                                      });
                                    },
                                    onTapUp: (_) {
                                      setState(() {
                                        isPasswordVisible = false;
                                      });
                                    },
                                    onTapCancel: () {
                                      setState(() {
                                        isPasswordVisible = false;
                                      });
                                    },
                                    child: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                              ),
                              if (passwordError != null)
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    passwordError!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (loginError != null)
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                loginError!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          TextButton(
                            onPressed: isLoading ? null : _signIn,
                            child: isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text("Sign in/up"),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                final webString =
                                    await ApiHelper.getUserAgreement();
                                showDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("User Agreement"),
                                    content: SingleChildScrollView(
                                      child: Text(webString),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Close"),
                                      ),
                                    ],
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Failed to load user agreement",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "READ USER AGREEMENT",
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
