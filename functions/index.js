const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {Storage} = require("@google-cloud/storage");

admin.initializeApp();
const storage = new Storage();

exports.uploadImage = functions.https.onRequest(async (req, res) => {
  try {
    if (req.method !== "POST") {
      return res.status(405).send("Method Not Allowed");
    }

    const file = req.body.image;

    if (!file) {
      return res.status(400).send("No file uploaded.");
    }

    // Create a reference to your Firebase Storage bucket
    const bucketName = "recruitease-cc7ab.appspot.com"; // Split the bucket name
    const bucket = storage.bucket(bucketName);

    const fileName = `job_images/${Date.now()}.png`; // Define your file name
    const fileBuffer = Buffer.from(file, "base64");

    // Upload the file to Firebase Storage
    const fileUpload = bucket.file(fileName);
    await fileUpload.save(fileBuffer, {
      metadata: {
        contentType: "image/png",
      },
    });

    // Get the file's public URL
    const publicUrl = `https://storage.googleapis.com/${bucket.name}/` + fileName;

    return res.status(200).send({url: publicUrl});console.log("Received image upload request");
console.log("File uploaded successfully:", fileName);
console.log("Public URL:", publicUrl);
console.error("Error uploading image: ", error);
  } catch (error) {
    console.error("Error uploading image: ", error);
    return res.status(500).send("Internal Server Error");
  }
});
