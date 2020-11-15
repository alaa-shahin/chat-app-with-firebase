const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
exports.myFunction = functions.firestore
  .document('chat/{text}')
  .onCreate((snapShot, context) => {
      return admin.messaging().sendToTopic('chat',{
          notification: {
              title: 'New message',
              body: snapShot.data().text,
              clickAction: 'FLUTTER_NOTIFICATION_CLICK',
          },
      });
  });

