import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

//para formatar a Data e hora
//temos que adicionar o pacote intl:
//Entao iremos no arquivo pubspec.yaml
//e adicionaremos a dependencia logo
//abaixo de:
// dependencies:
//       cupertino_icons:
//       intl:
//Apos isso rodaremos o comando flutter pub get
//no terminal dentro do projeto após isso
//ele importará o package.

class TodoListItem extends StatelessWidget {
  const TodoListItem({super.key, required this.todoDate, required this.onDelete});

  final Todo todoDate;

  final void Function(Todo? model)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (model) {
                onDelete!(todoDate);
              },

              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            //Arredondando os cantos dos retangulos de fundo
            //de visualização das tarefas cadastradas.
            borderRadius: BorderRadius.circular(6),

            //por causa do widget decoration: o
            //widget color: nao pode existir fora do BoxDecoration.
            color: Colors.grey[200],
          ),

          //Para afastar os retangulos das tarefas
          //temos que definir dentro do Container o
          //widget margin: EdgeInsets.symetric(vertical: 3),
          //como queremos distanciar um retangulo
          //do outro em uma lista usaremos o
          //EdgeInsets.symetric(vertical: 3),
          //margin: const EdgeInsets.symmetric(vertical: 3),
          
          //Definindo um espaçamento ao redor de toda Column
          padding: const EdgeInsets.all(16),
          child: Column(
              //Ocupando a maior largura possivel.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  //acessando o DateTime da classe TodoDataHora e convertendo em String
                  //todoDate.dateTime.toString(),
                  //Depois de importar o intl iremos usar o DateFormat
                  //para formatar a data e hora ao nosso gosto.
                  DateFormat('dd/MMM/yyyy (EE) - HH:mm:ss')
                      .format(todoDate.dateTime),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  todoDate.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}