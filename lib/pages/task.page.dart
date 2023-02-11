import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:iconsax/iconsax.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/models/task.dart';
import 'package:welldone/pages/widgets/categoryList.widget.dart';
import 'package:welldone/pages/widgets/taskList.widget.dart';
import 'package:welldone/services/task.service.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final taskService = TaskService();
  final locale = Get.locale;
  DateTime selectedDay = DateTime.now();
  Category? selectedCategory;
  CalendarFormat calendarFormat = CalendarFormat.week;
  late bool allTasks;
  int countTotalTasks = 0;
  int countDoneTasks = 0;
  @override
  void initState() {
    allTasks = false;
    getCountTasks();
    super.initState();
  }
  getCountTasks() async {
    final countTotal = await taskService.getCountTotalTaskCalendar(selectedDay);
    final countDone = await taskService.getCountDoneTaskCalendar(selectedDay);
    setState(() {
      countTotalTasks = countTotal;
      countDoneTasks = countDone;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: designSystem.padding[18]!,
          decoration: const BoxDecoration(
            // color: colors.white,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.gradient),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              CategoryList(
                  set: () {},
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = selected;
                    });
                  }),
              TableCalendar(
                calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, selectedDay, events) {
                  return StreamBuilder<List<Task>>(
                      stream: selectedCategory != null
                              ? taskService.getCalendarTasksByCategory(
                                  taskService.toggleValue.value,
                                  selectedDay,
                                  selectedCategory!)
                              : taskService.getCalendarTasks(taskService.toggleValue.value, selectedDay),
                      builder: (context, AsyncSnapshot<List<Task>> listData) {
                        switch (listData.connectionState) {
                          case ConnectionState.done:
                          default:
                            if (listData.hasData) {
                              final taskLength = listData.data!.length;
                              return StatefulBuilder(
                                  builder: (context, innerState) {
                                    return taskLength != 0 ? Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          taskLength.toString(),
                                          style: context.textTheme.bodyText1?.copyWith(color: AppColors.white),
                                        ),
                                      ),
                                    ) : Container();
                                  }
                                  );
                            } else {
                              return Container();
                            }
                        }
                      });
                }),
                startingDayOfWeek: StartingDayOfWeek.monday,
                firstDay: DateTime(2023, 01, 01),
                lastDay: selectedDay.add(const Duration(days: 1000)),
                focusedDay: selectedDay,
                availableCalendarFormats: {
                  CalendarFormat.week: 'month'.tr,
                  CalendarFormat.month: 'week'.tr,
                },
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDay, day);
                },
                onDaySelected: (selected, focused) {
                  setState(() {
                    selectedDay = selected;
                    allTasks = false;
                  });
                  getCountTasks();
                },
                calendarFormat: calendarFormat,
                onFormatChanged: (format) {
                  setState(
                    () {
                      calendarFormat = format;
                    },
                  );
                  getCountTasks();
                },
                daysOfWeekStyle: const DaysOfWeekStyle(
                  decoration: BoxDecoration(),
                  weekdayStyle: TextStyle(
                    color: AppColors.white,
                  ),
                  weekendStyle: TextStyle(
                    color: AppColors.white,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: AppColors.white,
                  ),
                  formatButtonVisible: true,
                  formatButtonDecoration: BoxDecoration(),
                  formatButtonTextStyle: TextStyle(
                    color: AppColors.white,
                  ),
                  leftChevronIcon: Icon(
                    Iconsax.arrow_square_left,
                    color: AppColors.white,
                  ),
                  rightChevronIcon: Icon(
                    Iconsax.arrow_right,
                    color: AppColors.white,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  todayDecoration: BoxDecoration(
                    borderRadius: designSystem.borderRadius[16],
                    color: const Color.fromRGBO(255, 255, 255, 0.7),
                  ),
                  todayTextStyle: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                  defaultDecoration: BoxDecoration(
                    borderRadius: designSystem.borderRadius[16],
                    color: const Color.fromRGBO(255, 255, 255, 0.3),
                  ),
                  defaultTextStyle: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                  selectedDecoration: BoxDecoration(
                    borderRadius: designSystem.borderRadius[16],
                    color: AppColors.white,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                  weekendDecoration: BoxDecoration(
                    borderRadius: designSystem.borderRadius[16],
                    color: const Color.fromRGBO(255, 255, 255, 0.3),
                  ),
                  weekendTextStyle: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                  outsideDecoration: const BoxDecoration(),
                  outsideTextStyle: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            width: Get.size.width,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'tasks'.tr,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      '$countDoneTasks/$countTotalTasks',
                      style: context.textTheme.headline6,
                    ),
                    Switch(
                      value: taskService.toggleValue.value,
                      onChanged: (value) {
                        setState(() {
                          taskService.toggleValue.value = value;
                          getCountTasks();
                        });
                      },
                    ),
                  ],
                ),
                TasksList(
                  calendar: true,
                  allTask: allTasks,
                  toggle: taskService.toggleValue.value,
                  category: selectedCategory,
                  selectedDay: selectedDay,
                  set: () {
                    getCountTasks();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
