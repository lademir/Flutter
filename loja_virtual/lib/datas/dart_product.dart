
//CLASSE QUE VAI ARMAZENAR OS PRODUTOS DO CARRINHO
//O AS INFORMACOES DETALHADAS DO PRODUTO VAO SENDO CARREGADAS CONFORME
//E APERTADO PARA ABRIR O CARRINHO, PARA FICAR COM OS DADOS ATUALIZADOS

//VAI ARMAZENAR DADOS QUE NAO VAO MUDAR
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {
  //ID DO PRODUTO
  String cid;

  //CATEGORIA DO PRODUTOR
  String category;
  //O ID DO PRODUTO
  String pid;

  //quantidade que ele vai comprar
  int quantity;
  String size;

  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot doc){
    cid = doc.documentID;
    category = doc.data["category"];
    pid = doc.data["pid"];
    quantity = doc.data["quantity"];
    size = doc.data["size"];
  }
  //COMO ARMAZENAMOS TEMPORARIAMENTE O PRODUTO NO CARRINHO, AGORA PRECISAMOS
  //COLOCA-LO NO BANCO DE DADOS
  //PARA ISSO, PRECISAMOS DE UM MAPA
  Map<String, dynamic> toMap(){
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      //UM RESUMO DO PRODUTO NO CARRINHO
      //"product": productData.toResumedMap(),

    };
  }

}