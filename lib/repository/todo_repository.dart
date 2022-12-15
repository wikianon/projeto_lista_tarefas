import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

//O SharedPreferences 
//só serve para armazenar poucos dados.

const todoListKey = 'todo_list';

class TodoRepository{

  late SharedPreferences sharedPreferences;
  
  //transformando o objeto do tipo json em um objeto do tipo TodoDataHora
 Future<List<Todo>> getTodoList() async {
   sharedPreferences = await SharedPreferences.getInstance();

   //caso receba uma lista vazia retorna a string ao final do metodo.
   final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
 
   final List jsonDecodificado = jsonDecode(jsonString) as List;

   //convertendo em um tipo de lista
   return jsonDecodificado.map((e) => Todo.fomJson(e)).toList();
 }

 //Salvando a lista de TodoDataHora no formato json
 void saveTodoList(List<Todo> todos){
  final String jsonString = jsonEncode(todos);
  
  sharedPreferences.setString('todo_list', jsonString);
 }
}