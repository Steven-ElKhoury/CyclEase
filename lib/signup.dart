import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login.dart'; // Import the login page
import 'package:cyclease/services/auth_services.dart'; // Import the AuthService class

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // Add controller to confirm password field

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void signupUser(){
     if (_formKey.currentState!.validate()) {
      authServiceSignUp(scaffoldKey: scaffoldKey, username: _usernameController.text, email: _emailController.text, password: _passwordController.text);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Heading
              const Icon(
                Icons.directions_bike,
                size: 40.0,
                color: Colors.black,
              ),
              // Form
             Padding(
                padding: const EdgeInsets.all(20.0), // Add padding around the container
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                          hintText: 'Username',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide:  BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      ),
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                        hintText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:  BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      ),
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:  BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      ),
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _confirmPasswordController, // Add controller to confirm password field
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:  BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                          errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                      ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      ),
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return 'Please confirm your password';
                        }
                        if(_passwordController.text != value){
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ]
                ),
              ),          
                // Sign Up Button
                const SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        signupUser();
                      }, // Handle sign up functionality here
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 17.0
                        ),
                      ),
                    ),
                ),
                    const SizedBox(height: 10.0),
                  
                   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        const Text(
                          'Already have an account?'
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          }, // Handle navigation to login page
                          
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent), 
                          ),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30.0),
                
                  ],
                ),
                 
              ),
             ),
              
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style.copyWith(color: Colors.grey, fontSize: 14.0),
                    children: <TextSpan>[
                      const TextSpan(text: 'By signing up, you agree to the ', style: TextStyle(decoration: TextDecoration.none)),
                      TextSpan(
                        text: 'Terms of Service',
                        style: const TextStyle(color: Colors.blueAccent, decoration: TextDecoration.none),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to Terms of Service page
                          },
                      ),
                      const TextSpan(text: ' and ', style: TextStyle(decoration: TextDecoration.none)),
                          TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(color: Colors.blueAccent, decoration: TextDecoration.none),
                          recognizer: TapGestureRecognizer()
                        ..onTap = () {
                  // Navigate to Privacy Policy page
                    },
                  ),
            const TextSpan(text: '.', style: TextStyle(decoration: TextDecoration.none)),
              ],
            ),
          ),
          ],
        ),
      ),
    ),      
    ),
  );
  }
}
