import 'dart:ui';

import 'package:expanses/widgets/new_transaction.dart';
import 'package:expanses/widgets/transaction_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/chart.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';

void main() {
  runApp(MyApp());
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expeneses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                button: TextStyle(color: Colors.white))),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String itemInput;
  // String amountInput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(id: 't1', title: "new Shoes", amount: 70, date: DateTime.now()),
    // Transaction(id: 't2', title: "Groceries", amount: 170, date: DateTime.now())
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(_addNewTransaction));
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);

    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context))
      ],
    );

    final txListWidget = Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child:
                        TransactionList(_userTransactions, _deleteTransaction));

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("show chart"),
                  Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      })
                ],
              ),
              if(!isLandscape) Container(
                    height:200,
                    child: Chart(_recentTransactions)),
                    if(!isLandscape) txListWidget,
            if(isLandscape) _showChart
            ? 
            Container(
                    height: (MediaQuery.of(context).size.height - 45 -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top),
                    child: Chart(_recentTransactions)) : txListWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
