import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction({this.addTransaction});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _saveTransaction() {
    if (this._amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = this._titleController.text;
    final enteredAmount = double.parse(this._amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        this._selectedDate == null) {
      return;
    }

    this.widget.addTransaction(
        title: enteredTitle,
        amount: enteredAmount,
        selectedDate: this._selectedDate);

    Navigator.of(context).pop();
  }

  Future<void> _presentDatePicker() async {
    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());

    if (pickedDate == null) {
      return;
    }

    setState(() {
      this._selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (String value) => this._saveTransaction(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                      child: Text(this._selectedDate == null
                          ? 'No Date Chosen'
                          : 'Picked Date : ${DateFormat.yMd().format(this._selectedDate)}')),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: this._presentDatePicker,
                  )
                ],
              ),
            ),
            RaisedButton(
                onPressed: this._saveTransaction,
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                child: Text('Add Transaction'))
          ],
        ),
      ),
    );
  }
}
