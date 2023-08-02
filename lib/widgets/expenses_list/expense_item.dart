import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Text(
              expense.title,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.white)), //ensure angka dibelakang comma
                const Spacer(), //kasi spasi sampe ujung
                Row(
                  children: [
                    Icon(categoryIcons[expense.category],
                        color: Colors.limeAccent),
                    const SizedBox(width: 5),
                    Text(expense.formattedDate,
                        style: const TextStyle(color: Colors.white)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
