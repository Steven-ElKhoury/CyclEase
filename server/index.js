const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth.js');
const profileRouter = require('./routes/profile_endpoints.js');
const rideRouter = require('./routes/ride_endpoints.js');
const cors = require('cors');
const PORT = process.env.PORT || 3000;
const app = express();
const mqtt = require('mqtt');

require('dotenv').config({ path: './variables.env' });
app.use(cors());

app.use(express.json());
app.use(authRouter);
app.use(profileRouter);
app.use(rideRouter);

const DB = process.env.DB;

mongoose.connect(DB).then(() => {
    console.log("connected to mongoDB");
}).catch((err) => {
    console.log(err);
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`);
});


