import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_app/models/expense.dart';

class ExpenseFormOverlay extends StatefulWidget {
  const ExpenseFormOverlay({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<ExpenseFormOverlay> createState() => _ExpenseFormOverlayState();
}

class _ExpenseFormOverlayState extends State<ExpenseFormOverlay> {
  // var _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  // void _submitExpense() {
  //   print(_enteredTitle);
  // }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  bool isFormValid = true;

  bool isTitleInvalid = false;
  bool isAmountInvalid = false;
  bool isDateInvalid = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showDialog(String titleText, String contentText) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  void _saveNewExpense() {
    // print(_titleController.text);
    // print(_amountController.text);
    final enteredAmount = double.tryParse(_amountController.text);
    setState(() {
      isFormValid = true;
      isAmountInvalid = false;
      isDateInvalid = false;
      isTitleInvalid = false;
    });
    // tryparse text => null, tryParse '12.2' => 12.2
    isAmountInvalid = enteredAmount == null || enteredAmount <= 0;
    isTitleInvalid = _titleController.text.trim().isEmpty;
    isDateInvalid = _selectedDate == null;

    if (isTitleInvalid || isAmountInvalid || isDateInvalid) {
      // show amount invalid message
      isFormValid = false;
      _showDialog(
        "Please check your form",
        "something is wrong, please check your inputs",
      );
      return;
    }

    widget.onAddExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount!,
          datetime: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  void _resetNewExpense() {
    _titleController.clear();
    _amountController.clear();

    setState(() {
      isFormValid = true;
      isAmountInvalid = false;
      isDateInvalid = false;
      isTitleInvalid = false;
    });
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _selectCategory(Category value) {
    setState(() {
      _selectedCategory = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (width > 600)
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  TextField(
                                    // onChanged: _saveTitleInput,
                                    controller: _titleController,
                                    maxLength: 50,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      label: Text('Title'),
                                    ),
                                  ),
                                  if (isTitleInvalid)
                                    const Text(
                                      'title cannot be empty',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    // onChanged: _saveTitleInput,
                                    controller: _amountController,
                                    maxLength: 20,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      prefixText: '\$ ',
                                      label: Text('Amount'),
                                    ),
                                  ),
                                  if (isAmountInvalid)
                                    const Text(
                                      'Amount is invalid',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton(
                                value: _selectedCategory,
                                items: Category.values
                                    .map(
                                      (category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(
                                          category.name.toUpperCase(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  _selectCategory(value);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _selectedDate == null
                                            ? 'Select Date'
                                            : DateFormat('dd/MM/yyyy')
                                                .format(_selectedDate!),
                                      ),
                                      IconButton(
                                          onPressed: _presentDatePicker,
                                          icon:
                                              const Icon(Icons.calendar_month))
                                    ],
                                  ),
                                  if (isDateInvalid)
                                    const Text(
                                      'Please select a date',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _resetNewExpense,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade500,
                                // padding: const EdgeInsets.all(10),
                              ),
                              child: const Text(
                                'Reset Expense',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            ElevatedButton(
                              onPressed: _saveNewExpense,
                              // style: ElevatedButton.styleFrom(
                              //   padding: const EdgeInsets.all(10),
                              // ),
                              child: const Text('Save Expense'),
                            ),
                          ],
                        )
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          // onChanged: _saveTitleInput,
                          controller: _titleController,
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                        if (isTitleInvalid)
                          const Text(
                            'title cannot be empty',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.red),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    // onChanged: _saveTitleInput,
                                    controller: _amountController,
                                    maxLength: 20,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      prefixText: '\$ ',
                                      label: Text('Amount'),
                                    ),
                                  ),
                                  if (isAmountInvalid)
                                    const Text(
                                      'Amount is invalid',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 17),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _selectedDate == null
                                            ? 'Select Date'
                                            : DateFormat('dd/MM/yyyy')
                                                .format(_selectedDate!),
                                      ),
                                      IconButton(
                                          onPressed: _presentDatePicker,
                                          icon:
                                              const Icon(Icons.calendar_month))
                                    ],
                                  ),
                                  if (isDateInvalid)
                                    const Text(
                                      'Please select a date',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton(
                              value: _selectedCategory,
                              items: Category.values
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(
                                        category.name.toUpperCase(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                _selectCategory(value);
                              },
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: _resetNewExpense,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade500,
                                    // padding: const EdgeInsets.all(10),
                                  ),
                                  child: const Text(
                                    'Reset Expense',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                ElevatedButton(
                                  onPressed: _saveNewExpense,
                                  // style: ElevatedButton.styleFrom(
                                  //   padding: const EdgeInsets.all(10),
                                  // ),
                                  child: const Text('Save Expense'),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
