import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/favorite_bloc.dart';
import 'package:flutter_tube/blocs/videos_bloc.dart';
import 'package:flutter_tube/delegates/data_search.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:flutter_tube/screens/favorites.dart';
import 'package:flutter_tube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of<VideosBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 70.0,
          child: Image.asset("images/logoYT.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.of<FavoriteBloc>(context).outFav,
              builder: (context,snapshot){
                if(snapshot.hasData) return Text("${snapshot.data.length}");
                else return Container();
              },
            ),
          ),
          IconButton(
              icon: Icon(Icons.star),
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Favorites())
                );
              }
          ),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async{
                String result = await showSearch(context: context, delegate: DataSearch());
                if(result != null) BlocProvider.of<VideosBloc>(context).inSearch.add(result);
              }
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder( //CADA VEZ QUE A STREAM FOR ATUALIZADA, VAI REFAZER ESSA PARTE
        stream: BlocProvider.of<VideosBloc>(context).outVideos,
        initialData: [],
        builder: (context, snapshot){
          if(snapshot.hasData)
            return ListView.builder(
                itemBuilder: (context, index){
                  if(index < snapshot.data.length){
                    return VideoTile(snapshot.data[index]);
                  }
                  else if (index > 1){ //PARA QUANDO ABRIR NAO FICAR CARREGANDO INFINITAMENTE
                    bloc.inSearch.add(null);
                    return Container(
                      height: 40.0,
                      width: 40.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red),),
                    );
                  }
                  else return Container();
                },
              itemCount: snapshot.data.length + 1,
            );
          else return Container();
        },
      ),
    );
  }
}
