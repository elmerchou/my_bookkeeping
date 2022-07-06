import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransaction;
  final Function delete;

  TransactionList(this._userTransaction, this.delete);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
          child: _userTransaction.isEmpty
              ? Column(children: [
                  Text(
                    "No transactions added yet",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset('assets/images/waiting.png',
                          fit: BoxFit.cover)),
                ])
              : ListView.builder(
                  itemBuilder: (ctx, index) {
                    return TransactionItem(
                        userTransaction: _userTransaction[index],
                        delete: delete);
                  },
                  itemCount: _userTransaction.length,
                ));
    });
  }
}
