const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');
const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());

app.get('/', (req, res) => {
  res.send(`
    <h2>Submit Your Details</h2>
    <form action="/submit" method="post">
      <label>Name:</label><br><input type="text" name="name" /><br><br>
      <label>Email:</label><br><input type="text" name="email" /><br><br>
      <button type="submit">Submit</button>
    </form>
  `);
});

app.post('/submit', async (req, res) => {
  try {
    const { name, email } = req.body;
    const response = await axios.post('http://k8s-backend:5000/submit', { name, email });
    res.send(`<h3>${response.data.message}</h3>`);
  } catch (err) {
    res.status(500).send(`<h3>Error: ${err.message}</h3>`);
  }
});

app.listen(3000, () => console.log('Frontend running on port 3000'));
