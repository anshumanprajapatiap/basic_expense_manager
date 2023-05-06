import 'package:basic_expense_manager/models/transaction.dart';
import 'package:basic_expense_manager/widgets/chartBars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyChart extends StatelessWidget {

  late final List<Transaction> recentTransaction;
  WeeklyChart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactionValues{
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for(var i=0; i<recentTransaction.length; i++){
        if(recentTransaction[i].date.day== weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year){
            totalSum += recentTransaction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0,2),
        'amount': totalSum};
    }).reversed.toList();
  }

  double get totalSpending{
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'].toString(),
                  data['amount'] as double,
                  totalSpending == 0.0 ? 0.0 :(data['amount'] as double) / totalSpending),
            );
          },).toList(),
        ),
      ),
    );
  }
}
