//mongodb://localhost:27017
const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");

const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect("mongodb://localhost:27017")
  .then(() => console.log("Connected to MongoDB"))
  .catch(err => console.error(err));

// Mongoose Schema
const MessageSchema = new mongoose.Schema({
  // chatId: String,
  role: String,
  text: String,
});
const Message = mongoose.model("Message", MessageSchema);

// Get all messages
app.get("/messages", async (req, res) => {
  const messages = await Message.find();
  res.json(messages);
});

// Add a message to MongoDB
app.post("/messages", async (req, res) => {
  try {
    const { role, text } = req.body;

    // Create a new message document
    const message = new Message({ role, text });

    // Save to MongoDB
    await message.save();

    res.json({ status: "Message saved!" });
  } catch (error) {
    console.error("Error saving message:", error);
    res.status(500).json({ error: "Failed to save message" });
  }
});

//Delete all messages
app.delete("/messages", async (req, res) => {
  try {
    await Message.deleteMany({});
    console.log("All messages deleted")
    res.json({ status: "All messages deleted" });
  } catch (error) {
    console.error("Error deleting messages:", error);
    res.status(500).json({ error: "Failed to delete messages" });
  }
});


app.listen(3000, () => console.log("Server running on http://localhost:3000"));
