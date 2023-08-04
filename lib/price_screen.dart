import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'dart:io' show Platform;

import 'networking.dart';
import 'constants.dart';

class PriceScreen extends StatefulWidget {

  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  Networking networking = Networking();

  String selectedCurrency = 'AUD'; // Default currency

  int bitcoinValue = 0;
  int ethereumValue = 0;
  int litecoinValue = 0;

  // Update currency values
  void updateCurrency(String mainCurrency,String selectedCurrecy) async {
    String url = '$kBaseURL$mainCurrency$selectedCurrecy';
    networking.makeGETRequest(url, kApiKey).then((data) {
      setState(() {
        if (mainCurrency == 'BTC') {
          bitcoinValue = data['last'].toInt();
        } else if (mainCurrency == 'ETH') {
          ethereumValue = data['last'].toInt();
        } else if (mainCurrency == 'LTC') {
          litecoinValue = data['last'].toInt();
        }
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }

  // Android dropdown
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
          child: Text(
              currency,
              style: TextStyle(color: Colors.white),
          ),
          value: currency,
      );
      dropdownItems.add(newItem);
    }

    // Return dropdown
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
          });

          updateCurrency('BTC', selectedCurrency);
          updateCurrency('ETH', selectedCurrency);
          updateCurrency('LTC', selectedCurrency);
        }
    );
  }

  // iOS picker
  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(
          currency,
          style: TextStyle(color: Colors.white),
      );
      pickerItems.add(newItem);
    }

    // Return picker
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
          });

          updateCurrency('BTC', selectedCurrency);
          updateCurrency('ETH', selectedCurrency);
          updateCurrency('LTC', selectedCurrency);
        },
        children: pickerItems
    );
  }

  @override
  void initState() {
    super.initState();
    updateCurrency('BTC', selectedCurrency);
    updateCurrency('ETH', selectedCurrency);
    updateCurrency('LTC', selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Theme.of(context).colorScheme.primary,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Column(
                  children: [
                    Text(
                        '1 BTC = $bitcoinValue $selectedCurrency',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white
                        ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                        '1 ETH = $ethereumValue $selectedCurrency',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white
                        ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                        '1 LTC = $litecoinValue $selectedCurrency',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white
                        ),
                    ),
                  ],
                )
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Theme.of(context).colorScheme.primary,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          )
        ],
      )
    );
  }
}
