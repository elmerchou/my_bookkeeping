import './widgets/new_transaction.dart';

import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: const TextTheme(
            headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold),
            button: TextStyle(
              fontFamily: 'OpenSans',
              color: Colors.white,
            ),
          ),
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Transaction> _userTransaction = [];

  bool _showChart = false;

  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getTransactions();
    super.initState();
  }

  void disChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void getTransactions() async {
    final list = await TransactionDB.getTransactions();
    setState(() {
      _userTransaction = list;
      print('success');
    });
  }

//OK
  void _addNewTransaction(String title, int amount, DateTime date) async {
    final newTx = Transaction(
        title: title,
        amount: amount,
        date: date,
        id: DateTime.now().toString());
    await TransactionDB.addTransactions(newTx);
    getTransactions();
  }

  void _deleteTransaction(String id) {
    TransactionDB.deleteTransactions(id);
    getTransactions();
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart == true
          ? Container(
              child: Chart(_recentTransactions),
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7)
          : txList
    ];
  }

  Widget _buildAppbar() {
    return AppBar(
      title: const Text(
        '???????????????',
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context))
      ],
    );
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      Container(
          child: Chart(_recentTransactions),
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3),
      txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppbar();
    final txList = Container(
        child: TransactionList(_userTransaction, _deleteTransaction),
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7);
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscape)
                ..._buildLandscapeContent(mediaQuery, appBar, txList),
              if (!isLandscape)
                ..._buildPortraitContent(mediaQuery, appBar, txList),
            ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
