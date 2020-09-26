import 'package:expenses_planner/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart({this.recentTransactions});

  List<Map<String, Object>> get groupTransactionValues {
    return List.generate(7, (index) {
      final DateTime weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for (int index = 0; index < recentTransactions.length; index++) {
        final Transaction transaction = recentTransactions[index];

        if (transaction.date.day == weekDay.day &&
            transaction.date.month == weekDay.month &&
            transaction.date.year == weekDay.year) {
          totalSum += transaction.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return this.recentTransactions.fold(0.0, (previousValue, transaction) {
      return previousValue + transaction.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: this.groupTransactionValues.map((transactionValues) {
            final String label = transactionValues['day'];
            final double spending = transactionValues['amount'];
            final double spendingInPercentOfTotal =
                spending / this.totalSpending;
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: label,
                  spendingAmount: spending,
                  spendingPercentOfTotal: spendingInPercentOfTotal.isNaN
                      ? 0.0
                      : spendingInPercentOfTotal),
            );
          }).toList(),
        ),
      ),
    );
  }
}
