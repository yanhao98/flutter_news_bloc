part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

// 这个状态用来第一次加载。
class NewsInitial extends NewsState {}

class NewsLoaded extends NewsState {
  final List newsList;

  NewsLoaded({@required this.newsList});
}
