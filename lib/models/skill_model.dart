class SkillModel {
  final String id;
  final String skillName;
  final String category;

  SkillModel({required this.id, required this.skillName, required this.category});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'],
      skillName: json['skill_name'],
      category: json['category'] ?? '',
    );
  }
}