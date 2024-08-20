import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

class UserModelLoading extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final int id;
  final String email;
  final String authProvider;
  final String memberStatus;
  final String? name;
  final int? age;
  final String? job;
  final String? challenges;
  final String? gender;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    required this.authProvider,
    required this.memberStatus,
    this.name,
    this.age,
    this.job,
    this.challenges,
    this.gender,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.lastLoginAt,
  });

  // JSON 데이터를 UserModel 인스턴스로 변환
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // UserModel 인스턴스를 JSON 데이터로 변환
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
