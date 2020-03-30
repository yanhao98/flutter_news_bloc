import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_bloc2/model/news_model.dart';
import 'package:news_bloc2/repository/news_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final List<News> _newsList = [];
  bool isLoading = false;

  @override
  NewsState get initialState => NewsInitial();
  // NewsUninitializedState

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    print('bloc event:$event，isLoading：$isLoading');
    switch (event) {
      case NewsEvent.LoadMoreNews:
        yield* _mapLoadMoreNewsToState();
        break;
      case NewsEvent.RefreshNews:
        yield* _mapLoadMoreNewsToState(isRefresh: true);
        break;
    }
  }

  @override
  Stream<NewsState> transformEvents(Stream<NewsEvent> events, Stream<NewsState> Function(NewsEvent event) next) {
    print('transformEvents，events：$events，next:$next');
    return super.transformEvents(
      (events as PublishSubject<NewsEvent>).debounce(
        (event) {
          print('transformEvents.debounce,event:$event');
          if (event == NewsEvent.RefreshNews) {
            // 刷新会延迟3秒
            return TimerStream(true, Duration(seconds: 3));
          } else {
            return Stream.empty();
          }
        },
      ),
      next,
    );
  }

  @override
  void onEvent(NewsEvent event) {
    print('onEvent：$event');
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<NewsEvent, NewsState> transition) {
    print('onTransition：$transition');
    super.onTransition(transition);
  }

  Stream<NewsState> _mapLoadMoreNewsToState({isRefresh = false}) async* {
    final int nextPage = isRefresh ? 1 : (_newsList.length ~/ NewsRepository.perPage) + 1;
    // print('请求接口之前 length:${_newsList.length},nextPage:$nextPage');
    isLoading = true;
    final newList = await NewsRepository.getWangyiNews(page: nextPage);
    print('从repository获取到 ${newList.length} 条数据');
    if (isRefresh) _newsList.clear();
    _newsList.addAll(newList);
    yield NewsLoaded(newsList: _newsList);
    isLoading = false;
  }
}
