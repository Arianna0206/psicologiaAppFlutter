/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationToUser = functions.https.onCall(async (data, context) => {
    const { userId, title, body } = data;

    const userDoc = await admin.firestore().collection('users').doc(userId).get();
    const fcmToken = userDoc.data().fcmToken;

    if (!fcmToken) return { success: false, message: "Token FCM no encontrado" };

    const message = {
        token: fcmToken,
        notification: { title, body },
    };

    await admin.messaging().send(message);
    return { success: true, message: "Notificación enviada" };
});

