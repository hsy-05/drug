import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/authHome/model/time_entry.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter1/authHome/time_content/screens/search.dart';
import 'package:flutter1/helpers/device_input.dart';

class EditDrugB extends StatefulWidget {
  EditDrugB({Key key}) : super(key: key);

  @override
  _EditDrugBState createState() => _EditDrugBState();
}


class _EditDrugBState extends State<EditDrugB> {
  List<Item> Remedios = List();
  DatabaseReference itemRef;

  bool _isDeleting = false;

  Map<dynamic, dynamic> drugText;

  DatabaseReference drugBdb = FirebaseDatabase.instance
      .reference()
      .child("device")
      .child(GetDeviceID.getDeviceID)
      .child("drugB");


  Future<Null> readData() async {
    await FirebaseDatabase.instance.reference().child("device")
        .child(GetDeviceID.getDeviceID)
        .child("drugB").once().then((DataSnapshot snapshot) {
      drugText = snapshot.value;
      print("名稱：");
      print(drugText);
    });
  }

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRef = database.reference().child('drugInfo');
    itemRef.onChildAdded.listen(_onEntryAdded);
    readData();
  }

  _onEntryAdded(Event event) {
    if (!mounted) return; ////
    setState(() {
      Remedios.add(Item.fromSnapshot(event.snapshot));
    });
  }

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Color.fromRGBO(210, 180, 140, 1.0),
      elevation: 0,
      actions: [
        _isDeleting
            ? Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            right: 16.0,
          ),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.redAccent,
            ),
            strokeWidth: 3,
          ),
        )
            : IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.redAccent,
            size: 36,
          ),
          onPressed: () async {
            setState(() {
              _isDeleting = true;
            });

            await drugBdb.remove();

            setState(() {
              _isDeleting = false;
            });

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: new Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: StaticInfo.readItemsB(),
          builder: (context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            } else if (snapshot.hasData || snapshot.data != null) {
              return FirebaseAnimatedList(
                query: drugBdb,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  String drugName = snapshot.value['drugText'];
                  return Ink(
                    child: Column(
                      children: [
                        new Text(
                          "藥品名稱：",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        new Text(
                          drugName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        new Text(
                          "適應症：",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),

                      ],
                    ),
                  );
                },
              );
            }

            return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(204, 119, 34, 1.0),
                  ),
                ));
          },
        ),


      ),
    );
  }
//
// void _returnValueOfTakedrugText(BuildContext context) async {
//   await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MedicineMode(),
//       ));
// }
}
