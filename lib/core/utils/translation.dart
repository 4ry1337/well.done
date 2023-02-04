import 'package:get/get.dart';

class translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'newTask': 'New Task',
      'week': 'Week',
      'month': 'Month',
      'taskTitle': 'What are you planning to do?',
      'hintText': 'Sleep...',
    },
    'ru_RU': {
      'newTask': 'Новое Задание',
      'week': 'Неделя',
      'month': 'Месяц',
      'taskTitle': 'Что вы планируете делать?',
      'hintText': 'Спать....',
    },
  };
}