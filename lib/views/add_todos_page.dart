// ignore_for_file: unused_field, prefer_final_fields
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_flutter_todo_list_app/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTodosPage extends StatefulWidget {
  const AddTodosPage({super.key});

  @override
  State<AddTodosPage> createState() => _AddTodosPageState();
}

class _AddTodosPageState extends State<AddTodosPage> {

  final TextEditingController _titleController=TextEditingController();
  final TextEditingController _descriptionController=TextEditingController();


  List<Todo>_todos=[];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void>_loadTodos()async{
    final prefs=await SharedPreferences.getInstance();
    final String? todosString=prefs.getString('todos');
    if(todosString != null){
      final List<dynamic> todosJson=jsonDecode(todosString);
      setState(() {
        _todos=todosJson.map((json)=>Todo.fromJson(json)).toList();
      });
    }
  }

  Future<void>_saveTodos()async{
    final prefs=await SharedPreferences.getInstance();
    final String todosString=jsonEncode(_todos.map((todo)=>todo.toJson()).toList());
    await prefs.setString('todos', todosString);
  }

  //add todo  
  void _addTodo(){
    if(_titleController.text.isNotEmpty || _descriptionController.text.isNotEmpty){
      setState(() {
        _todos.add(Todo(
          id: DateTime.now().toString(), 
          title: _titleController.text.isNotEmpty?_titleController.text : "untitled",
          description: _descriptionController.text.isNotEmpty?_descriptionController.text : "untitled ${DateTime.now().toString()}",
          ));
      });
      _saveTodos();
      _titleController.clear();
      _descriptionController.clear();
      Navigator.pop(context);
    }
  }

  //Update Todo completion status
  void _toggleTodo(int index){
    setState(() {
      _todos[index].isCompleted=!_todos[index].isCompleted;
    });
    _saveTodos();
  }

  //Edit Todo title and Description
  void _editTodo(int index,String newTitle,String newDescription){
    if(newTitle.isNotEmpty && newDescription.isNotEmpty){
      setState(() {
        _todos[index].title=newTitle;
        _todos[index].description=newDescription;
      });
      _saveTodos();
    }
  }

