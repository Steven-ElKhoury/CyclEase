import 'package:cyclease/choose_profile.dart';
import 'package:cyclease/models/profile.dart';
import 'package:flutter/material.dart';
import 'custom_formfield.dart';
import 'package:cyclease/services/profile_services.dart';

class EditProfilePage extends StatefulWidget {
  
  final Profile profile;
  const EditProfilePage({super.key, required this.profile});
  
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  String selectedProfilePicture = '';
  String oldName = '';
  void editProfile() async{
      if(_formData['name'] == _nameController.text){
        _formData.remove('name');
      }else{
        _formData['name'] = _nameController.text;
      }
      if(_formData['age'] == int.parse(_ageController.text)){
        _formData.remove('age');
      }else{
        _formData['age'] = int.parse(_ageController.text);
      }
      if(_formData['weight'] == double.parse(_weightController.text)){
        _formData.remove('weight');
      }else{
        _formData['weight'] = double.parse(_weightController.text);
      }
      if(_formData['imageUrl'] == selectedProfilePicture){
        _formData.remove('imageUrl');
      }else{
        _formData['imageUrl'] = selectedProfilePicture;
      }
      if(_formData.length == 1){
        Navigator.pop(context);
        return;
      }else {
        await updateProfileService(scaffoldKey: scaffoldKey, updatedFields: _formData);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ChooseProfile()), (Route<dynamic> route) => false,);
      }
    }

    void deleteProfile() async{
      await deleteProfileService(scaffoldKey: scaffoldKey, name: oldName);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ChooseProfile()), (Route<dynamic> route) => false,);
    }

  List<String> profilePictureUrls = [
    'https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png',
    'https://mir-s3-cdn-cf.behance.net/project_modules/disp/84c20033850498.56ba69ac290ea.png',
    'https://mir-s3-cdn-cf.behance.net/project_modules/max_632/bb3a8833850498.56ba69ac33f26.png',
    'https://mir-s3-cdn-cf.behance.net/project_modules/max_632/e70b1333850498.56ba69ac32ae3.png',
    'https://mir-s3-cdn-cf.behance.net/project_modules/max_632/c7906d33850498.56ba69ac353e1.png',
    'https://mir-s3-cdn-cf.behance.net/project_modules/max_632/fd69a733850498.56ba69ac2f221.png',
    // Add more URLs as needed
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _profilePictureController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  @override
    void initState() {
      super.initState();
      _nameController.text = widget.profile.name;
      _ageController.text = widget.profile.age.toString();
      _weightController.text = widget.profile.weight.toString();
      selectedProfilePicture = widget.profile.imageUrl;
      _formData['name'] = widget.profile.name;
      _formData['age'] = widget.profile.age;
      _formData['weight'] = widget.profile.weight;
      _formData['imageUrl'] = widget.profile.imageUrl;
      oldName = widget.profile.name;
      _formData['oldName'] = oldName;
    }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _profilePictureController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
         backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              editProfile();
            },
          ),
         title: const Center(
          child: Icon(
            Icons.directions_bike,
            size: 40.0,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: 
         SingleChildScrollView( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Heading             
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
                    'Edit Profile',
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
                    CustomFormField(obscureText: false, validator: 'Please enter a name', placeholder: 'Name', textEditingController: _nameController, dataType: 'string',),
                    const SizedBox(height: 10.0),
                    CustomFormField(obscureText: false, validator: 'Please enter a valid age', placeholder: 'Age', textEditingController: _ageController, dataType: 'int'),
                    const SizedBox(height: 10),
                    CustomFormField(obscureText: false, validator: 'Please enter a valid weight', placeholder: 'Weight', textEditingController: _weightController, dataType: 'float'),
                    const SizedBox(height: 10),
                  ],
                  ),
                  ),
        
                InkWell(
                        onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Theme(
                              data: ThemeData(
                                colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey),
                                ),
                              child: Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Choose Profile Picture', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                      const SizedBox(height: 20.0),
                                      SizedBox(
                                        height: 200, // Adjust this value as needed
                                        width: double.maxFinite,
                                        child: Scrollbar(
                                          trackVisibility: true,
                                          controller: _scrollController ,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: profilePictureUrls.length,
                                          separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
                                          itemBuilder: (BuildContext context, int index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedProfilePicture = profilePictureUrls[index];
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Image.network(profilePictureUrls[index], width: 100, height: 100), // Adjust width and height as needed
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.add),
                              SizedBox(width: 10.0),
                              Text('Change Profile Picture'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // Selected Profile Picture
                      Image.network(
                        selectedProfilePicture,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
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
                 bottomNavigationBar: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity, // Make the container take the entire width
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red), // Set the button color to red
                        foregroundColor: MaterialStateProperty.all(Colors.white), // Set the text color to white
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Theme(
                              data: ThemeData(
                                colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey),
                                ),
                              child: Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Delete Profile', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                      const SizedBox(height: 20.0),
                                      const Text('Are you sure you want to delete this profile?'),
                                      const SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.red), // Set the button color to red
                                              foregroundColor: MaterialStateProperty.all(Colors.white), // Set the text color to white
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.red), // Set the button color to red
                                              foregroundColor: MaterialStateProperty.all(Colors.white), // Set the text color to white
                                            ),
                                            onPressed: () {
                                              deleteProfile();
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text('Delete Profile'),
                    ),
                  ),
                ),
                );
              }         
  }

