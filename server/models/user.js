const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    username: {
        required : true,
        type: String,
        trim: true,
    },
    email:{
        required: true,
        type: String,
        trim: true,
        validate: {
            validator: (value)=>{
                const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                return value.match(re);
            },
            message: "Please enter a valid email",
        },
    },
    password:{
        required: true, 
        type: String,
    },
});

module.exports = mongoose.model('User', userSchema);
