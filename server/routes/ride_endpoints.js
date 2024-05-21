const express = require('express');
const router = express.Router();
const Ride = require('../models/Ride'); // adjust the path according to your project structure
const SensorData = require('../models/SensorData'); // adjust the path according to your project structure

// POST endpoint to create a new ride
router.post('/api/startride', async (req, res) => {
  console.log(req.body);  
  console.log('starting....');
    try {
    const ride = await Ride.create({
      startDateTime: req.body.startDateTime,
      profileId: req.body.childId
    });
    res.status(201).json({ rideId: ride._id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT endpoint to update a ride
// PUT endpoint to update a ride
router.put('/api/stopride/:id', async (req, res) => {
  console.log('stopping....');
  try {
    const ride = await Ride.findByIdAndUpdate(req.params.id, {
      endDateTime: req.body.endDateTime,
      distance: req.body.distance,
      duration: req.body.duration,
      speed: req.body.speed,
      caloriesBurned: req.body.caloriesBurned
    }, { new: true }); // { new: true } option returns the updated document

    if (ride) {
      console.log('success');
      res.status(200).json({ message: 'Ride updated successfully' });
    } else {
      console.log('404');
      res.status(404).json({ message: 'Ride not found' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});


// POST endpoint to add sensor data
router.post('/api/addSensorData/:id', async (req, res) => {
  console.log(req.params.id);
  console.log(req.body);
  try {
    const sensorData = await SensorData.create({
      rideId: req.params.id,
      timestamp: req.body.timestamp,
      speed: req.body.speed,
      pwm: req.body.pwm,
      rollAngle: req.body.rollAngle,
      balanceLevel: req.body.balanceLevel
    });
    console.log(sensorData);
    console.log('success');
    res.status(201).json(sensorData);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: err.message });
  }
});

// GET endpoint to retrieve a ride
// GET endpoint to retrieve all rides
// GET endpoint to retrieve all rides for a profile
router.get('/api/rides/:profileId', async (req, res) => {
  try {
    console.log(req.params.profileId);
    const rides = await Ride.find({ profileId: req.params.profileId });
    res.status(200).json(rides);
    console.log(rides);

  } catch (err) {
    console.log(err);
    res.status(500).json({ error: err.message });
  }
});

router.delete('/api/deleteRide/:rideId', async (req, res) => {
  try {
    const ride = await Ride.findById(req.params.rideId);
    if (!ride) {
      return res.status(404).json({ error: 'Ride not found' });
    }

    // Delete all sensor data associated with the ride
    await SensorData.deleteMany({ rideId: req.params.rideId });

    // Delete the ride
    await Ride.findByIdAndDelete(req.params.rideId);

    res.status(200).json({ message: 'Ride and associated sensor data deleted successfully' });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: err.message });
  }
});

router.get('/api/getSensorData/:rideId', async (req, res) => {
  try {
    console.log(req.params.rideId)
    const sensorData = await SensorData.find({ rideId: req.params.rideId });
    if (!sensorData) {
      return res.status(404).json({ error: 'Sensor data not found' });
    }

    res.status(200).json(sensorData);
    console.log(sensorData)
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;