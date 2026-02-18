class ApiConstants {
  ApiConstants._();

  static const String edamamBaseUrl = 'https://api.edamam.com/api/recipes/v2';
  static const String baseUrl = edamamBaseUrl;
  static const String accountUserHeader = 'Edamam-Account-User';
  static const String queryParamType = 'type';
  static const String queryParamQ = 'q';
  static const String queryParamAppId = 'app_id';
  static const String queryParamAppKey = 'app_key';
  static const String queryParamHealth = 'health';
  static const String typePublic = 'public';

  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
}
