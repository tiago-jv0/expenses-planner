import 'package:flutter/material.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // new Transaction(
    //     id: 't1', title: 'New shoes', amount: 69.99, date: DateTime.now()),
    // new Transaction(
    //     id: 't2', title: 'New Groceries', amount: 16.53, date: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return this._userTransactions.where((transaction) {
      return transaction.date
          .isAfter(new DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      {@required String title,
      @required double amount,
      @required DateTime selectedDate}) {
    final newTransaction = new Transaction(
        title: title,
        amount: amount,
        date: selectedDate,
        id: DateTime.now().toString());

    setState(() {
      this._userTransactions.add(newTransaction);
    });
  }

  void _removeTransaction({String id}) {
    if (id.isEmpty) {
      return;
    }

    setState(() {
      this._userTransactions.removeWhere((transaction) {
        return transaction.id == id;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (BuildContext builderContext) {
          return GestureDetector(
            child: NewTransaction(
              addTransaction: this._addNewTransaction,
            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses Planner'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => this._startAddNewTransaction(context))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                child: Card(
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chart(
                      recentTransactions: this._recentTransactions,
                    ),
                  ),
                ),
              ),
              TrasactionList(this._userTransactions, this._removeTransaction),
            ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => this._startAddNewTransaction(context),
      ),
    );
  }
}
