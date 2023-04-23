import 'package:get/get.dart';
import 'package:welldone/models/language.model.dart';

class Translation extends Translations {
  static final List<LanguageModel> languages = [
    LanguageModel(0, "English", "en", "US"),
    LanguageModel(1, "Русский", "ru", "RU"),
  ];
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'task': 'Task',
          'tasks': 'Tasks',
          'noTasks': 'No Tasks',
          'noCompletedTasks': 'No Completed Tasks',
          'deleteTask': 'Delete Task',
          'deleteTaskQuery': 'Are you sure you want to delete?',
          'taskCreate': 'Task created',
          'taskUpdate': 'Task updated',
          'taskDelete': 'Task deleted',
          'category': 'Category',
          'categories': 'Categories',
          'noCategories': 'No Categories',
          'deleteCategory': 'Delete Category',
          'deleteCategoryQuery': 'Are you sure you want to delete?',
          'createCategory': 'Category was created',
          'duplicateCategory': 'Category already exists',
          'editCategory': 'Category was changed',
          'categoryDelete': 'Category was deleted',
          'title': 'Title',
          'validateTitle': 'Required',
          'description': 'Description',
          'validateDescription': 'Required',
          'hintTaskTitle': 'Sleep...',
          'hintTaskDescription': 'Buy 2l of milk',
          'week': 'Week',
          'month': 'Month',
          'common':'Common',
          'language':'Language',
          'ok': 'Ok',
          'create': 'Create',
          'edit': 'Edit',
          'cancel': 'Cancel',
          'delete': 'Delete',
          'error': 'Error',
          'languageChanged': 'Language changed'
        },
        'ru_RU': {
          'task': 'Задача',
          'tasks': 'Задачи',
          'noTasks': 'Нет задач',
          'noCompletedTasks': 'Нет завершенных задач',
          'deleteTask': 'Удалить задачу',
          'deleteTaskQuery': 'Вы уверены что ходите удалить задачу?',
          'taskCreate': 'Задача создана',
          'taskUpdate': 'Задача изменена',
          'taskDelete': 'Задача удалена',
          'category': 'Категория',
          'categories': 'Категории',
          'noCategories': 'Нет категорий',
          'deleteCategory': 'Удалить категорию',
          'deleteCategoryQuery': 'Вы уверены что ходите удалить категорию?',
          'createCategory': 'Категория создана',
          'duplicateCategory': 'Категория уже существует',
          'editCategory': 'Категория изменена',
          'categoryDelete': 'Категория удалена',
          'title': 'Заголовок',
          'validateTitle': 'Обязательно',
          'description': 'Описание',
          'validateDescription': 'Обязательно',
          'hintTaskTitle': 'Спааааать...',
          'hintTaskDescription': 'Купить миндальное молоко',
          'week': 'Неделя',
          'month': 'Месяц',
          'common':'Общие',
          'language':'Язык',
          'ok': 'Oк',
          'create': 'Создать',
          'edit': 'Изменить',
          'cancel': 'Отмена',
          'delete': 'Удалить',
          'error': 'Ошибка',
          'languageChanged': 'Язык изменен'
        },
      };
}
