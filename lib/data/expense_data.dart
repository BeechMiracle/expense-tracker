import 'package:expenses_tracker/data/date_converter.dart';
import 'package:expenses_tracker/data/hive_database.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  // list of  all expenses
  List<ExpenseItem> allExpense = [];

  // method to get expense list
  List<ExpenseItem> getallExpense() => allExpense;

  // prepared data to display
  final db = HiveDatabase();

  void prepareData() {
    // if data exist, get data
    if (db.readData().isNotEmpty) {
      allExpense = db.readData();
    }
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense) {
    allExpense.add(newExpense);
    notifyListeners();
    db.saveData(allExpense);
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    allExpense.remove(expense);
    notifyListeners();
    db.saveData(allExpense);
  }

  // get weekdat from a dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // get date for the start of the week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get today's date
    DateTime today = DateTime.now();

    // go backward from today to find the nearest sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  // all expense amount per week
  Map<String, double> calculateDailyExpense() {
    Map<String, double> dailySummary = {
      // date : amount total for the day
    };

    for (var expense in allExpense) {
      String date = dateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailySummary.containsKey(date)) {
        double currentAmount = dailySummary[date]!;
        currentAmount += amount;
        dailySummary[date] = currentAmount;
      } else {
        dailySummary.addAll({date: amount});
      }
    }

    return dailySummary;
  }
}
