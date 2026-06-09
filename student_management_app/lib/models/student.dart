class Student {
  final int? id;
  final String name;
  final String course;

  Student({this.id, required this.name, required this.course});

  // Convert a Student object into a Map for the database (used in CREATE and UPDATE)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'course': course,
    };
  }

  // Convert a Map from the database back into a Student object (used in READ)
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      course: map['course'],
    );
  }
}