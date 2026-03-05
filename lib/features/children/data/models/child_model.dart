class ChildModel {
  final String id;
  final String name;
  final int age;
  final String avatar;

  const ChildModel({
    required this.id,
    required this.name,
    required this.age,
    this.avatar = '',
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id:     (json['_id'] ?? json['id'] ?? '').toString(),
      name:   (json['name'] ?? '').toString(),
      age:    (json['age'] is int)
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      avatar: (json['avatar'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name':   name,
    'age':    age,
    if (avatar.isNotEmpty) 'avatar': avatar,
  };

  ChildModel copyWith({String? name, int? age, String? avatar}) => ChildModel(
    id:     id,
    name:   name ?? this.name,
    age:    age  ?? this.age,
    avatar: avatar ?? this.avatar,
  );
}
