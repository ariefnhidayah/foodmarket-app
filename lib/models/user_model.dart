import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final String email;
  final String profilePhotoPath;
  final String address;
  final String houseNumber;
  final String phoneNumber;
  final String city;

  const UserModel({
    required this.name,
    required this.email,
    required this.profilePhotoPath,
    required this.address,
    required this.houseNumber,
    required this.phoneNumber,
    required this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'],
        email: json['email'],
        profilePhotoPath: json['profile_photo_path'],
        address: json['address'],
        houseNumber: json['house_number'],
        phoneNumber: json['phone_number'],
        city: json['city'],
      );

  @override
  String toString() {
    return '{"name": "$name", "email": "$email", "profile_photo_path": "$profilePhotoPath", "address": "$address", "house_number": "$houseNumber", "phone_number": "$phoneNumber", "city": "$city"}';
  }

  @override
  List<Object?> get props => [
        name,
        email,
        profilePhotoPath,
        address,
        houseNumber,
        phoneNumber,
        city,
      ];
}
