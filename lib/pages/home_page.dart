import 'package:expenses_tracker/components/expense_summary.dart';
import 'package:expenses_tracker/components/expense_tile.dart';
import 'package:expenses_tracker/data/expense_data.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController amountController;
  late TextEditingController nameController;
  late TextEditingController centController;

  @override
  void initState() {
    super.initState();

    // preparing the data befor build is called
    Provider.of<ExpenseData>(context, listen: false).prepareData();

    nameController = TextEditingController();
    amountController = TextEditingController();
    centController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    centController.dispose();

    super.dispose();
  }

  // add new expense function
  void addExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add new expense',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Expense name',
              ),
            ),

            // expense amount
            Row(
              children: [
                // whole number field
                Expanded(
                  child: TextField(
                    controller: amountController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Dollars',
                    ),
                  ),
                ),

                const SizedBox(
                  width: 24,
                ),

                // decimal field
                Expanded(
                  child: TextField(
                    controller: centController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Cents',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: onCancel,
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // save button
          MaterialButton(
            onPressed: onSave,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // onSave expense function
  void onSave() {
    if (nameController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        centController.text.isNotEmpty) {
      // whole amount
      String amount = '${amountController.text}.${centController.text}';
      // create new expense
      ExpenseItem newExpense = ExpenseItem(
        name: nameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );

      // add new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clearControllers();
  }

  // onCancel expense function
  void onCancel() {
    Navigator.pop(context);
    clearControllers();
  }

  void clearControllers() {
    nameController.clear();
    amountController.clear();
    centController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        body: ListView(
          children: [
            const SizedBox(
              height: 48,
            ),
            // weekly summary
            ExpenseSummary(
              startOfWeek: value.startOfWeekDate(),
            ),

            const SizedBox(
              height: 24,
            ),

            // expense list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getallExpense().length,
              itemBuilder: (context, index) => Expensetile(
                name: value.getallExpense()[index].name,
                amount: value.getallExpense()[index].amount,
                dateTime: value.getallExpense()[index].dateTime,
                deleteTapped: (_) =>
                    deleteExpense(value.getallExpense()[index]),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addExpense,
          backgroundColor: Colors.deepPurple,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
