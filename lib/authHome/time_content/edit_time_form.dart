import 'package:flutter/material.dart';
import 'package:flutter1/authHome/model/time_firebase.dart';
import 'screens/edit_time.dart';

class EditItemForm extends StatefulWidget {

  final String currentTitle;
  final String documentId;

  const EditItemForm({
     this.currentTitle,
     this.documentId,
  });

  @override
  _EditItemFormState createState() => _EditItemFormState();
}

class _EditItemFormState extends State<EditItemForm> {
  final _editItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  TextEditingController _titleController;
  @override
  void initState() {
    _titleController = TextEditingController(
      text: widget.currentTitle,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _editItemFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.0),
                Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                // CustomFormField(         ///////////////////
                //   isLabelEnabled: false,
                //   controller: _titleController,
                //   keyboardType: TextInputType.text,
                //   inputAction: TextInputAction.next,
                //   label: 'Title',
                //   hint: 'Enter your note title',
                // ),
                SizedBox(height: 24.0),

                SizedBox(height: 8.0),
              ],
            ),
          ),
          _isProcessing
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
            ),
          )
              : Container(
            width: double.maxFinite,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () async {

                if (_editItemFormKey.currentState.validate()) {
                  setState(() {
                    _isProcessing = true;
                  });

                  // await Database.updateItem(
                  //   docId: widget.documentId,
                  //   title: _titleController.text,
                  //   description: _descriptionController.text,
                  // );

                  setState(() {
                    _isProcessing = false;
                  });

                  Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  'UPDATE ITEM',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
