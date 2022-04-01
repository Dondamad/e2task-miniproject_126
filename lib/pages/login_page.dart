import 'package:flutter/material.dart';

import 'package:task_app/services/auth_service.dart';
// import 'package:task_app/widgets/custominputfield.dart';

import '../theme.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login to  your\naccount',
                      style: headline4.copyWith(color: darkColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: bodyText1.copyWith(color: darkColor),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      EmailInput(inputController: _email, hintText: 'Email'),
                      const SizedBox(
                        height: 20,
                      ),
                      passwordInput(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                GradientButton(text: 'Login', onPressed: () {}),
                const SizedBox(
                  height: 18,
                ),
                Center(
                  child: Text(
                    'OR',
                    style: bodyText1.copyWith(color: textGrey),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                GoogleAuthBtn(onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => const Center(
                              child: CircularProgressIndicator(
                            backgroundColor: whiteColor,
                            color: primaryColor,
                          )));
                  signInWithGoogle().then((value) => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        )
                      });
                }),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: bodyText1.copyWith(color: textGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      child: Text(
                        'Register',
                        style: bodyText1.copyWith(color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column passwordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: bodyText1.copyWith(color: darkColor),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _password,
          obscureText: !passwordVisible,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(18.0),
            // fillColor: textWhiteGrey,
            // filled: true,
            hintText: 'Password',
            hintStyle: bodyText1.copyWith(color: textGrey),
            suffixIcon: IconButton(
              color: textGrey,
              splashRadius: 1,
              icon: Icon(passwordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined),
              onPressed: togglePassword,
            ),
            border: OutlineInputBorder(
              // borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff6146C6), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
        ),
      ],
    );
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;

  const EmailInput({
    Key? key,
    required this.inputController,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(18.0),
        // fillColor: textWhiteGrey,
        // filled: true,
        hintText: hintText,
        hintStyle: bodyText1.copyWith(color: textGrey),
        border: OutlineInputBorder(
          // borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff6146C6), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const GradientButton({required this.text, required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff4338CA);
    const secondaryColor = Color(0xff6D28D9);
    const accentColor = Color(0xffffffff);

    const double borderRadius = 15;

    return DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient:
                const LinearGradient(colors: [primaryColor, secondaryColor])),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                alignment: Alignment.center,
                padding: MaterialStateProperty.all(const EdgeInsets.only(
                    right: 75, left: 75, top: 15, bottom: 15)),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius)),
                )),
            onPressed: onPressed,
            child: Text(
              text,
              style: const TextStyle(color: accentColor, fontSize: 16),
            ),
          ),
        ));
  }
}

class GoogleAuthBtn extends StatelessWidget {
  final Function() onPressed;
  const GoogleAuthBtn({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 54,
        // margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: TextButton(
          style: ButtonStyle(
              // elevation: MaterialStateProperty.all(),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/google.png",
                width: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Login with Google",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ],
          ),
          onPressed: onPressed,
        ));
  }
}
