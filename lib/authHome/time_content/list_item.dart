import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/authHome/time_content/screens/edit_time.dart';
import '../model/time_firebase.dart';

//每個ListItem的設計
class TimeListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Entry.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');  //若連不上firestore會顯示
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = snapshot.data.docs[index].data();
              String docID = snapshot.data.docs[index].id;
              String drugname = noteInfo['藥名'];
              String time = noteInfo['set_time'];

              return Ink(
                decoration: BoxDecoration(   //list的眶
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        currentTitle: time,
                        documentId: docID,
                      ),
                    ),
                  ),
                  title: Text(
                    drugname ?? "",
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    time,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          )
        );
      },
    );
  }
}
