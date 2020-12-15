
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guard/Bloc/AuthBloc.dart';
import 'package:guard/Constant/ConstantTextField.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/GuradSignInScreen/TabBarScreen.dart';
import 'package:guard/GuradSignInScreen/accessListScreen.dart';
import 'package:guard/GuradSignInScreen/activationScreen.dart';
import 'package:guard/GuradSignInScreen/passwordScreen.dart';
import 'package:guard/ModelClass/userModelClass.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  UserData _userData = UserData();


  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final formkeyForget = GlobalKey<FormState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoginPressed = false;
  bool _passwordVisible = true;
  bool isLoading = false;

  @override
  Future<void> resetPassword(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
      showScaffold("Change Password link is send to your mail");
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_USER_NOT_FOUND":
        case "ERROR_INVALID_EMAIL":
          {
            this.showScaffold("This email Id is not exist ");
            setState(() {
              isLoading = false;
            });
            break;
          }
      }
    });
  }

  Widget _submitButton(
      TextEditingController email, TextEditingController password) {
    return GestureDetector(
      onTap: () {
        if (formKey.currentState.validate()) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: Container(
        padding: new EdgeInsets.symmetric(vertical: 5.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
         // color: UniversalVariables.background,
        ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return GestureDetector(
      onTap: () {
        // _getUserData();
      },
      child: Container(
        height: 40,
//        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff1959a9),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('f',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff2872ba),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('Log in with Facebook',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLoading = true;
        });

        googleLogin();
      },
      child: Container(
        height: 40,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('G',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('Log in with Google',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, CupertinoPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: UniversalVariables.background,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'My',
          style: GoogleFonts.portLligatSans(
            color: UniversalVariables.background,
            fontSize: 35,
            fontWeight: FontWeight.w700,
          ),
          children: [
            TextSpan(
              text: 'D',
              style: TextStyle(color: Colors.black, fontSize: 35),
            ),
            TextSpan(
              text: 'en',
              style:
              TextStyle(color: UniversalVariables.background, fontSize: 35),
            ),
            TextSpan(
              text: ' Guar',
              style:
              TextStyle(color: UniversalVariables.background, fontSize: 35),
            ),
            TextSpan(
              text: 'ds',
              style:
              TextStyle(color: Colors.black, fontSize: 35),
            ),
          ]),
    );
  }

  Widget _wlcmtitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Wel',
          style: GoogleFonts.portLligatSans(
            color: UniversalVariables.background,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          children: [
            TextSpan(
              text: 'Come',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: ' To',
              style:
              TextStyle(color: UniversalVariables.background, fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              // Positioned(
              //     top: -height * .15,
              //     right: -MediaQuery.of(context).size.width * .4,
              //     child: BezierContainer()),
              Stack(children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: height * .17),
                          Row(children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _wlcmtitle(),
                                  Row(children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    _title()
                                  ])
                                ])
                          ]),
                          SizedBox(height: 50),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                constantTextField().InputField(
                                    "Enter Email id",
                                    "abc@gmail.com",
                                    validationKey.email,
                                    _emailController,
                                    false,
                                    IconButton(
                                        icon: Icon(Icons.arrow_drop_down),
                                        onPressed: null),
                                    1,
                                    1,
                                    TextInputType.emailAddress,
                                    false),
                                SizedBox(
                                  height: 10,
                                ),
                                constantTextField().InputField(
                                    "Enter Password",
                                    "abc@gmail.com",
                                    validationKey.password,
                                    _passwordController,
                                    true,
                                    IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color:
                                        Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                    1,
                                    2,
                                    TextInputType.emailAddress,
                                    _passwordVisible)
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          _submitButton(_emailController, _passwordController),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  _emailController.text == ""
                                      ? showScaffold("Enter your email id")
                                      : resetPassword(_emailController.text);
                                },
                                child: Text('Forgot Password ?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              )),
                          _divider(),
                          _facebookButton(),
                          _googleButton(),
                          SizedBox(
                            height: 5,
                          ),
                          _createAccountLabel(),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              Positioned(
                child: isLoading
                    ? Container(
                  color: Colors.transparent,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    : Container(),
              ),
            ],
          ),
        ));
  }

  void googleLogin() {
    context.bloc<AuthBloc>().signInWithGoogle().then((value) {
      _userData = context.bloc<AuthBloc>().getCurrentUser();

      if (_userData.accessList != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return PasswordScreen();
            }));
      }  else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
                return ActivationScreen();
              }));
        }
      }
    );}

}


