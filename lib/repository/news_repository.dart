import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_bloc2/model/news_model.dart';

class NewsRepository {
  static const String _baseUrl = 'https://api.apiopen.top';
  static const int perPage = 500;

  static Future<List<News>> getWangyiNews({int page = 1}) async {
    String _requestUrl = '$_baseUrl/getWangYiNews?count=$perPage&page=$page';

    print('开始请求:$_requestUrl');
    int requestStart = DateTime.now().millisecondsSinceEpoch;
    http.Response response = await http.get(_requestUrl);
    print('请求结束：status:${response.statusCode},耗时：${DateTime.now().millisecondsSinceEpoch - requestStart}');

    // final int start = DateTime.now().millisecondsSinceEpoch;
    List<News> list = parseNewsList(response.body);
    // print('处理json用时:${DateTime.now().millisecondsSinceEpoch - start}');
    return list;
  }
}

List<News> parseNewsList(String responseBody) {
  final data = json.decode(responseBody);
  final List<dynamic> parsed = data['result'];
  return parsed.map((e) => News.fromJson(e)).toList();
}
