const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

// Initialize Express app
const app = express();
const port = process.env.PORT || 5000;

// Use middleware
app.use(cors());
app.use(bodyParser.json());

// MongoDB connection (use your own MongoDB URI)
mongoose.connect('mongodb://localhost:27017/mydb', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log('Connected to MongoDB'))
  .catch((err) => console.log('Error connecting to MongoDB:', err));

// Define a sample model (e.g., Patient)
const PatientSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  email: String,
  phone: String,
  address: String,
});

const Patient = mongoose.model('Patient', PatientSchema);

// Example route to create a patient
app.post('/patients', async (req, res) => {
  const { firstName, lastName, email, phone, address } = req.body;
  try {
    const newPatient = new Patient({ firstName, lastName, email, phone, address });
    await newPatient.save();
    res.status(201).send(newPatient);
  } catch (error) {
    res.status(500).send('Error saving patient: ' + error.message);
  }
});

// Example route to get all patients
app.get('/patients', async (req, res) => {
  try {
    const patients = await Patient.find();
    res.status(200).json(patients);
  } catch (error) {
    res.status(500).send('Error fetching patients: ' + error.message);
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
