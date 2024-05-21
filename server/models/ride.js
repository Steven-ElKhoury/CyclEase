const mongoose = require('mongoose');

const rideSchema = new mongoose.Schema({
    rideId: {
        type: Number,
        allowNull: false,
        primaryKey: true,
        autoIncrement: true,
      },
      startDateTime: {
        type: Date,
        allowNull: true,
      },
      endDateTime: {
        type: Date,
        allowNull: true,
      },
      distance: {
        type: Number,
        allowNull: true,
      },
      duration: {
        type: Number,
        allowNull: true,
      },
      speed: {
        type: Number,
        allowNull: true,
      },
      caloriesBurned: {
        type: Number,
        allowNull: true,
      },
      profileId: {
        type: String,
        references: {
          model: 'profile', // assuming the child model is named 'child'
          key: '_id',
        },
      }
});

module.exports = mongoose.model('Ride', rideSchema);