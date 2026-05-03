import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class AppApiUrl {
  AppApiUrl._privateConstructor();
  static final AppApiUrl _instance = AppApiUrl._privateConstructor();
  static AppApiUrl get instance => _instance;

  static final String domain = _getDomain();
  static final String socket = _getDomain();
  final String baseUrl = "$domain/api/v1";

  // auth
  String refreshToken = "/refreshToken";
  String userProfile = "/user/profile";
  String login = "/login";
  String authDeleteAccount = "/authDeleteAccount";
  String user = "/user";
  String changePassword = "/changePassword";
  String userResendOtp = "/userResendOtp";
  String authOtpVerify = "/authOtpVerify";
  String authForgotPassword = "/authForgotPassword";
  String authVerifyEmail = "/authVerifyEmail";
  String authResetPassword = "/authResetPassword";

  // content
  String about = "/pages/type/ABOUT";
  String privacyPolicy = "/pages/type/PRIVACY_POLICY";
  String termsAndConditions = "/pages/type/TERMS_CONDITIONS";
  String faq = "/pages/faqs"; 
  String notification = "/notification";

  // shop
  String products = "/products";
  String categories = "/categories";
}

String _getDomain() {
  const String liveServer =
      "http://yvx4wx0kqox6pyo91wsslyu8.147.93.107.217.sslip.io";
  const String localServer = "http://10.10.7.8:6008";

  try {
    if (kDebugMode) {
      localServer;
      // return localServer;
    }
  } catch (e) {
    errorLog("_getDomain", e);
  }
  return liveServer;
}
