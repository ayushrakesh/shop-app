import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return AuthCard();
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    // return Scaffold(
    //   // resizeToAvoidBottomInset: false,
    //   body: Stack(
    //     children: <Widget>[
    //       Container(
    //         decoration: BoxDecoration(
    //           gradient: LinearGradient(
    //             colors: [
    //               Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
    //               Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
    //             ],
    //             begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //             stops: [0, 1],
    //           ),
    //         ),
    //       ),
    //       SingleChildScrollView(
    //         child: Container(
    //           height: deviceSize.height,
    //           width: deviceSize.width,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Flexible(
    //                 child: Container(
    //                   margin: EdgeInsets.only(bottom: 20.0),
    //                   padding:
    //                       EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
    //                   transform: Matrix4.rotationZ(-8 * pi / 180)
    //                     ..translate(-10.0),
    //                   // ..translate(-10.0),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(20),
    //                     color: Colors.deepOrange.shade900,
    //                     boxShadow: [
    //                       BoxShadow(
    //                         blurRadius: 8,
    //                         color: Colors.black26,
    //                         offset: Offset(0, 2),
    //                       )
    //                     ],
    //                   ),
    //                   child: Text(
    //                     'MyShop',
    //                     style: TextStyle(
    //                       color: Theme.of(context)
    //                           .accentTextTheme
    //                           .titleLarge
    //                           .color,
    //                       fontSize: 50,
    //                       fontFamily: 'Anton',
    //                       fontWeight: FontWeight.normal,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Flexible(
    //                 flex: deviceSize.width > 600 ? 2 : 1,
    //                 child: AuthCard(),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;

  // final formKey = GlobalKey<FormState>();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final height = Get.height;
  final width = Get.width;

  var _isLoading = false;

  final _passwordController = TextEditingController();

  late AnimationController controller;

  late Animation<Offset> slideAnimation;

  late Animation<double> opacityAnimation;

  void showErrorDialog(String errorMsg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'An error occured',
        ),
        content: Text(errorMsg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Okay',
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on HttpException catch (error) {
      var errorMsg = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMsg = 'Email already exists with another account';
      } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMsg = 'Too many attempts , try again later';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMsg = 'Invalid email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMsg = 'Invalid Password';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMsg = 'No user found with this email';
      }
      showErrorDialog(errorMsg);
    } catch (error) {
      var errorMsg = 'Could not authenticate you. Please try again later';
      showErrorDialog(errorMsg);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    // return Card(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10.0),
    //   ),
    //   elevation: 8.0,
    //   child: AnimatedContainer(
    //     duration: Duration(
    //       milliseconds: 300,
    //     ),
    //     curve: Curves.easeInOut,
    //     height: _authMode == AuthMode.Signup ? 320 : 260,
    //     // height: heightAnimation.value.height,
    //     constraints: BoxConstraints(
    //       // minHeight: heightAnimation.value.height,
    //       minHeight: _authMode == AuthMode.Signup ? 320 : 260,
    //     ),
    //     width: deviceSize.width * 0.75,
    //     padding: EdgeInsets.all(16.0),
    //     child: Form(
    //       key: _formKey,
    //       child: SingleChildScrollView(
    //         child: Column(
    //           children: <Widget>[
    // TextFormField(
    //   decoration: InputDecoration(labelText: 'E-Mail'),
    //   keyboardType: TextInputType.emailAddress,
    //   validator: (value) {
    //     if (value.isEmpty || !value.contains('@')) {
    //       return 'Invalid email!';
    //     }
    //     return null;
    //   },
    //   onSaved: (value) {
    //     _authData['email'] = value;
    //   },
    // ),
    // TextFormField(
    //   decoration: InputDecoration(labelText: 'Password'),
    //   obscureText: true,
    //   controller: _passwordController,
    //   validator: (value) {
    //     if (value.isEmpty || value.length < 5) {
    //       return 'Password is too short!';
    //     }
    //   },
    //   onSaved: (value) {
    //     _authData['password'] = value;
    //   },
    // ),

    //             AnimatedContainer(
    //               constraints: BoxConstraints(
    //                 minHeight: _authMode == AuthMode.Signup ? 60 : 0,
    //                 maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
    //               ),
    //               duration: Duration(
    //                 milliseconds: 300,
    //               ),
    //               curve: Curves.easeIn,
    //               child: FadeTransition(
    //                 opacity: opacityAnimation,
    //                 child: SlideTransition(
    //                   position: slideAnimation,
    //                   child: TextFormField(
    //                     enabled: _authMode == AuthMode.Signup,
    //                     decoration:
    //                         InputDecoration(labelText: 'Confirm Password'),
    //                     obscureText: true,
    //                     validator: _authMode == AuthMode.Signup
    //                         ? (value) {
    //                             if (value != _passwordController.text) {
    //                               return 'Passwords do not match!';
    //                             }
    //                           }
    //                         : null,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: 20,
    //             ),
    //             if (_isLoading)
    //               CircularProgressIndicator()
    //             else
    // RaisedButton(
    //   child:
    //       Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
    //   onPressed: _submit,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(30),
    //   ),
    //   padding:
    //       EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
    //   color: Theme.of(context).primaryColor,
    //   textColor: Theme.of(context).primaryTextTheme.button.color,
    // ),
    // FlatButton(
    //   child: Text(
    //       '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
    //   onPressed: _switchAuthMode,
    //   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
    //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //   textColor: Theme.of(context).primaryColor,
    // ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    final Widget button = TextButton(
      child: Text(
        _authMode == AuthMode.Login ? 'Create an account' : 'Login here',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: _switchAuthMode,
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: TextStyle(color: Colors.purple),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.08, vertical: height * 0.04),
            child: Container(
              // alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'New to ShopApp ?',
                          style: TextStyle(
                            fontFamily: 'Lato',
                          ),
                        ),
                        button,
                      ],
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    const Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: height * 0.01),
                    TextFormField(
                      key: ValueKey('email'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          // borderSide: BorderSide(width: 2, color: Colors.purple),
                        ),
                        // labelText: 'Email Address',
                        hintText: "Enter your email",
                        hintStyle: const TextStyle(letterSpacing: 0.6),
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor.withRed(1),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),

                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      // decoration: InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || !value!.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value!;
                      },
                    ),
                    SizedBox(height: height * 0.04),
                    const Text(
                      'Password',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: height * 0.01),
                    TextFormField(
                      key: ValueKey('password'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          // borderSide: BorderSide(width: 2, color: Colors.purple),
                        ),
                        // labelText: 'Email Address',
                        hintText: "Password",
                        hintStyle: const TextStyle(letterSpacing: 0.6),
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor.withRed(1),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),

                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      obscureText: true,
                      controller: _passwordController,
                      // ignore: missing_return
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                      },
                      onSaved: (value) {
                        _authData['password'] = value!;
                      },
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text(
                                _authMode == AuthMode.Login
                                    ? 'Sign in'
                                    : 'Create an account',
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.6,
                                    fontSize: 18),
                              ),
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.028),
                                backgroundColor: Colors.purple,
                                textStyle: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .button!
                                      .color,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
