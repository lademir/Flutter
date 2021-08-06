import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {

  final String type;
  final ProductData product;

  ProductTile(this.type,this.product);

  @override
  Widget build(BuildContext context) {
    //InkWell faz uma animacao diferente do GestureDetector
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProductScreen(product))
        );
      },
      child: Card(
        child: type == "grid" ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                //se quisesse quadrada, colocarai 1.0
                  aspectRatio: 0.8,
                child: Image.network(
                  product.images[0],
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    // GRID VIEW
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(product.title,
                        style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "R\$ ${product.price.toStringAsFixed(2)}", //vai mostrar .00
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ],
          )
        //LIST VIEW
          : Row(
          children: <Widget>[
            //DIVIDIR O ESPACO
            Flexible(
                flex: 1,
                child: Image.network(
                  product.images[0],
                  fit: BoxFit.cover,
                  height: 250.0,
                ),
            ),
            Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  // GRID VIEW
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(product.title,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "R\$ ${product.price.toStringAsFixed(2)}", //vai mostrar .00
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
