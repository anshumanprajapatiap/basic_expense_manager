import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentageofTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPercentageofTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constrains) {
      return Column(
        children: [
          Container(
              height: constrains.maxHeight*0.15,
              child: FittedBox(child: Text('\$ ${spendingAmount.toStringAsFixed(0)}'))),
          SizedBox(height: 10,),
          Container(
            height: constrains.maxHeight*0.55,
            width: 10,
            child: Stack(
              children: [
                Container(decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  color: Color.fromARGB(150, 150, 50, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPercentageofTotal,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: constrains.maxHeight*0.05,),
          Container(
              height: constrains.maxHeight*0.15,
              child: FittedBox(
                child: Text(label),
              ),
          ),
        ],
      );
    },);
  }
}
