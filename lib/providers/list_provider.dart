

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';

class ListProvider  extends ChangeNotifier{
  List <Task> tasksList = [];
  DateTime selectedDate = DateTime.now();

  void getAllTasksFromFireStore(String uId)async{
    QuerySnapshot<Task> querySnapshot = await FireBaseUtils.getTasksCollection(uId).get();
    tasksList = querySnapshot.docs.map((doc) {
      return  doc.data();
    }).toList();
  tasksList =  tasksList.where((task) {
      if(selectedDate.day == task.dateTime!.day &&
      selectedDate.month == task.dateTime!.month&&
      selectedDate.year == task.dateTime!.year) {
        return true;
      }
      return false;
    }).toList();
    tasksList.sort( (task1, task2){
     return task1.dateTime!.compareTo(task2.dateTime!);
    });

    notifyListeners();
  }

  void changeSelectedDate (DateTime  newSelectedDate , String uId){
    selectedDate =  newSelectedDate ;
    getAllTasksFromFireStore(uId);

  }
}