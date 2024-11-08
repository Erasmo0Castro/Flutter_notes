import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_notes_app/model/notes_model.dart';
import 'package:flutter_notes_app/screens/home_screen.dart';
import 'package:flutter_notes_app/services/database_helper.dart';

class AddEditNoteScreen extends StatefulWidget {
  //const AddEditNoteScreen({super.key, this.note});
  final Note? note;
  const AddEditNoteScreen({this.note});




  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper  _databaseHelper = DatabaseHelper();
  Color _selectedColor = Colors.amber;
  final List<Color> _colors = [
      Colors.amber,
      Color(0xFF50C878),
      Colors.redAccent,
      Colors.blueAccent,
      Colors.indigo,
      Colors.purpleAccent,
      Colors.pinkAccent,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.note != null){
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(widget.note == null ? 'Agregar nota': "Editar nota"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Titulo",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return "Por favor ingrese un titulo";
      
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: "Contenido",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 10,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return "Por favor ingrese el contenido";
      
                      }
                      return null;
                    },
                  ),
                  Padding(padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _colors.map(
                        (color) {
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedColor = color),
                        
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(right: 8),
                            decoration:BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == color 
                                ? Colors.black45 :
                                 Colors.transparent,
                                 width: 2, 
                              ),
                            ) ,
                          )
                        );
                      },
                      ).toList()
                      ),
                  ),
                  ),
                  InkWell(
                    onTap: (){
                      _saveNote();
                      Navigator.push(
                        context,
                       MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                        ));
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF50C878),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text(
                          "Salvar nota",
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          ),
                          ),  
                          ),
                    )
                  ),
                ],
            ),
            )
          ],
        ),
      ) ,
    );

  }
  Future<void> _saveNote() async{
    if(_formKey.currentState!.validate()){
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        color: _selectedColor.value.toString(),
        dateTime: DateTime.now().toString(),

      );
      if(widget.note == null){
        await _databaseHelper.insertNote(note);
      }else{
        await _databaseHelper.updateNote(note);
      }
    }
  }
}