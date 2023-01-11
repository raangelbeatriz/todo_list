import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme_extensions.dart';
import '../task_create_controller.dart';

class CalendarButton extends StatelessWidget {
  CalendarButton({Key? key}) : super(key: key);
  final dateFormat = DateFormat('dd/MM/y');
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var lastDate = DateTime.now();
        lastDate = lastDate.add(const Duration(days: 10 * 365));
        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: lastDate,
        );

        context.read<TaskCreateController>().selectedDate = selectedDate;
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(
            Icons.today,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 10,
          ),
          Selector<TaskCreateController, DateTime?>(
            selector: (_, taskCreateController) {
              return taskCreateController.selectedDate;
            },
            builder: ((context, value, child) {
              if (value != null) {
                return Text(
                  dateFormat.format(value),
                  style: context.titleStyle,
                );
              } else {
                return Text(
                  'SELECIONE UMA DATA',
                  style: context.titleStyle,
                );
              }
            }),
          )
        ]),
      ),
    );
  }
}
