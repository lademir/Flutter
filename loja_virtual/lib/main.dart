import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/cart_model.dart';
import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //O CARRINHO PRECISA SABER QUAL USUARIO ATUAL, LOGO, FICA ABAIXO DO SCOPED USER
    return ScopedModel<UserModel>(
        //USER
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return ScopedModel<CartModel>(
                //CARRINHO
                model: CartModel(model), //PASSANDO O USER_MODEL PARA O CART_MODEL
                child: MaterialApp(
                  title: "Flutter's Clothing",
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                    primaryColor: Color.fromARGB(255, 4, 125, 141),
                  ),
                  home: HomeScreen(),
                )
            );
          },
        )
    );
  }
}
