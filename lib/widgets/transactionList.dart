import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return
      transactions.isEmpty ? LayoutBuilder(builder: (ctx, constains){
        return Column(
          children: [
            Text(
              'No Transaction yet!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: constains.maxHeight * 0.6,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                )
            )
          ],
        );
      })
          : ListView.builder(
          itemBuilder: (ctx, index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: FittedBox(
                        child: Text('\$ ${transactions[index].amount}'),
                    ),
                  ),
                ),
                title: Text(
                  transactions[index].title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  DateFormat.yMMMd().format(transactions[index].date),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                trailing: MediaQuery.of(context).size.width>400
                  ? ElevatedButton.icon(
                    onPressed: () => deleteTx(transactions[index].id),
                    icon:  Icon(Icons.delete),
                    label: Text('Delete'),
                )
                    : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteTx(transactions[index].id),
                  color: Theme.of(context).errorColor,
                ),
              ),
            );
          },
          itemCount: transactions.length,
      );
  }
}
