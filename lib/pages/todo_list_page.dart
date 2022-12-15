import 'package:flutter/material.dart';
import 'package:projeto_lista_tarefas/repository/todo_repository.dart';
import '../models/todo.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  final TodoRepository todoRepository = TodoRepository();

  //Para gerar uma lista de tarefas com
  //as datas e horas cadastradas não podemos mais utilizar String
  //vamos tilizar a nossa classe modelo TodoDataHora
  List<Todo> todos = [];

  Todo? deleteTodo;
  int? deletedTodoPos;

  //Como a classe _TodoListPageState é privada por causa do underline
  //temos que criar o método initState e usar como construtor.
  //O initstate é um método chamado sempre na criação do Widget
  @override
  void initState() {
    super.initState();

    //para a tela ser atualizada.
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  void onDelete(Todo deletado) {
    //salvando a tarefa antes de deletar
    deleteTodo = deletado;

    //buscando a posição da tarefa para devolver
    //ela no mesmo lugar ao desfazer a deleçao.
    deletedTodoPos = todos.indexOf(deletado);

    //Apagando removendo o
    //snackBar atual ao desfazer a deleção
    ScaffoldMessenger.of(context).clearSnackBars();

    setState(() {
      //chamando o objeto da lista para deletar todos.
      todos.remove(deletado);
    });

    //Para salvar a lista atualizada devemos chamar o método
    //abaixo para que caso a tarefa seja deletada ela nao volte
    //ao reiniciar o app.
    todoRepository.saveTodoList(todos);

    //Desfazendo a deleção de uma tarefa.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa: ${deletado.title} foi removida com sucesso!',
          style:
              const TextStyle(color: Colors.red, backgroundColor: Colors.white),
        ),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              //inserindo em uma posição especifica
              //para desfazer a deleção da tarefa.
              todos.insert(deletedTodoPos!, deleteTodo!);
            });

            //Para salvar a lista atualizada devemos chamar o método
            //abaixo para que caso a tarefa seja deletada ela nao volte
            //ao reiniciar o app.
            todoRepository.saveTodoList(todos);
          },
          textColor: const Color(0xff00d7f3),
        ),

        //Definindo a duração da mensagen SnackBar
        duration: const Duration(seconds: 5),
      ),
    );
  } //onDelete

  //Deleta todos os usuarios.
  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    //Para salvar a lista atualizada devemos chamar o método
    //abaixo para que caso a tarefa seja deletada ela nao volte
    //ao reiniciar o app.
    todoRepository.saveTodoList(todos);
  }

  void showDeleteTodosConfirmDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Limpar Tudo?'),
              content: const Text('Tem certeza que quer apagar tudo?'),
              actions: [
                //Botão cancelar.
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0xff00d7f3)),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                //Botão Limpar tudo
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAllTodos();
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    'Limpar Tudo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    //Para a caixa de texto nao ficar debaixo da
    //barra de status do celular devemos
    //utilizar o widget SafeArea
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            //Para nao continuar enconstando nem encima e
            //nem embaixo da tela temos que usar o EdgeInsets.all(16)
            //ao invés do EdgeInsets.symetric(horizontal: 16).
            padding: const EdgeInsets.all(16),

            //Como os Widgets estarão organizados um abaixo do outro devemos
            //Utilizar um Column criando uma coluna de Widgets
            child: Column(
              //Como a Column pega toda a largura maxima da tela
              //devemos reduzir isso alinhando o eixo para MainAxisSize.min
              mainAxisSize: MainAxisSize.min,
              children: [
                //Para o Widget TextField Ficar lado a lado com o ElevatedButton
                //devemos utilizar uma Row => Linha
                Row(
                  children: [
                    //O widget Expanded faz com que o TextField
                    //pegue a largura maxima da tela.
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          //Ao clicar na caixa de texto
                          //labelText joga esta frase abaixo
                          //na borda da caixa e mostra o hintText
                          //como exemplo de entrada.
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex: Estudar Flutte',
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    ElevatedButton(
                      onPressed: () {
                        //pegando o input do usuario.
                        String text = todoController.text;

                        //Para não adicionar uma tarefa vazia.
                        if(text.isEmpty){
                          return;
                        }

                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          //Adiconando itens na lista.
                          todos.add(newTodo);
                        });

                        //Limpando o texto digitado
                        //após adicionar tarefa
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00d7f3),
                          padding: const EdgeInsets.all(14)),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),

                //Espaçamento entre o Widget Row
                //com o ListView abaixo.
                const SizedBox(
                  height: 16,
                ),

                //O widget Flexible faz com que a lista ocupe
                //o maximo da tela sem dar overflow
                Flexible(
                  //O Widget ListViwe Tem uma altura infinita
                  //para resolvermos isto devemos usar o shrinkWrap
                  child: ListView(
                    //o shrinkWrap deixa a lista mais enxuta
                    //fazendo com que
                    shrinkWrap: true,
                    //Colocando varios filhos na lista
                    children: [
                      //Adicionando items na lista com um for
                      for (Todo todo in todos)
                        TodoListItem(
                          todoDate: todo,
                          onDelete: (model) {
                            onDelete(todo);
                          },
                        ),
                    ],
                  ),
                ),

                //Espaçamento entre o Widget Row
                //com o ListView abaixo.
                const SizedBox(
                  height: 16,
                ),

                //Row 2 Bottao Limpar tudo.
                Row(
                  children: [
                    //Para o Text nao ultrapassar o limite da tela
                    //Usaremos o Expanded pegando a maxima largura.
                    Expanded(
                      child: Text(
                        'Voçê possui ${todos.length} tarefas pendentes!!!',
                      ),
                    ),

                    //SizedBox(
                    //width: 8,
                    //),

                    ElevatedButton(
                      onPressed: showDeleteTodosConfirmDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Text('Limpar tudo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
