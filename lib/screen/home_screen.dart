import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_bloc2/blocs/bloc/news_bloc.dart';
import 'package:news_bloc2/model/news_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsBloc _bloc = NewsBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(NewsEvent.LoadMoreNews);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('UI page builder');
    return Scaffold(
      appBar: AppBar(
        title: Text('Wangyi News'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            label: Text('Refresh'),
            icon: Icon(Icons.refresh),
            onPressed: () {
              _bloc.add(NewsEvent.RefreshNews);
            },
          ),
          SizedBox(height: 16),
          FloatingActionButton.extended(
            label: Text('Next Page'),
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              _bloc.add(NewsEvent.LoadMoreNews);
            },
          ),
          SizedBox(height: 16),
          FloatingActionButton.extended(
            label: Text('Test'),
            icon: Icon(Icons.bug_report),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        bloc: _bloc,
        condition: (previous, current) {
          // print('condition，$previous => $current');
          return true;
        },
        builder: (context, state) {
          print('UI bloc builder state:$state');
          if (state is NewsInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is NewsLoaded) {
            print('UI $state，newsLength:${state.newsList.length}');
            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                // print('当前位置：${notification.metrics.pixels}，最大长度：${notification.metrics.maxScrollExtent},isLoading:${_bloc.isLoading},未进入屏幕的像素：${notification.metrics.extentAfter}');
                if ((notification.metrics.extentAfter) <= 40 && (!_bloc.isLoading) && (notification is ScrollEndNotification)) {
                  _bloc.add(NewsEvent.LoadMoreNews);
                  print('加载更多');
                }
                return false;
              },
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: state.newsList.length + 1,
                itemBuilder: (c, i) => i == state.newsList.length
                    ? SizedBox(
                        height: 44,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListItem(
                        news: state.newsList[i],
                      ),
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
