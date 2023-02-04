import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:iconsax/iconsax.dart';
import 'package:welldone/main.dart';
import 'package:welldone/models/task.dart';
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
  CalendarFormat calendarFormat = CalendarFormat.week;

  var tasks = <Task>[];
  int countTotalTasks = 0;
  int countDoneTasks = 0;

  @override
  void initState() {
    getCountTasks();
    getTasks();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  getCountTasks() async {
    final countTotal = await taskService.getCountTotalTaskCalendar(selectedDay);
    final countDone = await taskService.getCountDoneTaskCalendar(selectedDay);
    setState(() {
      countTotalTasks = countTotal;
      countDoneTasks = countDone;
    });
  }

  getTasks() async {
    final taskCollection = isar.tasks;
    List<Task> getTasks;
    getTasks = await taskCollection
        .filter()
        .doneEqualTo(false)
        .dateIsNotNull()
        .findAll();
    setState(() {
      tasks = getTasks;
    });
  }

  int getCountTotalTasksCalendar(DateTime date) => tasks.where((e) => e.date != null && DateTime(date.year, date.month, date.day, 0, -1).isBefore(e.date!) && DateTime(date.year, date.month, date.day, 23, 60).isAfter(e.date!)).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors.gradient
              ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
            ),
          ),
          child: TableCalendar(
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                return getCountTotalTasksCalendar(day) != 0 ? Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(getCountTotalTasksCalendar(day).toString()),
                  ),
                ) : null;
              },
            ),
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
              });
              getCountTasks();
            },
            //TODO: onPageChanged
            // onPageChanged: (focused) {
            //   setState(() {
            //     selectedDay = focused;
            //   });
            //   getCountTasks();
            // },
            calendarFormat: calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
                },
              );
            },
            daysOfWeekStyle: const DaysOfWeekStyle(
              decoration: BoxDecoration(),
              weekdayStyle: TextStyle(
                color: colors.white,
              ),
              weekendStyle: TextStyle(
                color: colors.white,
              ),
            ),
            headerStyle: const HeaderStyle(
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: colors.white,
              ),
              formatButtonVisible: true,
              formatButtonDecoration: BoxDecoration(

              ),
              formatButtonTextStyle: TextStyle(
                color: colors.white,
              ),
              leftChevronIcon: Icon(Iconsax.arrow_square_left, color: colors.white,),
              rightChevronIcon: Icon(Iconsax.arrow_right, color: colors.white,),
            ),
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              todayDecoration: BoxDecoration(
                borderRadius: designSystem.borderRadius[16],
                color: const Color.fromRGBO(255, 255, 255, 0.7),
              ),
                todayTextStyle: const TextStyle(
                  color: colors.accent,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
                defaultDecoration: BoxDecoration(
                  borderRadius: designSystem.borderRadius[16],
                  color: const Color.fromRGBO(255, 255, 255, 0.3),
                ),
              defaultTextStyle: const TextStyle(
                color: colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
              selectedDecoration: BoxDecoration(
                borderRadius: designSystem.borderRadius[16],
                color: colors.white,
              ),
              selectedTextStyle: const TextStyle(
                color: colors.accent,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
              weekendDecoration: BoxDecoration(
                borderRadius: designSystem.borderRadius[16],
                color: const Color.fromRGBO(255, 255, 255, 0.3),
              ),
              weekendTextStyle: const TextStyle(
                color: colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
              outsideDecoration: const BoxDecoration(),
              outsideTextStyle: const TextStyle(
                color: colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            width: Get.size.width,
            decoration: const BoxDecoration(
              color: colors.white,
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
                      'Tasks',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      '$countDoneTasks ${'completed'.tr}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      '$countTotalTasks ${'total'.tr}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
                TasksList(
                  calendar: true,
                  allTask: false,
                  toggle: taskService.toggleValue.value,
                  selectedDay: selectedDay,
                  set: () {
                    getCountTasks();
                    getTasks();
                  },
                ),
              ],
            ),
          ),
        ),
        TasksList(
          calendar: true,
          allTask: false,
          toggle: taskService.toggleValue.value,
          selectedDay: selectedDay,
          set: () {
            getCountTasks();
            getTasks();
          },
        ),
      ],
    );
  }
}