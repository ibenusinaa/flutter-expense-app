import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.indigo,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ), //ensure angka dibelakang comma
                const Spacer(), //kasi spasi sampe ujung
                Row(
                  children: [
                    Icon(
                      categoryIcons[expense.category],
                      // color: Colors.limeAccent,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      expense.formattedDate,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
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
