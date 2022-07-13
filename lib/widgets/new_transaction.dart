// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class NewTransaction extends StatefulWidget {
//   final Function addTx;

//   NewTransaction(this.addTx);

//   @override
//   State<NewTransaction> createState() {
//     _NewTransactionState();
//   }
// }

// class _NewTransactionState extends State<NewTransaction> {
//   final titleController = TextEditingController();

//   final amountController = TextEditingController();
//   DateTime selectedDate;

//   _NewTransactionState() {
//     print("Constructor NewTX state");
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   void _submitData() {
//     final enteredTitle = titleController.text;
//     final enteredAmount = double.parse(amountController.text);
//     if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
//       return;
//     }
//     widget.addTx(
//       enteredTitle,
//       enteredAmount,
//       selectedDate,
//     );
//     // print(titleController.text);
//     // print(amountController.text);

//     print("Hi");
//     Navigator.of(context).pop();
//   }

//   void _presentDatePicker() {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2022),
//       lastDate: DateTime.now(),
//     ).then((pickedDate) {
//       if (pickedDate == null) {
//         return;
//       } else {
//         setState(() {
//           selectedDate = pickedDate;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Card(
//         child: Container(
//           padding: EdgeInsets.only(
//               top: 10,
//               bottom: MediaQuery.of(context).viewInsets.bottom + 10,
//               left: 10,
//               right: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
//               TextField(
//                 decoration: InputDecoration(labelText: "Title"),
//                 // onChanged: (value) => titleInput = value,
//                 controller: titleController,
//                 onSubmitted: (_) => _submitData(),
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: "Amount"),
//                 // onChanged: (value) => amountInput = value,
//                 controller: amountController,
//                 keyboardType: TextInputType.number,
//                 onSubmitted: (_) => _submitData(),
//               ),
//               Container(
//                 height: 70,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(selectedDate == null
//                           ? 'No Date Chosen'
//                           : 'Picked Date: ${DateFormat.yMd().format(selectedDate)}'),
//                     ),
//                     FlatButton(
//                       textColor: Theme.of(context).primaryColor,
//                       child: Text(
//                         'Choose Date',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       onPressed: _presentDatePicker,
//                     ),
//                   ],
//                 ),
//               ),
//               RaisedButton(
//                 child: Text("Add Transaction"),
//                 color: Theme.of(context).primaryColor,
//                 textColor: Theme.of(context).textTheme.button.color,
//                 onPressed: _submitData,
//               ),
//             ],
//           ),
//         ),
//         elevation: 5,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = int.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: '標題'),
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
              style: TextStyle(fontSize: 15),
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),
            TextField(
              decoration: InputDecoration(labelText: '金額'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
              style: TextStyle(fontSize: 15),
              // onChanged: (val) => amountInput = val,
            ),
            Container(
              height: 35,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? '尚未選擇日期'
                          : '日期: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      '選擇日期',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _presentDatePicker,
                  ),
                ],
              ),
            ),
            RaisedButton(
              child: Text('增加記帳'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}
