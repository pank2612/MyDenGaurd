import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:guard/Bloc/AuthBloc.dart';
import 'package:guard/Constant/ConstantTextField.dart';
import 'package:guard/Constant/Constant_Color.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _controller = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _passwordVisible = true;


  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        emailSignUp();
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: UniversalVariables.background
        ),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, CupertinoPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
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



  void singUp()   {
    //    if (formKey.currentState.validate()) {
    //      setState(() {
    //        _controller.text = "emailLogin";
    //        isLoading = true;
    //      });
    //
    //
    //      databaseMethods.signUpWithEmail(
    //          _emailController.text,
    //          _passwordController.text,
    //          _userNameController.text).then((FirebaseUser user) async {
    //         print("something");
    //         try{
    //           await user.sendEmailVerification();
    //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EmailVerification(
    //             name: _userNameController.text,
    //           )));
    //           authenticateUser(user);
    //         } catch(e){
    //          print(e);
    //         }
    //      });
    //    }
  }





  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            // Positioned(
            //   top: -MediaQuery.of(context).size.height * .15,
            //   right: -MediaQuery.of(context).size.width * .4,
            //   child: BezierContainer(),
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 40,),
//                    _backButton(),
                    SizedBox(height: height * .10),
                    Row(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _wlcmtitle(),
                            Row(children: [
                              SizedBox(
                                width: 80,
                              ),
                              _title()
                            ])
                          ])
                    ]),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          constantTextField().InputField(
                              "Name",
                              "Ronak Singh",
                              validationKey.name,
                              _userNameController,
                              false,
                              IconButton(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onPressed: null),
                              1,2,TextInputType.emailAddress,false),
                          SizedBox(
                            height: 10,
                          ),
                          constantTextField().InputField(
                              "Enter Email id",
                              "abc@gmail.com",
                              validationKey.email,
                              _emailController,
                              false,
                              IconButton(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onPressed: null),
                              1,1,TextInputType.emailAddress,false),
                          SizedBox(
                            height: 10,
                          ),
                          constantTextField().InputField(
                              "Enter Password",
                              "",
                              validationKey.password,
                              _passwordController,
                              true,
                              IconButton(
                                icon: Icon( _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },),
                              1,2,TextInputType.emailAddress, false
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),

                    SizedBox(height: height * .14),
                    _loginAccountLabel(),

                  ],
                ),
              ),
            ),
            Positioned(
              child: isLoading ? Container(
                color: Colors.transparent,
                child: Center(child: CircularProgressIndicator(),) ,) : Container(),
            ),
          ],
        ),
      ),
    );
  }





  // Future<void> _showDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         // title: Text('AlertDialog Title'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //              Row(
  //                mainAxisAlignment: MainAxisAlignment.center,
  //                children: [
  //
  //                CircularProgressIndicator(
  //
  //                ),
  //              ],),
  //               Text(
  //               "A link is send to your Email  id plz Click on it to verify",
  //           style: TextStyle(color: UniversalVariables.background),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void emailSignUp(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      context.bloc<AuthBloc>().createUserWithEmailAndPassword(_emailController.text, _passwordController.text, context)


          .then((value) {
        if(value.email == null){
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) {
          //       return ActivationScreen();
             // }));
        } else{
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) {
          //       return TabBarScreen();
           //   }));

        }
      }




      );
    }
  }






}
