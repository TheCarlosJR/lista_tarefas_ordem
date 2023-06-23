
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lista_tarefas_ordem_aula/globals.dart';
import 'package:lista_tarefas_ordem_aula/data.dart';

import 'package:lista_tarefas_ordem_aula/alertDialog_widget.dart';

//evento toque menu - seleciona tudo
void onTapMenuSelAll() {
  setAllTodoSel(true);
}

//evento toque menu - deseleciona tudo
void onTapMenuUnselAll() {
  setAllTodoSel(false);
}

//evento toque menu - marca pronto selecao
void onTapMenuCheckSel() {
  changeDoneTodoSel(true);
}

//evento toque menu - desmarca pronto selecao
void onTapMenuUncheckSel() {
  changeDoneTodoSel(false);
}

//evento toque menu - limpa selecao
void onTapMenuClearSel() {
  delAllTodoSel();
}

//evento toque menu - marca pronto tudo
void onTapMenuCheckAll() {
  changeDoneAllTodo(true);
}

//evento toque menu - desmarca pronto tudo
void onTapMenuUncheckAll() {
  changeDoneAllTodo(false);
}

//evento toque menu - apaga tudo
void onTapMenuClearAll() {
  clearTodoList();
}

//evento toque menu - sobre
void onTapMenuAbout(BuildContext context) {
  showAlertDialog(
      context,
      "Aplicativo de tarefas",
      "Criado em 18/05/23\n" +
      "Obrigado pela preferência\n\n" +
      "- Carlos Alberto Stevaux Junior\n",
  );
}

//evento toque botao add
void onTapAdd(TextEditingController textCtrl) {
  addTodoListItem(textCtrl.text);

  //limpa texto do textfield
  textCtrl.text = "";

  //retira teclado retirando foco do textfield
  FocusManager.instance.primaryFocus?.unfocus();
}

//evento toque linha tarefa
void onTapTodo(int index) {
  //verifica se esta selecionando items
  if (todoSel.length == 1) {
    changeTodoSel(index);
  }
}

//evento toque icone tarefa
void onTapTodoIcon(int index) {
  //comuta estado
  todoList[index]["done"] = !todoList[index]["done"];

  //ordena lista
  todoList.sort(sortListTodo);

  //salva dados
  saveData();
}

//evento toque icone tarefa
void onLongTapTodoIcon(int index) {
  //verifica se nao esta selecionando items ainda
  if (todoSel.length != 1) {
    changeTodoSel(index);
  }
  else {
    setAllTodoSel(false);
  }
  HapticFeedback.heavyImpact(); //vibra celular android ios
}

//evento ao desfazer exclusao
void onDismissTodoUndo() {
  //volta na posicao que tava
  todoList.insert(todoDel.index, todoDel.itemMap);

  //ordena lista
  todoList.sort(sortListTodo);

  //salva dados
  saveData();

  //limpa backup
  todoDel.itemMap = {};
  todoDel.index = -1;
}

//evento ao arrastar para o lado
void onDismissTodo(BuildContext context, DismissDirection dir, int index) {
  //backup dos dados
  todoDel.itemMap = Map.from(todoList[index]);
  todoDel.index = index;

  //retira da lista
  todoList.removeAt(index);

  //salva dados
  saveData();

  //widget de mensagem
  final snackDel = SnackBar(
    duration: const Duration(seconds: 5),
    content: Text(
        "${todoDel.itemMap["title"]} foi removido"
    ),
    action: const SnackBarAction(
      label: "Desfazer",
      onPressed: onDismissTodoUndo,
    ),
  );

  //retira mensagens atuais quando houverem
  ScaffoldMessenger.of(context).clearSnackBars();

  //mostra nova mensagem
  ScaffoldMessenger.of(context).showSnackBar(snackDel);
}

//mostra dialogo
void showAlertDialog(BuildContext context, String title, String msg) {

  const bool blurbg = true;

  if (blurbg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlurryDialog(
          title: title,
          message: msg,
          btnLabel1: "Aceitar",
        );
      },
    );
  }

  else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            TextButton(
              child: const Text("Aceitar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}