import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _passController = TextEditingController();
  final _adressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String password;
  String email;

  bool isNumeric(String str){
    if(str == null)
      return false;
    return double.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
            builder: (context, child, model){
              if(model.isLoading)
                return Center(child: CircularProgressIndicator(),);
              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          hintText: "Nome Completo"
                      ),
                      validator: (text){
                        if(text.isEmpty) return "Nome inválido";
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text){
                        if(text.isEmpty || !text.contains("@")) return "E-mail inválido";
                        email = text;
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "Confirme seu E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text){
                        if(text.isEmpty || !text.contains("@") || text != email) return "E-mail não correspondente";
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      controller: _numberController,
                      decoration: InputDecoration(
                          hintText: "Numero"
                      ),
                      keyboardType: TextInputType.number,
                      validator: (text){
                        if(text.isEmpty || !isNumeric(text)) return "Número inválido";
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),
                      obscureText: true,
                      validator: (text){
                        password = text;
                        if(text.isEmpty || text.length < 6) return "Senha inválida";
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(
                          hintText: "Confirme sua senha"
                      ),
                      obscureText: true,
                      validator: (text){
                        if(text.isEmpty || text.length < 6 || password != text)
                          return "Senhas não correspondentes";
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      controller: _adressController,
                      decoration: InputDecoration(
                          hintText: "Endereço"
                      ),
                      validator: (text){
                        if(text.isEmpty) return "Endereço inválida";
                      },
                    ),
                    SizedBox(height: 16.0,),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text("Criar minha conta",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          if(_formKey.currentState.validate()){

                            Map<String, dynamic> userData = {
                              "name": _nameController.text,
                              "email": _emailController.text,
                              "number": _numberController.text,
                              "adress": _adressController.text,
                            };
                            //nao salva a senha junto com os outros dados LGPD
                            model.signUp(
                              userData: userData,
                              pass: _passController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail,
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
            }
        )
    );
  }
  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.of(context).pop());
  }
  void _onFail (){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Falha ao criar usuário!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.of(context).pop());
  }
}

