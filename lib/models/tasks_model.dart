class TasksModel {
  int? id;
  String? title;
  String? content;
  String? date;
  String? time;
  String? priority;
  int isDone; // Assuming this is an integer (e.g., 0 or 1)

  TasksModel({
    this.id,
    this.title,
    this.content,
    this.date,
    this.time,
    this.priority,
    this.isDone = 0,
  });

  factory TasksModel.fromMap(Map<String, dynamic> map) {
    return TasksModel(
      id: map['id'],
      title: map['task'],
      content: map['content'],
      date: map['date'],
      time: map['time'],
      priority: map['priority'],
      isDone: map['isDone'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': title,
      'content': content,
      'date': date,
      'time': time,
      'priority': priority,
      'isDone': isDone,
    };
  }
}
