// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sqflite_notepad/models/mynote.dart';
import 'package:sqflite_notepad/server/db_helper.dart';
import 'package:sqflite_notepad/theme.dart';

class NotePage extends StatefulWidget {
  final Mynote? _myNote;
  final bool _isNew;

  const NotePage(this._myNote, this._isNew, {Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String? title;
  bool btnSave = false;
  bool btnEdit = true;
  bool btnDelete = true;

  Mynote? mynote;
  String? createDate;

  final cTitle = TextEditingController();
  final cNote = TextEditingController();

  var now = DateTime.now();

  bool _enabledTextField = true;

  Future addRecord() async {
    var db = DBHelper();
    String dateNow = "${now.day}-${now.year}, ${now.hour}:${now.minute}";

    var _mynote = Mynote(
      cTitle.text,
      cNote.text,
      dateNow,
      dateNow,
      now.toString(),
    );

    await db.saveNote(_mynote);
    print("saved");
  }

  Future updateRecord() async {
    var db = DBHelper();
    String dateNow = "${now.day}-${now.year}, ${now.hour}:${now.minute}";

    var mynote = Mynote(
      cTitle.text,
      cNote.text,
      createDate,
      dateNow,
      now.toString(),
    );

    mynote.setNoteId(this.mynote!.id as int);
    await db.updateNote(mynote);
  }

  void _savedData() {
    setState(() {
      if (widget._isNew) {
        addRecord();
      } else {
        updateRecord();
      }
      Navigator.of(context).pop();
    });
  }

  void _editData() {
    setState(() {
      _enabledTextField = true;
      btnEdit = false;
      btnSave = true;
      btnDelete = true;
      title = "Edit Note";
    });
  }

  void delete(Mynote mynote) {
    setState(() {
      var db = DBHelper();
      db.deleteNote(mynote);
    });
  }

  void _confirmDelete() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text(
        "Are you sure delete this note ?",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      actions: [
        RaisedButton(
          color: Colors.red,
          child: const Text("OK Delete"),
          onPressed: () {
            Navigator.pop(context);
            delete(mynote!);
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.yellow,
          child: const Text("Cancel"),
        )
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }

  @override
  void initState() {
    if (widget._myNote != null) {
      mynote = widget._myNote;
      cTitle.text = mynote!.title;
      cNote.text = mynote!.note;
      title = "My Note";
      _enabledTextField = false;
      createDate = mynote!.createDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._isNew) {
      title = "New Note";
      btnSave = true;
      btnEdit = false;
      btnDelete = false;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          title!,
          style: txtHeader,
        ),
        backgroundColor: Colors.yellow[600],
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            color: Colors.black,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CreateButton(
                  icon: Icons.save,
                  enable: btnSave,
                  onpress: _savedData,
                ),
                CreateButton(
                  icon: Icons.edit,
                  enable: btnEdit,
                  onpress: _editData,
                ),
                CreateButton(
                  icon: Icons.delete,
                  enable: btnDelete,
                  onpress: _confirmDelete,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                enabled: _enabledTextField,
                controller: cTitle,
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
                style: const TextStyle(
                  fontSize: 18,
                ),
                keyboardType: TextInputType.text,
                maxLines: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                enabled: _enabledTextField,
                controller: cNote,
                decoration: const InputDecoration(
                  hintText: "Write here your Note...",
                  // border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 18,
                ),
                maxLines: 8,
                minLines: 1,
                maxLength: 200,
                textInputAction: TextInputAction.newline,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class CreateButton extends StatelessWidget {
  final IconData icon;
  final bool enable;
  final VoidCallback onpress;

  const CreateButton(
      {Key? key,
      required this.icon,
      required this.enable,
      required this.onpress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enable ? Colors.yellow[600] : Colors.grey[300],
      ),
      child: IconButton(
        onPressed: () {
          if (enable) {
            onpress();
          }
        },
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 18,
      ),
    );
  }
}
