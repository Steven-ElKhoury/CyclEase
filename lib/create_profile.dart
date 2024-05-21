import 'package:flutter/material.dart';
import 'custom_formfield.dart';
import 'package:cyclease/services/profile_services.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({Key? key}) : super(key: key);
  

  @override
  CreateProfilePageState createState() => CreateProfilePageState();
}

class CreateProfilePageState extends State<CreateProfilePage> {
  
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String selectedProfilePicture = '';

  void createProfile(){
     if (selectedProfilePicture.isNotEmpty) {
      createProfileService(scaffoldKey: scaffoldKey, name: _nameController.text, age: int.parse(_ageController.text) , weight: double.parse(_weightController.text), imageUrl: selectedProfilePicture);
    }else{

    }
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

  bool _isProfilePictureSelected = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _profilePictureController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
                    'Create Profile',
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
                                                  _isProfilePictureSelected = false;
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
                              Text('Choose a Profile Picture'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // Selected Profile Picture
                      if (selectedProfilePicture.isNotEmpty)
                      Image.network(
                        selectedProfilePicture,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),

                          if (_isProfilePictureSelected) 
                            const Text(
                              'Please select a profile picture.',
                              style: TextStyle(color: Colors.red),
                            ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isProfilePictureSelected = selectedProfilePicture.isEmpty;
                              });
                              if(_formKey.currentState!.validate()){
                                createProfile();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                          ),
                          child: const Text(
                            'Create',
                            style: TextStyle(
                              fontSize: 17.0
                              ),
                            ),
                          ),
                      ),
                
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

