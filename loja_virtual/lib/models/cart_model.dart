import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/dart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class CartModel extends Model{

  UserModel user;
  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  //ASSIM O CART_MODEL VAI TER ACESSO AO USUARIO ATUAL
  CartModel(this.user){
    if(user.isLoggedIn()){
      _loadCartItems();
    }
  }

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
  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
      .document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupon(String couponCode, int percent){
    this.couponCode = couponCode;
    this.discountPercentage = percent;
  }

  void updatePrices(){
    notifyListeners();
  }

  //SUBTOTAL
  double getProductPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null)
        price += c.quantity * c.productData.price;
    }
    return price;
  }
  //VALOR DESCONTO
  double getDiscount(){
    return getProductPrice() * discountPercentage/100;
  }
  //VALOR DA ENTREGA
  double getShipPrice(){
    return 10.00;
  }
  //FINALIZAR PEDIDO
  Future<String> finishOrder() async{
    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    //PARA QUE TENHA UMA REFERENCIA DO PEDIDO
    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
      {
        "clientId": user.firebaseUser.uid,
        "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
        "shipPrice": shipPrice,
        "productsPrice": productsPrice,
        "dicount":discount,
        "totalPrice":productsPrice - discount + shipPrice,
        "status": 1,
      }
    );
    //SALVAR O ID DO PEDIDO NO USER
    await Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("orders").document(refOrder.documentID).setData(
      {
        "orderID": refOrder.documentID,
      }
    );

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("cart").getDocuments();

    //DELETAR OS PRODUTOS DO CARRINHO DEPOIS DE FINALIZAR O PEDIDO
    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

  void _loadCartItems() async{

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .getDocuments();

    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();

  }

}