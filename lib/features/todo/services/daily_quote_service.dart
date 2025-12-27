import 'package:http/http.dart' as http;
import 'dart:convert';

class DailyQuoteService {
  final String _apiUrl = 'https://v1.hitokoto.cn/';

  Future<String> fetchDailyQuote() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['hitokoto'] ?? "今日无言";
    } else {
      return "加载失败，但是问题不大";
    }
  }
}
