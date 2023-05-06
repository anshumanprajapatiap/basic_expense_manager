import 'dart:io';
import 'package:basic_expense_manager/widgets/weeklyChart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basic_expense_manager/widgets/userInput.dart';
import 'package:basic_expense_manager/models/transaction.dart';
import 'package:basic_expense_manager/widgets/transactionList.dart';
import 'package:flutter/services.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp, DeviceOrientation.portraitDown
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manger',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.cyan,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          titleLarge: TextStyle(
            fontFamily:'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          )
        ),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                titleLarge: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
            ),
        )
      ),
      home: const MyHomePage(title: 'Expense Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //late String titleInput;
  //late String amountInput;
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  // final List<Transaction> _userTransctions = [
  //   Transaction(id: 't1', title: 'Youtube', amount: 99, date: DateTime.now()),
  //   Transaction(id: 't2', title: 'Food', amount: 100, date: DateTime.now()),
  //   Transaction(id: 't3', title: 'Rapido', amount: 81, date: DateTime.now()),
  //   Transaction(id: 't1', title: 'Youtube', amount: 99, date: DateTime.now()),
  //   Transaction(id: 't2', title: 'Food', amount: 100, date: DateTime.now()),
  //   Transaction(id: 't3', title: 'Rapido', amount: 81, date: DateTime.now()),
  //   Transaction(id: 't1', title: 'Youtube', amount: 99, date: DateTime.now()),
  //   Transaction(id: 't2', title: 'Food', amount: 100, date: DateTime.now()),
  //   Transaction(id: 't3', title: 'Rapido', amount: 81, date: DateTime.now()),
  // ];
  final List<Transaction> _userTransctions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions{
    return _userTransctions.where((tx) {
      return tx.date.isAfter(
          DateTime.now().subtract(
              Duration(days: 7)
          ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime selectedDate){
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: selectedDate);

    setState(() {
      _userTransctions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(
      context: ctx,
      builder: (_){
      return GestureDetector(
          onTap: () {},
          child: UserInput(_addNewTransaction));
    },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransctions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(widget.title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
        )
        : AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                )
            ),
          ],
        )) as PreferredSizeWidget;

    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top) *
            .75,
        child: TransactionList(_userTransctions, _deleteTransaction)
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Show Chart', style: Theme.of(context).textTheme.titleSmall,),
                Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    }
                ),
              ],
            ),
            if(!isLandscape) Container(
              height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
                  .25,
              child: WeeklyChart(_recentTransactions),
            ),
            if(!isLandscape) txListWidget,
            if(isLandscape) _showChart
                ? Container(
                    height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                        .70,
                    child: WeeklyChart(_recentTransactions),
                  )
                : txListWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
              ? Container()
              : FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
            ),
        );
  }
}
