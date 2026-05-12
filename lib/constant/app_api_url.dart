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
  const String liveServer = "https://alioorowbackend.mtscorporate.com";
  const String localServer = "https://alioorowbackend.mtscorporate.com";

  try {
    if (kDebugMode) {
      return localServer;
    }
  } catch (e) {
    errorLog("_getDomain", e);
  }
  return liveServer;
}