  //delete Todo
  void _deleteTodo(int index){
    setState(() {
      _todos.removeAt(index);
    });
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          elevation: 5.0,
          shadowColor: Colors.lightGreenAccent,
          title: Center(child: Text(
            'Deleted',
            style: TextStyle(
              color: Colors.black
            ),
            
            )),
          actions: [
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                ),
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.lime,
                    fontSize: 22.0
                  ),
                  )
                ),
            ),
          ],
        );
      },
      );
    _saveTodos();
  }

  
  void addDialog(){
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          elevation: 5.0,
          shadowColor: Colors.lightGreenAccent,
          title: Center(child: Text(
            'Add Todo',
            style: TextStyle(
              color: Colors.lightGreen
            ),
            )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(
                color: Colors.lightGreen
                ),
                controller: _titleController,
                decoration: 
                InputDecoration(
                  label: Text('Title',
                  style: TextStyle(
                    color: Colors.lightGreen
                  ),
                  ),
                  enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.lime),
                   ),

                   focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.lime),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )),
              ),
              SizedBox(height: 15.0),

              TextField(
                style: TextStyle(
                color: Colors.lightGreen
                ),
                controller: _descriptionController,
                decoration: 
                InputDecoration(
                  hoverColor: Colors.lightGreenAccent,
                  label: Text(
                    'Description',
                    style: TextStyle(
                    color: Colors.lightGreen
                  ),
                    ),
                  enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.lime),
                   ),

                   focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.lime),
                  ),
                  border: 
                  OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )),
              ),

            ],
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.lightGreenAccent
                ),
                ),
              ),

              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.lightGreen
                ),
                onPressed: (){
                  _addTodo();
                }, 
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                ),
          ],
        );
      },
      );
  }

  //show dialog to edit todo
  void _editTodoDialog(int index){
    final TextEditingController editTitleController=TextEditingController(text: _todos[index].title);
    final TextEditingController editDescriptionController=TextEditingController(text: _todos[index].description);

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          elevation: 5.0,
          shadowColor: Colors.lightGreenAccent,
          title: Center(child: Text(
            'Edit Todo',
            style: TextStyle(
              color: Colors.lightGreen
            ),
            )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editTitleController,
                style: TextStyle(
                  color: Colors.lightGreen
                ),
                decoration: 
                InputDecoration(
                  label: Text('Title',
                  style: TextStyle(
                    color: Colors.lightGreen
                  ),
                  ),
                  enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.lime),
                   ),

                   focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.lime),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )),
              ),
              SizedBox(height: 15.0),

              TextField(
                controller: editDescriptionController,
                style: TextStyle(
                color: Colors.lightGreen
                ),
                decoration: 
                InputDecoration(
                  hoverColor: Colors.lightGreenAccent,
                  label: Text(
                    'Description',
                    style: TextStyle(
                    color: Colors.lightGreen
                  ),
                    ),
                  enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.lime),
                   ),

                   focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.lime),
                  ),
                  border: 
                  OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )),
              ),

            ],
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.lightGreenAccent
                ),
                ),
              ),

              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.lightGreen
                ),
                onPressed: (){
                  _editTodo(
                    index, editTitleController.text, editDescriptionController.text
                    );
                    Navigator.pop(context);
                }, 
                child: Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                ),
          ],
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Todo App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
          ),
          ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(onPressed: (){
            _loadTodos();
          }, icon: Icon(Icons.refresh),
          ),
        ],
      ),

      body:_todos.isEmpty ? 
        Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Press + to add.',
                style: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 5.0
                ),
                ),
                SizedBox(height: 15.0,),
                Text(
                'No Todos.',
                style: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 5.0
                ),
                ),
              SizedBox(height: 15.0,),
              Icon(Icons.add_task)
            ],
          ),
        ),
      )
      :
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            final todo=_todos[index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.isCompleted, 
                      onChanged:(value) => _toggleTodo(index),
                      ),
                    
                    title:Text(
                      todo.title,
                      style: TextStyle(
                        color: todo.isCompleted?Colors.lime:Colors.white,
                        decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                      ),
                      
                      ),
                        
                    subtitle:Text(todo.description),
                        
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){
                          _editTodoDialog(index);
                        }, icon: Icon(
                          Icons.edit,
                          color: Colors.lightGreenAccent,
                          size: 22.0,
                        ),),
                        
                        SizedBox(width: 15.0,),
                        
                        IconButton(onPressed: (){
                          _deleteTodo(index);
                        }, 
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                          size: 22.0,
                        ),),
                        
                        SizedBox(width: 15.0,),
                        
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.red
                              ),
                              todo.isCompleted?
                            "Completed"
                            :""
                            ),
                          )
                          ),
                        
                      ],
                    ),
                  ),
                        
                ),
              ),
            );
            
          },
          ),
      ),

      drawer: Drawer(
        backgroundColor: Colors.lightGreenAccent,
        elevation: 10.0,
        width: 250.0,
        shadowColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: 
              BoxDecoration(image: DecorationImage(
                fit: BoxFit.scaleDown,
                image: AssetImage(
                  'assets/images/chat.png',
                  ))),
              child: Text(""),
              ),
              SizedBox(height: 20.0,),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  addDialog();
                  
                },
                title: Text('Add Todo'),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                ),
                leading: Icon(Icons.add_task,
                color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0,),
              ListTile(
                onTap: () {
                  
                },
                title: Text('Edit Todo'),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                ),
                leading: Icon(Icons.edit_attributes,
                color: Colors.black,
                ),
              ),
              SizedBox(height: 50.0,), 
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                  ),
                  ),
                ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 10,
        hoverColor: Colors.lime,
        backgroundColor: Colors.lightGreenAccent,
        splashColor: Colors.white,
        foregroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: (){
          addDialog();
        }
        ),

    );
    
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

