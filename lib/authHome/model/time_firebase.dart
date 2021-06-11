import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter1/utils/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';  //
import 'package:flutter1/authHome/model/user.dart';

  class Times {

    DateTime dateTime;

    Times({ this.dateTime});

  }

final CollectionReference timeCollection = FirebaseFirestore.instance.collection('set_times');

  class Entry {
    static String userid;

    static Future<void> addItem({
      String dateTime,
    }) async {
      DocumentReference documentReferencer =
      timeCollection.doc(userid).collection('items').doc();

      Map<String, dynamic> data = <String, dynamic>{
        'set_time': dateTime,
      };

      await documentReferencer
          .set(data)
          .whenComplete(() => print("Note item added to the database"))
          .catchError((e) => print(e));
    }

////
    static Future<void> updateItem({
      String dateTime,
      String docId,
    }) async {
      DocumentReference documentReferencer =
      timeCollection.doc(userid).collection('items').doc(docId);

      Map<String, dynamic> data = <String, dynamic>{
        'set_time': dateTime,
      };

      await documentReferencer
          .update(data)
          .whenComplete(() => print("Note item updated in the database"))
          .catchError((e) => print(e));
    }

////
    static Stream<QuerySnapshot> readItems() {
      CollectionReference timeItemCollection =
      timeCollection.doc(userid).collection('items');

      return timeItemCollection.snapshots();
    }

    ////

    static Future<void> deleteItem({
      String docId,
    }) async {
      DocumentReference documentReferencer =
      timeCollection.doc(userid).collection('items').doc(docId);

      await documentReferencer
          .delete()
          .whenComplete(() => print('Note item deleted from the database'))
          .catchError((e) => print(e));
    }
  }
////
//      Future<void> updateUserData(String dateTime) async {
//       return await timeCollection.doc(uid).set({
//          'set_time': dateTime,
//        });
//      }
//
//  List<Times> _timeListFromSnapshot(QuerySnapshot snapshot) {
//    return snapshot.docs.map((doc) {
//     //print(doc.data);
//      return Times(
//      dateTime: doc.data()['dateTime'] ?? '',
//     );
//    }).toList();
//  }
// // user data from snapshots
// UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
//   return UserData(
//     uid: uid,
//      dateTime: snapshot.data()['dateTime'],
//   );
//  }
//   }
  //
  // // get brews stream
  // Stream<List<Times>> get times {
  //   return timeCollection.snapshots()
  //       .map(_timeListFromSnapshot);
  // }
  //
  // // get user doc stream
  // Stream<UserData> get userData {
  //   return timeCollection.doc(uid).snapshots()
  //       .map(_userDataFromSnapshot);
  // }
