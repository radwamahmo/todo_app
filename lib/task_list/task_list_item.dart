 import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/edit_task.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/list_provider.dart';

class TaskListItem extends StatefulWidget {
  Task task;
  TaskListItem({required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthProviders>(context);
    var uId = authProvider.currentUser!.id!;
    return  InkWell(
      onTap: (){
        Navigator.pushNamed(context, EditTaskScreen.routeName, arguments: widget.task);
      },
      child: Container(
        margin: EdgeInsets.all(12),
        child: Slidable(

          // The start action pane is the one at the left or the top side.
            startActionPane: ActionPane(
              extentRatio: 0.25,
              // A motion is a widget used to control how the pane animates.
              motion: const DrawerMotion(),

              // All actions are defined in the children parameter.
              children:  [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  borderRadius: BorderRadius.circular(12),
                  onPressed: (context){
                    DialogUtils.showLoading(context: context, message: 'Loading....');
                  FireBaseUtils.deleteTaskFromFireStore(widget.task,uId).
                 then((value) {

                    print('Task deleted Successfully');
                    DialogUtils.hideLoading(context);
                    DialogUtils.showMessage(context: context, message: 'Task deleted successfully',
                        posActionName: 'ok',posAction: (){
                          Navigator.pop(context);
                        });
                    listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);

                  }).timeout(Duration(milliseconds: 500),onTimeout: (){
                    print('Task deleted Successfully');
                    listProvider.getAllTasksFromFireStore(uId);

                  });
                  },
                  backgroundColor: MyTheme.redColor,
                  foregroundColor:MyTheme.whiteColor,
                  icon: Icons.delete,
                  label: 'Delete',
                ),

              ],
            ),

            child: Container(

              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: MyTheme.whiteColor
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.11,
                    width: 4,
                    color: widget.task.isDone!?MyTheme.greenColor: Theme.of(context).primaryColor ,
                  ),
                  SizedBox(width: 12,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.task.title ?? '',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color:widget.task.isDone!? MyTheme.greenColor: Theme.of(context).primaryColor
                        ),),
                      Text(widget.task.description??'',
                          style: Theme.of(context).textTheme.titleLarge)
                    ],
                  )),
               InkWell(
                 onTap: (){
                   widget.task.isDone =!widget.task.isDone!;
                   FireBaseUtils.editIsDone(widget.task, uId);
                   setState(() {

                   });
                 },
                 child: widget.task.isDone!? Text('Done!',style: TextStyle(
                   color: MyTheme.greenColor,
                   fontWeight: FontWeight.bold,
                   fontSize: 22
                 ),): Container(
                   padding: EdgeInsets.symmetric(
                       vertical: 7,
                       horizontal: 20
                   ),
                   decoration: BoxDecoration(
                       color: MyTheme.blueColor,
                       borderRadius: BorderRadius.circular(15)
                   ),
                   child: Icon(Icons.check,color: MyTheme.whiteColor,size: 35,),
                 ) ,
               )
                  ,
                ],
              ),
            )),
      ),
    )

      ;
  }
}
