
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/authentication/login/login_screen.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/providers/app_config_provider.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/settings/settings_tab.dart';
import 'package:todo_app/task_list/add_task_bottom_sheet.dart';
import 'package:todo_app/task_list/task_list_tab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomeScreen extends StatefulWidget {
  static const String routeName = 'home screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedindex= 0;
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProviders>(context);
    var listProvider = Provider.of<ListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);

    return Scaffold(

      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height*0.15,
              actions: [
                IconButton(onPressed: (){
                  listProvider.tasksList=[];
                  authProvider.currentUser=null;
                  Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                }, icon: Icon(Icons.logout))
              ],

              title: Text( 'To Do List{${authProvider.currentUser!.name}}',
              style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            bottomNavigationBar: BottomAppBar(

              shape: CircularNotchedRectangle(),
              notchMargin: 8 ,
              child: BottomNavigationBar(
                currentIndex: selectedindex,
                onTap: (index){
                  selectedindex = index;
                  setState(() {

                  });
                },
                     items: [
                           BottomNavigationBarItem(icon: Icon(Icons.list),
                               label: AppLocalizations.of(context)!.task_list),
                           BottomNavigationBarItem(icon: Icon(Icons.settings),
                               label: AppLocalizations.of(context)!.settings ),
                         ],
                       ),
                     ),
                     floatingActionButton: FloatingActionButton(
                         onPressed: (){
                           ShowAddTaskBottomSheet();
                         },
                       child: Icon(Icons.add, size: 35,),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(35) ,
                         side: BorderSide(
                           color: Colors.white,
                           width: 3
                         )
                       ),
                     ),
                     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                     body: selectedindex ==0 ? TaskListTab() : SettingsTab()
                     // tabs[selectedindex],
                   );
                  }

                  List<Widget> tabs = [TaskListTab(),SettingsTab()];

                  void ShowAddTaskBottomSheet(){

                      showModalBottomSheet(
                        context: context,
                        builder: (context)=> AddTaskBottomSheet(),
                      );

  }
}
