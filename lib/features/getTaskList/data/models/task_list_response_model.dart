


class TaskListResponseModel {
  
    String? id;
  String? createdAt;
  String? dueDate;
  bool? taskStatus;
  String? taskTitle;
  String? taskDescription;


  TaskListResponseModel(
      {this.createdAt,
      this.dueDate,
      this.taskStatus,
      this.taskTitle,
      this.taskDescription,
      this.id});

  TaskListResponseModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    dueDate = json['dueDate'];
    taskStatus = json['taskStatus'];
    taskTitle = json['taskTitle'];
    taskDescription = json['taskDescription'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['dueDate'] = this.dueDate;
    data['taskStatus'] = this.taskStatus;
    data['taskTitle'] = this.taskTitle;
    data['taskDescription'] = this.taskDescription;
    data['id'] = this.id;
    return data;
  }
}
