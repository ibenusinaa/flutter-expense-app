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

    if (isTitleInvalid) {
      isFormValid = false;
    }

    if (isAmountInvalid) {
      // show amount invalid message
      isFormValid = false;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Amount Invalid'),
          content: const Text('Please make sure a valid amount'),
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
      return;
    }

    if (isDateInvalid) {
      // show date error message
      isFormValid = false;
    }

    if (isFormValid = false) {
      return;
    }

    // if (_titleController.text.trim().isEmpty ||
    //     amountIsInvalid ||
    //     _selectedDate == null) {
    //   // show error message
    //   isFormValid = false;
    //   showDialog(
    //     context: context,
    //     builder: (ctx) => AlertDialog(
    //       title: const Text('Invalid input'),
    //       content: const Text('Please make sure a valid title was entered.'),
    //       actions: [
    //         TextButton(
    //             onPressed: () {
    //               Navigator.pop(ctx);
    //             },
    //             child: const Text('Okay'))
    //       ],
    //     ),
    //   );
    //   return;
    // }
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        ),
                        IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month))
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                  }),
              const Spacer(),
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
      ),
    );
  }
}
