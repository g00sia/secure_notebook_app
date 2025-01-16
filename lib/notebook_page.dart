import 'package:flutter/material.dart';
import 'package:notatnik/start_page.dart';
import 'encryption.dart';
import 'package:animate_do/animate_do.dart';
import 'package:notatnik/wavy_header.dart';

class NotebookPage extends StatefulWidget {
  const NotebookPage({super.key});

  @override
  State<NotebookPage> createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  var activeScreen = 'notebook';

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  void switchScreenToStart() {
    setState(() {
      activeScreen = 'start';
    });
  }

  void _saveNote() async {
    final String title = _titleController.text;
    final String note = _noteController.text;

    if (title.isEmpty || note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Title or note cannot be empty')));
      return;
    }

    final encryptionHelper = EncryptionHelper();
    await encryptionHelper.saveNoteSecurely(note, title);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Note saved successfully')));
  }

  void _loadNote() async {
    final encryptionHelper = EncryptionHelper();
    final Map<String, String?> decryptedData =
        await encryptionHelper.loadNoteSecurely();
    if (decryptedData['note'] != null && decryptedData['title'] != null) {
      setState(() {
        _noteController.text = decryptedData['note']!;
        _titleController.text = decryptedData['title']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (activeScreen == 'start') {
      return const StartPage();
    }
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text(
        //     'Notebook Page',
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   backgroundColor: Colors.white,
        //   iconTheme: const IconThemeData(
        //     color: Colors.black,
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.home),
        //       onPressed: switchScreenToStart,
        //     ),
        //   ],
        // ),
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        WavyHeaderWithClippers(text: "", height: 50),
        Container(
            padding: const EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 200, 200, 200),
                    ),
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromRGBO(174, 108, 170, .2)),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  child: TextField(
                    controller: _noteController,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Type note here...",
                      hintStyle: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 219, 126, 212),
                      ),
                      border: InputBorder.none,
                    ),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(colors: [
                            Color.fromRGBO(174, 108, 170, 1),
                            Color.fromRGBO(143, 148, 251, .6),
                          ])),
                      child: Center(
                          child: TextButton(
                        onPressed: _saveNote,
                        child: const Text(
                          'Save Note',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                    )),
                FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: IconButton(
                        icon: const Icon(Icons.home),
                        color: const Color.fromRGBO(143, 148, 251, 1),
                        onPressed: switchScreenToStart))
              ],
            )),
      ],
    )));
  }
}
