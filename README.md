# CyclEase
This project consists of a Flutter mobile application that allows users to control a self balancing bicycle using a reaction built for my final year project aiming to help kids learn how to ride a bicycle.

The project's backend was built using Node & Express and the database was setup on MongoDB

Below is a few pages from the flutter app that showcase the UI:
<img width="562" alt="image" src="https://github.com/Steven-ElKhoury/CyclEase/assets/128305547/8748a2c2-9062-4796-bca8-2558f57afbdf">

The application includes the following features and information:

•	The amount of time spent riding.
•	Distance traveled during the riding session.
•	Speed tracking to show how fast the child was riding, this could help improve the understanding of optimal riding patterns for a child to learn how to ride a bicycle.
•	Calorie burn estimation.
•	Emergency assistance button to quickly connect users to local emergency services in case of an accident.
•	Music integration, allowing users to have their favorite music playlists into the app for an enjoyable riding experience and may offer insights into the effect of music on acquiring new skills and physical activity.
•	Control system power tracking to offer insights on the child’s improvement and the functioning of balance assistance.
•	A trainer mode which will teach and guide the child to steer into the direction of a fall to balance, also known as counter steering, will help the child understand how to shift his body weight while riding. 

The database design is included below for reference:
![image](https://github.com/Steven-ElKhoury/CyclEase/assets/128305547/e074b6d4-ed61-4a83-bf53-709253f282cf)


To run the application make sure to add the server's IP address in the constants.dart file, the MongoDB passkey in the variables.env file, and the IP of the MQTT device in the dashboard.dart file. Write the command flutter pub get in the terminal to download all dependencies for the project.

![image](https://github.com/Steven-ElKhoury/CyclEase/assets/128305547/0a06f78d-114e-4def-9a65-72662bd1556f)

The above image shows the overall architecture of the system, the MQTT publisher was set up on a raspberry pi and bluetooth communication was used to control the ESP32 which is running the control system.






