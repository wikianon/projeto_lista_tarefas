//Classe que irá gerar o titulo 
//data e horario das tarefa
class Todo{

Todo({required this.title, required this.dateTime});

String title;
DateTime dateTime;

factory Todo.fomJson(Map<String, dynamic> json)
{
 return Todo(title: json['title'], dateTime: DateTime.parse(json['datetime']));
}

//Todos.fomJson(Map<String, dynamic> json): title = json['title'], dateTime = DateTime.parse(json['datetime']);

//codifica em um objeto json
Map<String, dynamic> toJson(){
  return {
    'title': title,
    'datetime': dateTime.toIso8601String(),
  };
}

}