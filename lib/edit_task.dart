
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/list_provider.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routeName = '/edit task';

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  DateTime selectedDate = DateTime.now();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var descriptionController =TextEditingController();

  late ListProvider listProvider;
  late Task task;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      task = ModalRoute.of(context)!.settings.arguments as Task;
      titleController.text= task.title!;
      descriptionController.text=task.description!;
      selectedDate = task.dateTime!;
    });

  }

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(height: screenSize.height*0.1,color: MyTheme.appColor,),
          Container(
          //  height: screenSize.height*0.7,
           // width: screenSize.width*0.8,
            margin: EdgeInsets.symmetric(horizontal: screenSize.width*0.1,
                vertical:screenSize.height*0.1 ),
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(20) ,
              color: Colors.white
            ),

            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text('Edit Task',
                  style: Theme.of(context).textTheme.titleLarge,),
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                         controller: titleController ,
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
                          controller: descriptionController,
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
                          editTask();
                        },
                            child: Text('Save Changes' ,
                                style: Theme.of(context).textTheme.titleLarge))

                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    )
      ;
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

  void editTask() {
    if(formKey.currentState!.validate()==true){
      var authProvider = Provider.of<AuthProviders>(context,listen: false);
      task.title= titleController.text;
      task.description=descriptionController.text;
      task.dateTime = selectedDate;
      DialogUtils.showLoading(context: context, message: 'Loading....');
      FireBaseUtils.editTask(task, authProvider.currentUser!.id!).
      then((value) {
        print('Task added successfully');
        //  Navigator.pop(context);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context: context, message: 'Task updated successfully',
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
