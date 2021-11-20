import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter1/authHome/model/time_entry.dart';
import 'package:flutter1/helpers/device_input.dart';

// class DrugItem {   //藥品資料庫
//   String key;
//   String CSname;
//   String use;
//
//   DrugItem(this.CSname, this.use);
//
//   DrugItem.fromSnapshot(DataSnapshot snapshot)
//       : key = snapshot.key,
//         CSname = snapshot.value["中文品名"],
//         use = snapshot.value["適應症"];
//
//   toJson() {
//     return {
//       "CSname": CSname,
//       "use": use,
//     };
//   }
// }

class UserDrug {  //會員設定的藥品
  String key;
  String CSname;
  // String userDI;

  UserDrug(this.CSname); //this.userDI

  UserDrug.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        CSname = snapshot.value["drugText"];
        // userDI = snapshot.value["適應症"];

  toJson() {
    return {
      "CSname": CSname,
      // "userDI": userDI,
    };
  }
}

class DrugAText{
  static String drugAText;

  Future<String> readDrugAText()  async{
    await FirebaseDatabase.instance.reference()
        .child("device").child(GetDeviceID.getDeviceID).child("drugA").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        drugAText = values['drugText'];
      });
      print("名稱：");
      print(drugAText);
      return drugAText;
    });
  }
}

//
// List<DrugItem> drugItemList;
// List<UserDrug> userDrugList;
//
// Future<List<DrugItem>> _getFollowersUsers() async {
//   DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
//   DataSnapshot snapshot = await databaseReference
//       .child('users').child(StaticInfo.userid)
//       .once();
//
//   List<DrugItem> drugItemList = [];
//   for (DataSnapshot item in snapshot.value) {
//     var data = item.value;
//     if (data["id"] == _userId) continue;
//
//     DrugItem drugItem = DrugItem();
//     user.name = data["name"];
//     user.photoUrl = data["imageUrl"];
//     user.username = data["username"];
//     user.id = data["id"];
//     user.bio = data["bio"];
//
//     drugItemList.add(user);
//   }
//
//   return drugItemList;
// }
//
// Future<List<Users>> _getFollowingUsers() async {
//   Firestore db = Firestore.instance;
//
//   QuerySnapshot querySnapshot = await db
//       .collection('following')
//       .document(_userId)
//       .collection("userFollowing")
//       .getDocuments();
//
//   List<Users> followingList = [];
//   for (DocumentSnapshot item in querySnapshot.documents) {
//     var data = item.data;
//     if (data["id"] == _userId) continue;
//
//     Users user = Users();
//     user.name = data["name"];
//     user.photoUrl = data["imageUrl"];
//     user.username = data["username"];
//     user.id = data["id"];
//     user.bio = data["bio"];
//
//     followingList.add(user);
//   }
//
//   return followingList;
// }
//
// getFinalList() {
//   List<User> result = [];
//   followingList.forEach((aElement) {
//     User value =
//     followersList.firstWhere((bElement) => bElement.id == aElement.id, orElse: () => null);
//     if (value != null) {
//       result.add(value);
//     }
//   });
//   print(result);
// }