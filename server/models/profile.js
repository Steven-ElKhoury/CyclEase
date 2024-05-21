const { Double } = require('mongodb');
const mongoose = require('mongoose');

const profileSchema = new mongoose.Schema({
    imageUrl: {
        type: String,
        required: true
    },
    name: {
        type: String,
        required: true,
        unique: true,
    },
    age: {
        type: Number,
        required: true
    },
    weight: {
        type: Number,
        required: true
    },
    email: {
        type: String,
        required: true
    }
});

const Profile = mongoose.model('Profile', profileSchema);

module.exports = Profile;
