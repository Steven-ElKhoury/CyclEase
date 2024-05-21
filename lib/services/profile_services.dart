import 'package:cyclease/choose_profile.dart';
import 'package:cyclease/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cyclease/utils/constants.dart';
import 'package:cyclease/models/profile.dart';
import 'package:cyclease/utils/utils.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

  // Method to create a profile
  Future<void> createProfileService({
   required GlobalKey<ScaffoldState> scaffoldKey,
   required String name,
   required int age,
   required double weight,
   required String imageUrl,
}) async {
  // Getting the current context of the widget in the widget tree
  final context = scaffoldKey.currentContext;
  final userProvider = Provider.of<UserProvider>(context!, listen: false);

  String email = userProvider.user.email;
   try {
  Profile profile = Profile(
    childId: '', 
    email: email,
    name: name,
    age: age,
    weight: weight,
    imageUrl: imageUrl,
  );

  http.Response res = await http.post(
    Uri.parse('${Constants.uri}/api/addprofile'),
    body: profile.toJson(),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (context.mounted) {
    httpErrorHandle(
      res: res,
      context: context,
      onSuccess: () {
       Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ChooseProfile()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }
} catch (e) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e.toString()),
    ));
  }
}
}

  // Method to retrieve profiles belonging to a user
  // Method to retrieve profiles belonging to a user
Future<List<Profile>> getProfilesService({
  required GlobalKey<ScaffoldState> scaffoldKey,
}) async {
  
  final context = scaffoldKey.currentContext;
  final userProvider = Provider.of<UserProvider>(context!, listen: false);
  String email = userProvider.user.email;
  final response = await http.get(Uri.parse('${Constants.uri}/api/getprofiles/$email'));
 
  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON.
    List<dynamic> profileList = jsonDecode(response.body);
    return profileList.map((profile) => Profile.fromMap(profile)).toList();
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load profiles');
  }
}

// Method to update a profile
Future<void> updateProfileService({
   required GlobalKey<ScaffoldState> scaffoldKey,
   required Map<String, dynamic> updatedFields,
}) async {
   final context = scaffoldKey.currentContext;
   final userProvider = Provider.of<UserProvider>(context!, listen: false);
   String email = userProvider.user.email;
try{
  final response = await http.put(
    Uri.parse('${Constants.uri}/api/editprofile/$email'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(updatedFields),
  );
  
  if (context.mounted) {
    httpErrorHandle(
      res: response,
      context: context,
      onSuccess: () {
      },
    );
  }
} catch (e) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e.toString()),
    ));
  }
}
}

// Method to delete a profile
Future<void> deleteProfileService({
  required GlobalKey<ScaffoldState> scaffoldKey,
  required String name,
}) async {
  final context = scaffoldKey.currentContext;
  final userProvider = Provider.of<UserProvider>(context!, listen: false);
  String email = userProvider.user.email;

  final response = await http.delete(
    Uri.parse('${Constants.uri}/api/deleteprofile/$email/$name'),
  );

  if (response.statusCode != 200) {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to delete profile');
  }
}