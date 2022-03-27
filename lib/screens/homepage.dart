// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../models/listnote.dart';
import '../server/db_helper.dart';
import '../theme.dart';
import '../widgets/note_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var db = DBHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.yellow[600],
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => const NotePage(null, true),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: Container(
          padding: const EdgeInsets.all(7),
          child: Image.asset("assets/images/logo.png"),
        ),
        title: Text(
          'Simple Notepad',
          style: txtHeader,
        ),
        backgroundColor: Colors.yellow[600],
      ),
      body: FutureBuilder(
        future: db.getNote(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          var data = snapshot.data;

          return snapshot.hasData
              ? NoteList(data as dynamic)
              : const Center(
                  child: Text("No Data"),
                );
        },
      ),
    );
  }
}
