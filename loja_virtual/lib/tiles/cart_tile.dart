import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/dart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent() {
      CartModel.of(context).updatePrices();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProduct.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        cartProduct.productData.title, //NOME DO CART_PRODUCT
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                    ),
                    Text(
                      "Tamanho: ${cartProduct.size}", //TAMANHO DO PRODUTO ESCOLHIDO
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "R\$ ${cartProduct.productData.price.toStringAsFixed(2)}", //O PRECO DO PRODUTO ATUAL
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          //REMOVER EM UM A QUANTIDADE DO PRODUTO
                            icon: Icon(Icons.remove),
                            color: Theme.of(context).primaryColor,
                            onPressed: cartProduct.quantity > 1 ?
                            (){
                              CartModel.of(context).decProduct(cartProduct);
                            } : null,
                        ),
                        Text(cartProduct.quantity.toString()),
                        //AUMENTAR EM UM A QUANTIDADE DO PRODUTO
                        IconButton(
                          icon: Icon(Icons.add),
                          color: Theme.of(context).primaryColor,
                          onPressed: (){
                            CartModel.of(context).incProduct(cartProduct);
                          },
                        ),
                        //REMOVER ITEM NO CARRINHO
                        IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey[500],),
                            onPressed: (){
                              CartModel.of(context).removeCartItem(cartProduct);
                            }
                            )
                      ],
                    )
                  ],
                ),
              )
          )
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        //se nao o carrinho tiver produtos que nao estao nessa sessao, ou seja, null, precisa buscar no firebase
        child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
            future: Firestore.instance.collection("products").document(
                cartProduct.category)
                .collection("items").document(cartProduct.pid).get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                cartProduct.productData = ProductData.fromDocument(snapshot.data);
                return _buildContent();
              } else {
                return Container(
                  height: 70.0,
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              }
            }
        )
            :
            _buildContent()
    );
  }
}
