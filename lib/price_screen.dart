import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'constants.dart';
import 'crypto-card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currency = 'EUR';
  bool isLoading = false;
  Map<String, Price> prices = {};

  String getUrl(String coin) {
    return kExchangeRateUrl
        .replaceFirst('{asset_id_base}', coin)
        .replaceFirst('{asset_id_quote}', currency);
  }

  void getPrices() async {
    isLoading = true;
    Map<String, Price> data = {};
    data = await CoinData().getCoinData(currency);
    setState(() {
      prices = data;
      print(prices);
    });
    isLoading = false;
  }

  Column buildCards() {
    List<CryptoCard> cards = [];
    cryptoList.forEach((coin) {
      cards.add(CryptoCard(
          coin: coin,
          price: isLoading || prices.length == 0
              ? '?'
              : prices[coin].rate.toStringAsFixed(2),
          currency: currency));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cards,
    );
  }

  DropdownButton<String> androidDropdown() {
    return DropdownButton<String>(
      value: currency,
      items: currenciesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          currency = newValue;
          getPrices();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          currency = currenciesList[selectedIndex];
          getPrices();
        });
      },
      children: currenciesList.map<Widget>((String value) {
        return Text(
          value,
          style: TextStyle(
            color: Colors.white,
          ),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    getPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: (Platform.isIOS ? iOSPicker() : androidDropdown()),
          ),
        ],
      ),
    );
  }
}
