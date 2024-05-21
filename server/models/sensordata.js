const mongoose = require('mongoose');

const SensorDataSchema = new mongoose.Schema({
  rideId: {
    type: String,
    references: {
      model: 'Ride', // assuming the child model is named 'child'
      key: '_id',
    },
  },
  timestamp: {
    type: Date,
    default: Date.now,
    required: true
  },
  speed: {
    type: Number,
    required: true
  },
  pwm: {
    type: Number,
    required: true
  },
  rollAngle: {
    type: Number,
    required: true
  },
  balanceLevel: {
    type: Number,
    required: false,
    set: v => v == null ? null : parseFloat(v)
  }
});

module.exports = mongoose.model('SensorData', SensorDataSchema);