import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/dart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class CartModel extends Model{

  UserModel user;
  List<CartProduct> products = [];

  bool isLoading = false;

  //ASSIM O CART_MODEL VAI TER ACESSO AO USUARIO ATUAL
  CartModel(this.user);

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);
//ADICIONANDO AO BANCO DE DADOS
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("cart").add(cartProduct.toMap()).then((doc){
        cartProduct.cid = doc.documentID; //COLOCANDO O ID QUE O FIREBASE DEU
    });
    notifyListeners(); //PARA ATUALIZAR A TELA
  }

  void removeCartItem(CartProduct cartProduct){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cartProduct.cid).delete();
    products.remove(cartProduct);

    notifyListeners();
  }

}