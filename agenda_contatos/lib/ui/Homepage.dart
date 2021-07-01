
import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOption {orderaz, orderza}


class Homepage extends StatefulWidget {


  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

//pra quando iniciar o app, mostrar a lista que esta no banco de dados
  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOption> (
              itemBuilder: (context) => <PopupMenuEntry<OrderOption>>[
                const PopupMenuItem<OrderOption>(
                    child: Text("Ordenar de A-Z"),
                    value: OrderOption.orderaz,
                    ),
                const PopupMenuItem<OrderOption>(
                  child: Text("Ordenar de Z-A"),
                  value: OrderOption.orderza,
                )
              ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index){
            return _contactCard(context, index);
          }
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null ?
                      FileImage(File(contacts[index].img)) :
                      AssetImage("images/person.png"),
                      fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contacts[index].name ?? "",
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(contacts[index].phone ?? "",
                        style: TextStyle(fontSize: 22.0))
                  ],
                ),)
            ],
          ),
        ),
      ),
      onTap: () {
        _showOption(context, index);
      },
    );
  }
    void _showOption (BuildContext context, int index){
      showModalBottomSheet(
          context: context,
          builder: (context){
            return BottomSheet(
                onClosing: (){},
                builder: (context){
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextButton(
                              onPressed: () { //para ligar
                                launch("tel:${contacts[index].phone}");
                                Navigator.pop(context);
                              },
                              child: Text("Ligar",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                              ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextButton(
                              onPressed: () { //para editar
                                Navigator.pop(context);
                                _showContactPage(contact: contacts[index]);
                              },
                              child: Text("Editar",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                ),)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextButton(
                              onPressed: () { //para deletar
                                helper.deleteContact(contacts[index].id);
                                setState(() {
                                  contacts.removeAt(index);
                                  Navigator.pop(context);
                                });
                              },
                              child: Text("Excluir",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                ),)
                          ),
                        )
                      ],
                    ),
                  );
                }
            );
          }
      );
    }

  //o navigator retorna os dados da ContactPage
  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ContactPage(contact: contact))
    );
    if(recContact != null) {
      if(contact != null){
        await helper.updatoContact(recContact);
      }
      else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }
  void _getAllContacts() {
    helper.getAllContact().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
  void _orderList(OrderOption result) {
    switch(result){
      case OrderOption.orderaz:
        contacts.sort((a, b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOption.orderza:
        contacts.sort((a, b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

}

