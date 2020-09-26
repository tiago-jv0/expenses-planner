import 'package:expenses_planner/models/transaction.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class TrasactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function _removeTransaction;
  TrasactionList(this._transactions, this._removeTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 415,
        child: this._transactions.isEmpty
            ? Column(
                children: [
                  Text(
                    'No transactions added yet',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 5,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: FittedBox(
                              child: Text(
                                  '\$${this._transactions[index].amount}')),
                        ),
                      ),
                      title: Text(
                        this._transactions[index].title,
                        style: Theme.of(context).textTheme.title,
                      ),
                      subtitle: Text(DateFormat.yMMMMd()
                          .format(this._transactions[index].date)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).errorColor,
                        onPressed: () {
                          this._removeTransaction(
                              id: this._transactions[index].id);
                        },
                      ),
                    ),
                  );
                },
                itemCount: this._transactions.length,
              ));
  }
}
