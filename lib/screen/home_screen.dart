import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_bloc2/blocs/bloc/news_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wangyi News'),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        bloc: NewsBloc()..add(LoadMoreNews()),
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
            print('UI $state，newsLength:${state.newsList.length}');
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
                    context.bloc<NewsBloc>().add(LoadMoreNews());
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
