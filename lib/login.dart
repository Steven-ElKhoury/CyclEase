import 'package:cyclease/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:cyclease/loading_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void signInButtonPressed(BuildContext context) async {
  // Validate the user's credentials...
      setState(() {
        _loading = true;
      });

      // Validate the user's credentials...
      bool  loginSuccessful =  await authServiceSignIn(
        scaffoldKey: scaffoldKey,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if(loginSuccessful){

      }else{
        setState(() {
          _loading = false;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _loading ? const LoadingScreen() : Padding(
          padding: const EdgeInsets.all(20.0),
          child: 
         SingleChildScrollView( 
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
                    'Sign In',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Form(
                    key: _formKey,
                    child: Column(
                    children: [
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
                  ],
                  ),
                  ),
                    
                const SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          signInButtonPressed(context);
                        }
                      }, // Handle login functionality here
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                    ),
                    child: const Text(
                      'Sign In',
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
                          "Don't have an account?"
                        ),
                        TextButton(
                          onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignupPage()),
                            );
                          }, // Handle navigation to login page
                          
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30.0),
                
                  ],
                ),
                 
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
