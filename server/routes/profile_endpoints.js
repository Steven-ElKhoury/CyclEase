// Import necessary modules
const express = require('express');
const router = express.Router();
const Profile = require('../models/Profile');

// Add a user's profile to the database
router.post('/api/addprofile', async (req, res) => {
    try {
        console.log(req.body);
        const { name, email, age, weight, imageUrl } = req.body;
        
        const existingProfile = await Profile.findOne({ name });
        if (existingProfile) {
            return res.status(400).json({ message: 'A profile with this name already exists' });
        }

        // Create a new profile object
        const profile = new Profile({
            name,
            email,
            age,
            weight,
            imageUrl
        });

        console.log(profile);
        // Save the profile to the database
        await profile.save();

        res.status(201).json({ message: 'Profile added successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Failed to add profile' });
    }
});

// Retrieve profiles associated with an email
router.get('/api/getprofiles/:email', async (req, res) => {
    try {
        const email = req.params.email;
        console.log(email);
        // Find profiles with the given email
        const profiles = await Profile.find({ email });
        console.log(profiles);
        res.status(200).json(profiles);
    } catch (error) {
        res.status(500).json({ message: 'Failed to retrieve profiles' });
    }
});

router.put('/api/editprofile/:email', async (req, res) => {
    try {
        const { email } = req.params;
        const updateFields = req.body;

        const oldName = updateFields.oldName;
        delete updateFields.oldName;
        
        const profile = await Profile.findOne({ name: oldName, email });
       
        const id = profile._id;

        if(updateFields.name != null){
            const existingProfile = await Profile.findOne( {name: updateFields.name, email });
            if (existingProfile) {
                return res.status(400).json({ message: 'A profile with this name already exists' });
            }
        }

        const updatedProfile = await Profile.findOneAndUpdate({ _id: id, email }, updateFields, { new: true });
        if (!updatedProfile) {
            return res.status(404).json({ message: 'Profile not found' });
        }
        
        res.status(200).json(updatedProfile);
    } catch (error) {
        res.status(500).json({ message: 'Failed to edit profile' });
    }
});


 
router.delete('/api/deleteprofile/:email/:name', async (req, res) => {
    try {
        console.log("deleting profile")
        console.log(req.params);
        const { email, name } = req.params;
        console.log(name);
        console.log(email);
        await Profile.findOneAndDelete({ name, email });
        console.log("deleted")
        res.status(200).json({ message: 'Profile deleted' });
    } catch (error) {
        res.status(500).json({ message: 'Failed to delete profile' });
    }
});
// Keep track of the selected profile on the frontend
// This can be handled on the frontend using state management libraries like Redux or React Context
module.exports = router;
