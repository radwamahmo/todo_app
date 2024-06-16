 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/list_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {


  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = '';
  String description ='';
 late ListProvider listProvider;
  @override
  Widget build(BuildContext context) {
     listProvider = Provider.of<ListProvider>(context);
    return Container(
      padding: EdgeInsets.all(15),
     child: Column(
       children: [
         Text('Add New Task',
         style: Theme.of(context).textTheme.titleLarge,),
         Form(
           key: formKey,
             child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             TextFormField(
               onChanged:(text){
                 title = text ;
            },
               validator: (text){
                 if(text== null || text.isEmpty){
                   return 'Please Enter Task Title' ;
                 }
                 return null;
            },
               decoration: InputDecoration(
                 hintText: 'Enter Task Title',
               ),
             ),
             SizedBox(height: 20,),
             TextFormField(
               onChanged: (text){
                 description = text ;
               },
               validator: (text){
                 if(text== null || text.isEmpty){
                   return  'Please Enter Task Description' ;
                 }
                 return null;
               },
               decoration: InputDecoration(
                   hintText: 'Enter Task Description'
               ),
               maxLines: 4,
             ),
             SizedBox(height: 15,),
             Text('Select Date',
             style: Theme.of(context).textTheme.titleMedium,),
             SizedBox(height: 15,),

             InkWell(
               onTap: (){
                 showCalender();
               },
               child: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
               textAlign: TextAlign.center,
               style: Theme.of(context).textTheme.titleMedium,),
             ),
             SizedBox(height: 15,),
             ElevatedButton(onPressed: (){
               addTask();
             },
                 child: Text('Add' ,
                 style: Theme.of(context).textTheme.titleLarge))

           ],
         ))
       ],
     ),
    );
  }

  void showCalender()async{
  var chosenDate = await  showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
   if(chosenDate != null){
     selectedDate = chosenDate;
     setState(() {

     });
   }

  }
  void addTask() {
    if(formKey.currentState!.validate()==true){
      var authProvider = Provider.of<AuthProviders>(context,listen: false);
      DialogUtils.showLoading(context: context, message: 'Loading....');
      Task task = Task(
          title: title, description: description, dateTime: selectedDate);
      FireBaseUtils.addTaskToFireStore(task, authProvider.currentUser!.id!).
    then((value) {
        print('Task added successfully');
      //  Navigator.pop(context);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context: context, message: 'Task added successfully',
        posActionName: 'ok',posAction: (){
              Navigator.pop(context);
            });
        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);

       // Navigator.pop(context);

      })
          .timeout(Duration(milliseconds: 500),
      onTimeout: (){
        print('task added successfully');
        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
        Navigator.pop(context);
        showMyDialog();
      }
      );
    }
}
  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Task'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Task added successfully'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
