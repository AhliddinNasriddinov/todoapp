
class Task{
  int? id;
  String? title;
  DateTime date;
  String? priorty;
  int? status = 0;


  Task({ required this.title,required this.date, required this.priorty});

  Task.withId({
    this.id,
    this.status,
    required this.title,
    required this.date,
    required this.priorty
});


  Map<String, dynamic>toMap(){
   final map = Map<String,dynamic>();
   if (id != null){
     map['id'] = id;
   }
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['status'] = status;
    map['priorty']  = priorty;
    return map;
  }

 factory Task.fromMap(Map<String,dynamic> map){
   return Task.withId(
       id: map['id'],
       title: map['title'],
       date: DateTime.parse(map['date']),
       priorty: map['priorty'],
       status: map['status']
   );
  }
}