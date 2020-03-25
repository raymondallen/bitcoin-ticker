import 'networking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class Price {
  String coin;
  String currency;
  double rate;
  DateTime time;

  Price({this.coin, this.currency, this.rate, this.time});

  factory Price.fromJson(dynamic json) {
    return Price(
        coin: json['asset_id_base'] as String,
        currency: json['asset_id_quote'] as String,
        rate: json['rate'].toDouble(),
        time: DateTime.parse(json['time']));
  }

  @override
  String toString() {
    return '{ ${this.coin}, ${this.currency}, ${this.rate.toString()}, ${this.time.toString()} }';
  }
}

class CoinData {
  String getUrl(String coin, String currency) {
    // Return custom url for each coin
    return kExchangeRateUrl
        .replaceFirst('{asset_id_base}', coin)
        .replaceFirst('{asset_id_quote}', currency);
  }

  Future<Map<String, Price>> getCoinData(String currency) async {
    Map<String, Price> prices = {};

    Networking networking = Networking();

    // Compile list of responses
    List<http.Response> list = await Future.wait(
        cryptoList.map((coin) => networking.get(getUrl(coin, currency))));

    // Process list and transform into Map<String, Object>
    list.forEach((response) {
      // do processing here and return items
      if (response != null) {
        Price price = Price.fromJson(jsonDecode(response.body));
        prices[price.coin] = price;
      }
    });
    return prices;
  }
}
