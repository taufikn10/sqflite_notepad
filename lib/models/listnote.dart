import 'package:flutter/material.dart';
import 'package:sqflite_notepad/models/mynote.dart';
import 'package:sqflite_notepad/widgets/note_page.dart';

class NoteList extends StatefulWidget {
  final List<Mynote> notedata;
  const NoteList(this.notedata, {Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 2
                  : 3),
      itemCount: widget.notedata.length,
      itemBuilder: (BuildContext contex, int i) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext contex) =>
                    NotePage(widget.notedata[i], false),
              ),
            );
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.notedata[i].title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.notedata[i].note,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text("Created : ${widget.notedata[i].createDate}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text("Updated : ${widget.notedata[i].updateDate}"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
