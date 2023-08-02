import 'package:flutter/material.dart';

class ExpenseFormOverlay extends StatefulWidget {
  const ExpenseFormOverlay({super.key});

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

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveNewExpense() {
    // print(_titleController.text);
    // print(_amountController.text);
  }

  void _resetNewExpense() {
    _titleController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
          TextField(
            // onChanged: _saveTitleInput,
            controller: _amountController,
            maxLength: 20,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: '\$',
              label: Text('Amount'),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _resetNewExpense,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade500),
                child: const Text('Reset Expense'),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: _saveNewExpense,
                child: const Text('Save Expense'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
