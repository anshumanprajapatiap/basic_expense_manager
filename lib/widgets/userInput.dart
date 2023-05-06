import 'dart:io';
import 'dart:math';
import 'package:basic_expense_manager/widgets/AdaptiveButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserInput extends StatefulWidget {
  final Function addTx;

  UserInput(this.addTx);

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitData(){
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if(enteredTitle.isEmpty || enteredAmount<=0 || _selectedDate==null){
      return;
    }
    widget.addTx(
        enteredTitle,
        enteredAmount,
        _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker(){
    Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (_) => Container(
              height: 500,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 400,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (pickedDate) {
                          if(pickedDate == null){
                            return;
                          }
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }),
                  ),
                  // Close the modal
                  CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            )
        ) : showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now()
        ).then((pickedDate) {
          if(pickedDate == null){
            return;
          }
          setState(() {
            _selectedDate = pickedDate;
          });
        });
    print(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child:
        Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom+10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Enter Title'),
                controller: titleController,
                onSubmitted: (_) => _submitData(),
                /*onChanged: (value) {
                        titleInput = value;
                      },*/
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Enter Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                //onChanged: (value) => amountInput = value,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          _selectedDate == null
                              ? 'Date not choosen'
                              : 'Picked date : ${DateFormat.yMd().format(_selectedDate).toString()}'
                      ),
                    ),
                    AdaptiveButton('Choose Date', _presentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
