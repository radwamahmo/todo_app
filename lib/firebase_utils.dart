import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/model/task.dart';

class FireBaseUtils{
  static CollectionReference<Task> getTasksCollection(String uId){
   return getUsersCollection().doc(uId)
   .collection(Task.collectionName).
    withConverter<Task>(
        fromFirestore: ((snapshot,options)=> Task.fromFireStore(snapshot.data()!)) ,
    toFirestore: (task,_)=> task.toFireStore()
   );
  }


  static Future<void> addTaskToFireStore(Task task, String uId){
    CollectionReference<Task> taskCollection =  getTasksCollection(uId);
    DocumentReference<Task> taskDocRef=   taskCollection.doc();
    task.id = taskDocRef.id ;
   return taskDocRef.set(task);


  }


  static Future<void> deleteTaskFromFireStore(Task task , String uId){
   return getTasksCollection(uId).doc(task.id).delete();
  }


  static CollectionReference<MyUser> getUsersCollection(){
  return  FirebaseFirestore.instance.collection(MyUser.collectionName).
    withConverter(
        fromFirestore: ((snapshot, options)=> MyUser.fromFireStore(snapshot.data())),
        toFirestore: (user,_)=> user.toFireStore()
    );
  }
  static Future<void> editIsDone(Task task,String uId){
    return getTasksCollection(uId).doc(task.id).update(task.toFireStore());
  }

  static Future<void> editTask(Task task,String uId){
    return getTasksCollection(uId).doc(task.id).update({
      'IsDone' : task.isDone
    });
  }


  static Future <void> addUserToFireStore(MyUser myUser){
  return  getUsersCollection().doc(myUser.id).set(myUser);
  }

  static   Future<MyUser?>  readUserFromFireStore(String uId)async{
  var querySnapShot= await  getUsersCollection().doc(uId).get();
 return querySnapShot.data();
  }

}