import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_bloc2/model/news_model.dart';
import 'package:news_bloc2/repository/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final List<News> _newsList = [];

  @override
  NewsState get initialState => NewsInitial();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    print('bloc event:$event');
    switch (event) {
      case NewsEvent.LoadMoreNews:
        yield* _mapLoadMoreNewsToState();
        break;
      case NewsEvent.RefreshNews:
        yield* _mapLoadMoreNewsToState(isRefresh: true);
        break;
    }
  }

  Stream<NewsState> _mapLoadMoreNewsToState({isRefresh = false}) async* {
    final int nextPage = isRefresh ? 1 : (_newsList.length ~/ NewsRepository.perPage) + 1;
    // print('请求接口之前 length:${_newsList.length},nextPage:$nextPage');

    final newList = await NewsRepository.getWangyiNews(page: nextPage);
    print('从服务器获取到 ${newList.length} 条数据');
    if (isRefresh) _newsList.clear();
    _newsList.addAll(newList);
    yield NewsLoaded(newsList: _newsList);
  }
}
