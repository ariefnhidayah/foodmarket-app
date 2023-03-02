import 'package:equatable/equatable.dart';

class ResponseModel<T> extends Equatable {
  final bool success;
  final T? data;
  final String message;
  final int statusCode;

  const ResponseModel({
    required this.success,
    this.data,
    this.message = '',
    this.statusCode = 500,
  });

  @override
  List<Object?> get props => [success, data, message];
}
