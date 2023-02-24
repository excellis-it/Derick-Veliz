import 'dart:core';

class BaseApi {
  static const String baseUrl = 'https://excellis.co.in/derick-veliz-admin/';
  static const apiVersion = 'api/v1';
  static const String cmsGetStarted = '$baseUrl$apiVersion/cms/get-started';
  static const String userUploadProfileImage =
      '$baseUrl$apiVersion/user/upload-profile-image';
  static const String userGetProfileImage =
      '$baseUrl$apiVersion/user/get-profile-image';

  static const String forgotPasswordApi =
      '$baseUrl$apiVersion/user/submit-forget-password';
  static const String otpVerify = '$baseUrl$apiVersion/user/submit-otp?';
  static const String changePasswordApi =
      '$baseUrl$apiVersion/user/reset-password?';
}
