import 'package:flutter/material.dart';



class ProfileContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String imageUrl;
  final String name;

  const ProfileContainer({required this.onTap, required this.imageUrl, required this.name});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
           
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
          const SizedBox(height: 10), // Add some space between the image and the name
          Text(
            name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}