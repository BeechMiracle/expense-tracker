import 'package:expenses_tracker/models/expense.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  // reference our box
  final _myBox = Hive.box('expense_database');

  // write data
  void saveData(List<ExpenseItem> allExpense) {
    // hive can only store primitive data types, it can not store custom objects like expenseItem

    List<List<dynamic>> allformattedExpenses = [];

    for (var expense in allExpense) {
      // convert to a list of storable types
      List<dynamic> expenseFormat = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];

      allformattedExpenses.add(expenseFormat);
    }

    // store into database
    _myBox.put('ALL_EXPENSES', allformattedExpenses);
  }

  // read data
  List<ExpenseItem> readData() {
    // convert the saved data into ExpenseItem objects

    List savedExpenses = _myBox.get('ALL_EXPENSES') ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // create expenseItem
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      // add expense to list of all expenses
      allExpenses.add(expense);
    }

    return allExpenses;
  }
}
