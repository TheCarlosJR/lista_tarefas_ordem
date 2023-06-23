
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';        //datetime
import 'dart:convert';                  //conversoes json

import 'package:lista_tarefas_ordem_aula/data.dart';
import 'package:lista_tarefas_ordem_aula/events.dart';
import 'package:lista_tarefas_ordem_aula/globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final TextEditingController editTextCtrl1 = TextEditingController();


  //constroi componente linha drawer
  List<Widget> _buildDrawer(BuildContext context) {

    List<Widget> listaMenuItems = [];

    //constroi um componente divisor
    void buildDrawerDiv() {
      listaMenuItems.add(
          const Divider(height: 0)
      );
    }

    //constroi um componente tile
    void buildDrawerTile(String text, IconData icon, Function()? onTapEv)
    {
      listaMenuItems.add(
        ListTile(
          key: UniqueKey(),
          tileColor: Colors.blue.shade700,
          textColor: Colors.white,
          leading: Icon(
            icon,
            color: Colors.white,
          ),
          title: Text(text),
          onTap: () {
            Navigator.of(context).pop(); //fecha drawer
            if (onTapEv != null) {
              //atualiza pagina
              setState(() {
                //executa funcao
                onTapEv();
              });
            }
          },
        ),
      );
      //cria divisor também
      buildDrawerDiv();
    }

    //item padrao
    buildDrawerTile(
      "Fechar aba", Icons.menu_open, null,
    );
    //muda comportamento se houver items
    if (todoList.isNotEmpty) {
      //muda comportamento se houver selecao
      if (todoSel.isNotEmpty) {
        buildDrawerTile(
          "Deselecionar tudo", Icons.select_all, onTapMenuUnselAll,
        );
        buildDrawerTile(
          "Marcar selecionados", Icons.check_box_outlined, onTapMenuCheckSel,
        );
        buildDrawerTile(
          "Desmarcar selecionados", Icons.check_box_outline_blank_outlined,
          onTapMenuUncheckSel,
        );
        buildDrawerTile(
          "Limpar selecionados", Icons.delete_forever_outlined,
          onTapMenuClearSel,
        );
      }
      else {
        buildDrawerTile(
          "Selecionar tudo", Icons.select_all, onTapMenuSelAll,
        );
        buildDrawerTile(
          "Marcar tudo", Icons.playlist_add_check, onTapMenuCheckAll,
        );
        buildDrawerTile(
          "Desmarcar tudo", Icons.playlist_remove, onTapMenuUncheckAll,
        );
        buildDrawerTile(
          "Limpar tudo", Icons.delete_forever, onTapMenuClearAll,
        );
      }
    }
    //item padrao
    buildDrawerTile(
      "Sobre este App", Icons.question_mark, () {
        onTapMenuAbout(context);
      },
    );

    //retorna em lista
    return listaMenuItems;
  }


  //constroi componente linha com a tarefa
  Widget? _todoItemBuilder(BuildContext context, int index) {
    return Dismissible(
      key: UniqueKey(), //identificador unico
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment(-0.8, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (dir) {
        setState(() {
          onDismissTodo(context, dir, index);
        });
      },
      //conteudo
      child: ListTile(
        hoverColor: Colors.lightBlueAccent,
        tileColor: todoList[index]["sel"] ? Colors.lightBlue : null,
        onTap: () {
          setState(() {
            onTapTodo(index);
          });
        },
        onLongPress: () {
          setState(() {
            onLongTapTodoIcon(index);
          });
        },
        title: Row(
          children: [
            Expanded(
              child: Text(
                todoList[index]["title"],
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              DateFormat("dd/MM/yy\n HH:mm:ss")
                  .format(DateTime.parse(todoList[index]["date"])),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: InkWell(
          hoverColor: Colors.lightBlueAccent,
          splashColor: Colors.lightBlue,
          highlightColor: const Color(0x104E80FF),
          child: Ink(
            child: Icon(
              size: 32,
              todoList[index]["done"] ? iconTodo2 : iconTodo1
            ),
          ),
          onTap: () {
            setState(() {
              onTapTodoIcon(index);
            });
          },
          onLongPress: () {
            setState(() {
              onLongTapTodoIcon(index);
            });
          },
        ),
        /*
        trailing: IconButton(
          iconSize: 32,
          hoverColor: Colors.lightBlueAccent,
          splashColor: Colors.lightBlue,
          highlightColor: const Color(0x104E80FF),
          icon: Icon(todoList[index]["done"] ? iconTodo2 : iconTodo1),
          onPressed: () {
            setState(() {
              onTapTodoIcon(index);
            });
          },
        ),
        */
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData().then((String? val) {
      setState(() {
        todoList = json.decode(val ?? "[]") as List;
        setAllTodoSel(false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //detecta o botão voltar do android
      onWillPop: () async {
        if (todoSel.length == 1) {
          setAllTodoSel(false);
        }
        return false; //nao permite voltar a pagina
      },
      child: Scaffold(
        drawer: Container(
          width: 250,
          color: Colors.blue,
          child: ListView(
            children: _buildDrawer(context),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text("Ordenador de Tarefas"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: editTextCtrl1,
                        decoration: const InputDecoration(
                          labelText: "Tarefa",
                          labelStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          onTapAdd(editTextCtrl1);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        fixedSize: const Size.fromHeight(64),
                      ),
                      child: const Icon(
                        Icons.add_box_rounded,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: todoList.length,
                    itemBuilder: _todoItemBuilder,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
