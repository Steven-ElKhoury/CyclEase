const express = require('express');
const authRouter = express.Router();
const User = require('../models/user.js');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Sign Up
authRouter.post('/api/signup', async (req, res)=> {
    console.log("signup");
    try{
        const {username, email, password,token} = req.body;
        
        const existingEmail = await User.findOne({ email: { $regex: new RegExp(`^${email}$`, 'i') } });
        const existingUserName = await User.findOne({ username: { $regex: new RegExp(`^${username}$`, 'i') } });

        if(existingEmail){
            console.log("Email already exists");
            return res.status(400).json({message: "Email already exists"});
        }
        if(existingUserName){
            console.log("Username already exists");
            return res.status(400).json({message: "Username already exists"});
        }
        console.log('hashing')
        const hashedPassword = await bcrypt.hash(password, 8);

        let user = new User({
            username,
            email,
            password: hashedPassword,
        });
        user = await user.save();
        res.json(user);
    }catch(e){
        res.status(500).json({message: e.message});
    }
});

// Sign In

authRouter.post('/api/signin', async (req, res)=> {
    console.log("signin");
    try{
        const { username, password } = req.body;

        const user = await User.findOne({ username }); // user includes username, email, password
        console.log(user);
        if(!user){
            return res.status(400).json({message: "User does not exist"});
        }

        const isMatch = await bcrypt.compare(password, user.password);
        if(!isMatch){
            return res.status(400).json({message: "Incorrect Password"});
        }
        console.log("signing in");
        console.log(user._id);
        console.log(process.env.JWT_SECRET);
        const token = jwt.sign({ id: user._id}, process.env.JWT_SECRET);
        console.log("token");
        res.json({ token, ...user._doc}); // ...user._doc includes username, email, password limits the returned data to only what we need

    }catch(e){
        res.status(500).json({message: e.message});
        }
    }
);
module.exports = authRouter;
