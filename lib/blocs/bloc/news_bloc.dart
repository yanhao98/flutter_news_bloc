import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final _newsList = [];

  @override
  NewsState get initialState => NewsInitial();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    print('bloc event:$event');
    if (event is LoadMoreNews) {
      _newsList.addAll([1, 2, 3, 4, 5]);
      yield NewsLoaded(newsList: _newsList);
    }
  }
}
