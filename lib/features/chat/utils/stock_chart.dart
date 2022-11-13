import 'package:dio/dio.dart';

Future<Map<String, double>> getStockChart(String company) async {
  print('getStockChart $company');
  Map<String, double> result = {};
  try {
    var dio = Dio();
    var request = await dio.get(
        'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$company&interval=60min&apikey=FWSQGTWKKUNCJUY8');
    for (var series in (request.data['Time Series (60min)'] as Map<
        String,
        dynamic>).keys) {
      // print(series);
      var date = DateTime.parse(series);
      result[date.millisecondsSinceEpoch.toString()] =
      double.parse(request.data['Time Series (60min)'][series]['1. open']);
    }
    // print(result);
  } catch (e) {
    print('stock err');
    print(e);
  }
  return result;
}

void main() async {
  print( await getStockChart('IBM'));
  // DateTime dateTime = ;
  // print(dateTime);

}
