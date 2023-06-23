
import 'package:flutter/material.dart'; //padrao

//constantes
const IconData iconTodo1 = Icons.calendar_today_outlined;
const IconData iconTodo2 = Icons.check_circle_outline_outlined;
const IconData iconTodo3 = Icons.fmd_bad_outlined;
const nameDataFile = 'data';

//estrutura
class StructDel {
  Map<String, dynamic> itemMap = {};
  int index = -1;
}

//variaveis
List<dynamic> todoList = [];
List<dynamic> todoSel = [];
final StructDel todoDel = StructDel();