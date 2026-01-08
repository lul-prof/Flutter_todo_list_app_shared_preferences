class Todo{
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted=false,
    DateTime? createdAt,
  }) : createdAt=createdAt  ?? DateTime.now();

  // Convert Todo to Map for database
  Map<String,dynamic>toJson(){
    return{
      'id':id,
      'title':title,
      'description':description,
      'isCompleted':isCompleted,
      'createdAt':createdAt.toIso8601String(),
    };
  }

  //Create a todo from map for UI

  factory Todo.fromJson(Map<String,dynamic>map){
    return Todo(
      id:map['id'],
      title:map['title'],
      description:map['description'],
      isCompleted:map['isCompleted']??false,
      createdAt:DateTime.parse(map['createdAt']),
    );
  }
 
}