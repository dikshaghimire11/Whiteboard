import 'package:flutter/material.dart';

class ShowTextDialog extends StatefulWidget {
  @override
  State<ShowTextDialog> createState() => _ShowTextDialog();
}

class _ShowTextDialog extends State<ShowTextDialog> {
  TextEditingController text = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type a text',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(text);
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
