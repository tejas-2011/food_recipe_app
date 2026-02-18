import 'api_constants.dart';

class UsedUrls {
  UsedUrls._();

  static String recipeUrl(String query, String appId, String appKey) {
    return '${ApiConstants.edamamBaseUrl}'
        '?${ApiConstants.queryParamType}=${ApiConstants.typePublic}'
        '&${ApiConstants.queryParamQ}=${Uri.encodeComponent(query)}'
        '&${ApiConstants.queryParamAppId}=$appId'
        '&${ApiConstants.queryParamAppKey}=$appKey';
  }

  static String geminiUrl(String apiKey) {
    return '${ApiConstants.geminiBaseUrl}?key=$apiKey';
  }
}