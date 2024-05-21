import 'dart:convert';
import 'package:cyclease/choose_profile.dart';
import 'package:cyclease/models/user.dart';
import 'package:cyclease/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cyclease/utils/constants.dart';
import 'package:cyclease/providers/user_provider.dart';
import 'package:provider/provider.dart';

Future<void> authServiceSignUp({
  required GlobalKey<ScaffoldState> scaffoldKey,
  required String username,
  required String email,
  required String password,
}) async {
  // Getting the current context of the widget in the widget tree
  final context = scaffoldKey.currentContext;
   try {
  User user = User(
    id: '',
    username: username,
    email: email,
    token: '',
    password: password,
  );

  http.Response res = await http.post(
    Uri.parse('${Constants.uri}/api/signup'),
    body: user.toJson(),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (context != null && context.mounted) {
    httpErrorHandle(
      res: res,
      context: context,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Account created! Login with the same credentials!'),
        ));
      },
    );
  }
} catch (e) {
  if (context != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e.toString()),
    ));
  }
}
}

Future<bool> authServiceSignIn({
  required GlobalKey<ScaffoldState> scaffoldKey,
  required String username,
  required String password,
}) async {
  // Getting the current context of the widget in the widget tree
  final context = scaffoldKey.currentContext;
   try {
    User user = User(
    id: '',
    email: '',
    username: username,
    token: '',
    password: password,
  );
  //Create storage
  FlutterSecureStorage storage = const FlutterSecureStorage();
  final userProvider = Provider.of<UserProvider>(context!, listen: false);

  http.Response res = await http.post(
    Uri.parse('${Constants.uri}/api/signin'),
    body: user.toJson(),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (context.mounted) {
    httpErrorHandle(
      res: res,
      context: context,
      onSuccess: () async{
        userProvider.setUser(res.body);
        await storage.write(key: 'x-auth-token', value: jsonDecode(res.body)['token']);
        if(context.mounted){
         Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ChooseProfile()),
          (Route<dynamic> route) => false,
        );
      }
      },
    );
  }
  return res.statusCode == 200;
} catch (e) {
  if (context != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e.toString()),
    ));
  }
  return false;
}
}