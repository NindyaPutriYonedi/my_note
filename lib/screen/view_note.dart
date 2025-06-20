import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_note/model/notes_model.dart';
import 'package:my_note/screen/add_edit.dart';
import 'package:my_note/service/database_helper.dart';

class ViewNote extends StatefulWidget {
  final Note note;

  const ViewNote({super.key, required this.note}); // ✅ Constructor benar

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  String _formatDateTime(String dateTime){
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note; // ✅ akses melalui widget

    return Scaffold(
      backgroundColor: Color(int.parse(note.color)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new,
        color: Colors.white,)),
        
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditNote(note: note,)));
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => _showDeleteDialog(context),
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),

        ],
      ),
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.title,
              style: TextStyle(fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  _formatDateTime(note.dateTime),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
            ],
          ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),

              ),
              child: SingleChildScrollView(
  physics: BouncingScrollPhysics(),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (note.imagePath != null && note.imagePath!.isNotEmpty)
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(note.imagePath!), 
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      SizedBox(height: 16),
      Text(
        note.content,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black.withOpacity(0.8),
          height: 1.6,
          letterSpacing: 0.2
        ),
      ),
    ],
  ),
),
            ))
        ],
      )),
    );
  }

    Future<void> _showDeleteDialog(BuildContext context) async{
      final confirm = await showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Delete Note",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Are you sure you want to delete this note?",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Calcel",
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            )),
            TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Delete",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ))
        ],
        ));

    if (confirm == true) {
      await _databaseHelper.deleteNote(widget.note.id!);
      Navigator.pop(context);
    }
    }
  }

