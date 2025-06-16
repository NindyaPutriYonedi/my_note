import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_note/model/notes_model.dart';
import 'package:my_note/screen/home_screen.dart';
import 'package:my_note/service/database_helper.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class AddEditNote extends StatefulWidget {
  final Note? note;
  const AddEditNote({this.note, Key? key}) : super(key: key);

  @override
  State<AddEditNote> createState() => _AddEditNoteState();
}

class _AddEditNoteState extends State<AddEditNote> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final FocusNode _contentFocusNode = FocusNode();

  Color _selectedColor = Colors.amber;

  final List<Color> _colors = [
    Colors.red,
    Colors.teal,
    Colors.yellow,
    Colors.lightGreen,
    Colors.blueGrey,
    Colors.pinkAccent,
  ];
  

  XFile? _imageFile; // untuk menyimpan gambar yang dipilih
  final ImagePicker _picker = ImagePicker();
  final FocusNode _keyboardFocusNode = FocusNode(); // Untuk RawKeyboardListener


  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
      if (widget.note!.imagePath != null) {
        _imageFile = XFile(widget.note!.imagePath!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _keyboardFocusNode.dispose();
_contentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.note != null ? 'Edit Note' : 'Add Note',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a title";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            RawKeyboardListener(
  focusNode: _keyboardFocusNode, // Gunakan yang berbeda dari TextFormField
  onKey: (event) {
    if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
        event.runtimeType.toString() == 'RawKeyDownEvent') {
      final text = _contentController.text;
      final selection = _contentController.selection;

      final lines = text.substring(0, selection.start).split('\n');
      final currentLine = lines.isNotEmpty ? lines.last : '';

      if (currentLine.startsWith('• ')) {
        final newText = text.replaceRange(
          selection.start,
          selection.end,
          '\n• ',
        );
        _contentController.text = newText;
        _contentController.selection = TextSelection.collapsed(
          offset: selection.start + 3,
        );
      } else {
        final newText = text.replaceRange(
          selection.start,
          selection.end,
          '\n',
        );
        _contentController.text = newText;
        _contentController.selection = TextSelection.collapsed(
          offset: selection.start + 1,
        );
      }
    }
  },
  child: TextFormField(
    controller: _contentController,
    focusNode: _contentFocusNode, // Ini harus beda dari RawKeyboardListener
    decoration: InputDecoration(
      hintText: "Content",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    minLines: 6,
    maxLines: null,
    keyboardType: TextInputType.multiline,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Please enter content";
      }
      return null;
    },
  ),
),


            const SizedBox(height: 16),

            // tombol icon kamera untuk upload gambar
            Row(
  children: [
    IconButton(
      icon: const Icon(Icons.camera_alt),
      color: Colors.green,
      iconSize: 30,
      onPressed: () => _pickImage(),
    ),
    IconButton(
      icon: const Icon(Icons.format_list_bulleted),
      color: Colors.blueGrey,
      iconSize: 30,
      onPressed: () {
        final text = _contentController.text;
        final selection = _contentController.selection;
        final newText = text.replaceRange(
          selection.start,
          selection.end,
          '• ',
        );

        setState(() {
          _contentController.text = newText;
          _contentController.selection = TextSelection.collapsed(
              offset: selection.start + 2); // Move cursor after bullet
        });
      },
    ),
  ],
),


            // preview gambar jika ada
            if (_imageFile != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(
                    image: FileImage(File(_imageFile!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 20),
            const Text(
              "Choose Note Color:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _colors.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color
                              ? Colors.black45
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF50C878),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _saveNote();
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
              },
              child: const Text(
                "Save Note",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    final note = Note(
      id: widget.note?.id,
      title: _titleController.text,
      content: _contentController.text,
      color: _selectedColor.value.toString(),
      dateTime: DateTime.now().toString(),
      imagePath: _imageFile?.path,
    );

    if (widget.note == null) {
      await _databaseHelper.insertNote(note);
    } else {
      await _databaseHelper.updateNote(note);
    }
  }
}
