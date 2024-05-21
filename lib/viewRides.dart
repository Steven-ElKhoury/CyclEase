import 'package:flutter/material.dart';
import 'package:cyclease/ride.dart'; // Import your ride services
import 'package:cyclease/services/ride_services.dart'; // Import your RideInfoWidget

class ViewRides extends StatefulWidget {
  final String profileId;

  ViewRides({required this.profileId});

  @override
  _ViewRidesState createState() => _ViewRidesState();
}

class _ViewRidesState extends State<ViewRides> {
   List<Ride> rides = [];

 @override
void initState() {
  super.initState();
  initAsync();
}

void initAsync() async {
  var result = await getRides(widget.profileId);
  setState(() {
    rides = result;
    print(rides);
  });
}

    void deleteRide(String rideId) {
    setState(() {
      rides.removeWhere((ride) => ride.rideId == rideId);
    });
    // Call your function to delete the ride from the database
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Rides'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: rides.length,
        itemBuilder: (context, index) {
          Ride ride = rides[index];
          return RideInfoWidget(
            rides: rides,
            rideId: ride.rideId,
            startDateTime: ride.startDateTime,
            endDateTime: ride.endDateTime,
            caloriesBurned: ride.caloriesBurned,
            distanceTraveled: ride.distanceTraveled,
            duration: ride.duration,
            onDelete: deleteRide,
          );
        },
      ),
    );
  }
}