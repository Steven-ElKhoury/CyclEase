import 'package:cyclease/create_profile.dart';
import 'package:cyclease/dashboard.dart';
import 'package:cyclease/edit_profile.dart';
import 'package:cyclease/models/profile.dart';
import 'package:cyclease/services/profile_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cyclease/providers/profile_provider.dart';
import 'profile_container.dart';

class ChooseProfile extends StatefulWidget {
  const ChooseProfile({Key? key}) : super(key: key);
  @override
  State<ChooseProfile> createState() => _ChooseProfileState();
}

class _ChooseProfileState extends State<ChooseProfile> {
  bool isEditMode = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfiles();
    });
  }

  void fetchProfiles() async{
    List<Profile> profiles = await fetchProfilesService();
    context.read<ProfileProvider>().setProfiles(profiles);
  }

  Future<List<Profile>> fetchProfilesService() async{
    return await getProfilesService(
      scaffoldKey: scaffoldKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.directions_bike, size: 40),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.edit, size: 40),
                onPressed: () {
                  setState(() {
                    isEditMode = !isEditMode;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              return GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: profileProvider.profiles.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (ctx, i) {
                  if (i < profileProvider.profiles.length) {
                    return Stack(
                      children: <Widget>[
                        ProfileContainer(
                          onTap: () {
                            if(!isEditMode){
                              profileProvider.setSelectedProfile(profileProvider.profiles[i]);
                               Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const DashboardPage(),)
                                , (route) => false
                              );
                            }
                          },
                          imageUrl: profileProvider.profiles[i].imageUrl,
                          name: profileProvider.profiles[i].name,
                        ),
                        if (isEditMode)
                          Positioned(
                            top: -10,
                            right: -10,
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              iconSize: 30,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(profile: profileProvider.profiles[i]),
                                  ),
                                );
                              }
                            ),
                          ),
                      ],
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateProfilePage(),)
                        );
                      },
                      child: const GridTile(
                        footer: GridTileBar(
                          backgroundColor: Colors.black54,
                          title: Text(
                            'Add profile',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        child: Icon(Icons.add),
                      ),
                    );
                  }
                }
              );
            },
          ),
        ),
      ),
    );
  }
}