import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFFFFC700);
const secondaryColor = Color(0xFF8D92A3);
const dangerColor = Color(0xFFD9435E);
const warningColor = Color(0xFFf0ad4e);
const successColor = Color(0xFF1ABC9C);
const textColor = Color(0xFF020202);
const ratingActiveColor = Color(0xFFFFC700);
const ratingColor = Color(0xFFECECEC);

Color baseColorLazyLoad = Colors.grey.shade300;
Color highlightColorLazyLoad = Colors.grey.shade100;

const FULLNAME_ERROR_REQUIRED = 'Full Name is required!';
const EMAIL_ERROR_REQUIRED = 'Email is required!';
const EMAIL_ERROR_INVALID = 'Email is invalid!';
const PASSWORD_ERROR_REQUIRED = 'Password is required!';
const PASSWORD_ERROR_6_LENGTH = 'Password minimum 6 characters!';
const PHONE_NUMBER_REQUIRED = 'Phone Number is required!';
const ADDRESS_REQUIRED = 'Address is required!';
const HOUSE_NUMBER_REQUIRED = 'House Number is required!';
const CITY_REQUIRED = 'City is required!';
const FAILED_TO_NETWORK =
    'An error occurred!. Please check your connection'; // message failed get data from network
const TIMEOUT_MESSAGE = 'Server connection lost!';
const EMPTY_DATA_MESSAGE = 'No data!';
const EXEPTION_ERROR = "An error occurred!";

const PREFERENCE_USER = "user";
const TOKEN_USER = "token";
const TOKEN_TYPE = 'token_type';

const defaultDuration = Duration(milliseconds: 250);
const durationNotification = Duration(milliseconds: 1500);
const defaultDurationCallAPI = Duration(milliseconds: 500);
const Duration durationTimeout = Duration(seconds: 10);
Future<Response> onTimeout() async {
  throw TimeoutException(TIMEOUT_MESSAGE);
}

const API_URL = 'https://foodmarket.aquastoreid.com/api/v1/';
