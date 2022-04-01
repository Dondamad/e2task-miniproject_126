import 'package:flutter/material.dart';

import '../pages/show_specific_task.dart';
import '../services/task_service.dart';
import '../theme.dart';

class CardTask extends StatelessWidget {
  final String title;
  final String coures;
  final String id;
  final bool status;
  final String? time;
  final String? date;

  const CardTask({
    Key? key,
    required this.title,
    required this.coures,
    required this.id,
    required this.time,
    required this.date,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 10),
      child: Card(
        elevation: 1,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowDetailTask(
                          id: id,
                          isComplete: status,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: status
                      ? Icon(Icons.check_box)
                      : Icon(Icons.check_box_outline_blank),
                  onPressed: () {
                    if (!status) {
                      markAsComplete(id);
                    } else {
                      markAsUnComplete(id);
                    }
                  },
                ),
                // const SizedBox(
                //   width: 10,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            coures,
                            style: subtitle2.copyWith(
                                color: status ? successColor : errorColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      // width: size.width - 90,
                      child: Text(title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: headline6.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              decoration: status
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xff94959b),
                          size: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          date!,
                          style: subtitle2.copyWith(
                              color: darkColor.withOpacity(.5)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Icon(
                          Icons.access_time,
                          color: Color(0xff94959b),
                          size: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          time!,
                          style: subtitle2.copyWith(
                              color: darkColor.withOpacity(.5)),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
