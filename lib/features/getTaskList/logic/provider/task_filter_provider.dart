import 'package:flutter/material.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';

enum TaskFilter { all, today, thisMonth, completed }

class TaskFilterProvider extends ChangeNotifier {
  TaskFilter _currentFilter = TaskFilter.all;
  DateTime? _selectedDate;

  TaskFilter get currentFilter => _currentFilter;

  DateTime? get selectedDate => _selectedDate;

  void setFilter(TaskFilter filter) {
    _selectedDate = null;
    _currentFilter = filter;
    notifyListeners();
  }

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<TaskListResponseModel> applyFilter(
      List<TaskListResponseModel> taskList) {
    if (_selectedDate != null) {
      taskList = taskList.where((task) {
        final taskDate = DateTime.parse(task.dueDate!);
        return taskDate.year == _selectedDate!.year &&
            taskDate.month == _selectedDate!.month &&
            taskDate.day == _selectedDate!.day;
      }).toList();
    }

    switch (_currentFilter) {
      case TaskFilter.today:
        taskList = taskList.where((task) => _isToday(task.dueDate)).toList();
        break;
      case TaskFilter.thisMonth:
        taskList =
            taskList.where((task) => _isThisMonth(task.dueDate)).toList();
        break;
      case TaskFilter.completed:
        taskList = taskList.where((task) => task.taskStatus == true).toList();
        break;
      default:
        // No additional filtering required for "All" filter
        break;
    }

    return taskList;
  }

  bool _isToday(String? dateString) {
    if (dateString == null) return false;
    final now = DateTime.now();
    final date = DateTime.tryParse(dateString);
    return date != null &&
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isThisMonth(String? dateString) {
    if (dateString == null) return false;
    final now = DateTime.now();
    final date = DateTime.tryParse(dateString);
    return date != null && date.year == now.year && date.month == now.month;
  }
}
