 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/task_list/task_list_item.dart';

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {



  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthProviders>(context);
    if(listProvider.tasksList.isEmpty){
     listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
    }
    return
      Container(
      child: Column(
        children: [
          Container(
           color : MyTheme.whiteColor,
            child: EasyDateTimeLine(
              initialDate: listProvider.selectedDate,
              onDateChange: (selectedDate) {
                //`selectedDate` the new date selected.
                listProvider.changeSelectedDate(selectedDate, authProvider.currentUser!.id!);
              },
              activeColor: const Color(0xff5D9CEC),
              dayProps: const EasyDayProps(
                todayHighlightStyle: TodayHighlightStyle.withBackground,
                todayHighlightColor: Color(0xffE1ECC8),
              ),
            )


          ),

         Expanded(child:  ListView.builder(
             itemBuilder: (context , index){
               return TaskListItem(task:listProvider.tasksList[index],);

             },itemCount:listProvider.tasksList.length,
             )
         )


        ],

      ),
    );

  }


}
