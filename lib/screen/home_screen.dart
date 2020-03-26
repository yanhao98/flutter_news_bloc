import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_bloc2/blocs/bloc/news_bloc.dart';
import 'package:news_bloc2/model/news_model.dart';

class HomeScreen extends StatelessWidget {
  final NewsBloc _bloc = NewsBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wangyi News'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                _bloc.add(NewsEvent.RefreshNews);
              }),
          SizedBox(height: 16),
          FloatingActionButton(
              child: Icon(Icons.navigate_next),
              onPressed: () {
                _bloc.add(NewsEvent.LoadMoreNews);
              }),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        bloc: _bloc..add(NewsEvent.LoadMoreNews),
        condition: (previous, current) {
          print('condition，$previous => $current');
          return true;
        },
        builder: (context, state) {
          print('UI bloc builder state:$state');
          if (state is NewsInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is NewsLoaded) {
            // print('UI $state，newsLength:${state.newsList.length}');
            return Scrollbar(
              child: ListView.builder(
                itemCount: state.newsList.length,
                itemBuilder: (c, i) => ListItem(news: state.newsList[i]),
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '当前状态\n$state',
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
                RaisedButton(
                  child: Text('LoadMore'),
                  onPressed: () {
                    _bloc.add(NewsEvent.LoadMoreNews);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final News news;
  const ListItem({
    Key key,
    @required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(news.title),
        subtitle: Text(news.passtime),
        trailing: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            news.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
