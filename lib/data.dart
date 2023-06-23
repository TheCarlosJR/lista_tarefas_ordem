
import 'dart:convert';                             //conversoes json
import 'dart:io';                                  //arquivos
import 'package:path_provider/path_provider.dart'; //pasta padrao dispositivos

import 'package:lista_tarefas_ordem_aula/globals.dart';

//obtem objeto arquivo
Future<File> getFile() async {
  //obtem caminho de uma pasta segura
  final dirData = await getApplicationDocumentsDirectory();

  return File("${dirData.path}/$nameDataFile.json");
}

//salva dados
Future<File> saveData() async {
  String dataS = json.encode(todoList);
  final fileT = await getFile();
  return fileT.writeAsString(dataS);
}

//carrega dados
Future<String?> loadData() async {
  try {
    final fileT = await getFile();
    final fileTStr = fileT.readAsString();
    return fileTStr;
  } catch (e) {
    return null;
  }
}

//adiciona item na lista
void addTodoListItem(String text) {
  Map<String, dynamic> newTodo = Map();

  if (text.isEmpty) {
    text = "Tarefa sem nome";
  }

  newTodo["title"] = text;
  newTodo["done"] = false;
  newTodo["date"] = DateTime.now().toIso8601String();
  newTodo["sel"]  = false;

  //coloca novo item na lista
  todoList.add(newTodo);

  //ordena lista
  todoList.sort(sortListTodo);

  //salva dados
  saveData();
}

//limpa lista inteira
void clearTodoList() {
  //protecao
  if (todoList.isEmpty) {
    return;
  }

  //limpa lista
  todoList.clear();

  //salva dados
  saveData();
}

//limpa lista inteira
void delAllTodoSel() {
  //protecao
  if (todoList.isEmpty) {
    return;
  }

  //limpa listas
  for (int i=0; i < todoSel.length; i++) {
    if (!todoList.contains(todoSel[i])) {
      continue;
    }
    todoList.remove(todoSel[i]);
  }
  todoSel.clear();

  //salva dados
  saveData();
}

//altera selecao de todos os item
void setAllTodoSel(bool stateSel) {
  //protecao
  if (todoList.isEmpty) {
    return;
  }

  for (int i=0; i < todoList.length; i++) {
    todoList[i]["sel"] = stateSel;
    if (stateSel) {
      todoSel.add(todoList[i]);
    }
  }
  if (!stateSel) {
    todoSel.clear();
  }
}

//altera selecao de um item
void changeTodoSel(int index) {
  if (todoSel.contains(todoList[index])) {
    todoSel.remove(todoList[index]);
    todoList[index]["sel"] = false;
  }
  else {
    todoSel.add(todoList[index]);
    todoList[index]["sel"] = true;
  }
}

//altera estado de terminado em todos os items
void changeDoneAllTodo(bool stateDone) {
  //protecao
  if (todoList.isEmpty) {
    return;
  }

  //altera estado de todos
  for (int i=0; i < todoList.length; i++) {
    todoList[i]["done"] = stateDone;
  }

  //ordena lista
  todoList.sort(sortListTodo);

  //salva dados
  saveData();
}

//altera estado de terminado em todos os items selecionados
void changeDoneTodoSel(bool stateDone) {
  //protecao
  if (todoSel.isEmpty) {
    return;
  }

  //altera estado de todos
  for (int i=0; i < todoSel.length; i++) {
    todoSel[i]["done"] = stateDone;
  }

  //ordena lista
  todoList.sort(sortListTodo);

  //salva dados
  saveData();
}

//ordena lista de dados
//a > b = +
//a = b = 0
//a < b = -
int sortListTodo(a, b) {
  int c = 0;

  //1) comeca comparando pelo boolean
  if ((a["done"] == true) && (b["done"] == false)) {
    return 1;
  }
  else
  if ((a["done"] == false) && (b["done"] == true)) {
    return -1;
  }

  //2) compara pelo argumento data
  else {
    c = a["date"].compareTo(b["date"]);
    if (c != 0) {
      return c * (-1);
    }

    //3) compara pelo argumento nome
    else {
      c = a["title"].compareTo(b["title"]);
      return c;
    }
  }
}