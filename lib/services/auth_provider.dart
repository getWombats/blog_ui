import 'dart:convert';
import 'dart:io';

import 'package:blog_test/constants/app_constants.dart';
import 'package:blog_test/services/storage_service.dart';
import 'package:blog_test/model/blog_user.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthState {
  static final AuthState instance = AuthState._init();
  AuthState._init();

  BlogUser _user = BlogUser();
  final String _baseUrl =
      '${Platform.isAndroid ? GlobalConfiguration().getValue(ConfigKeyName.LOCAL_IP_ANDROID) : GlobalConfiguration().getValue(ConfigKeyName.LOCAL_IP)}:${GlobalConfiguration().getValue(ConfigKeyName.KEYKLOAK_PORT)}';
  final String clientId =
      GlobalConfiguration().getValue(ConfigKeyName.CLIENT_ID);
  final String clientSecret =
      GlobalConfiguration().getValue(ConfigKeyName.CLIENT_SECRET);

  final _storageService = StorageService.instance;

  BlogUser get userInfo => _user;

  void _setUser(BlogUser user) {
    _user = user;
  }

  void logout() {
    _user = BlogUser();
    _storageService.removeValue(TokenKeyName.ACCESS_TOKEN);
    _storageService.removeValue(TokenKeyName.REFRESH_TOKEN);
  }

  Future<bool> get isAuthenticated async {
    final accessToken =
        await _storageService.readValue(TokenKeyName.ACCESS_TOKEN);

    if (accessToken == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> tryLogin(String username, String password) async {
    // final user = await _authenticate(email, password);
    bool success = username == 'alice' && password == 'alice';

    if (success) {
      final user = BlogUser();
      user.email = 'alice@bubu.com';
      user.roles = ['user', 'admin'];
      user.username = username;
      user.id = '1';

      _setUser(user);
      return true;
    }

    // if (user != null) {
    //   _setUser(user);
    //   return true;
    // }
    return false;
  }

  Future<BlogUser?> _authenticate(String email, String password) async {
    var response = await http.post(
      Uri.parse('http://$_baseUrl/realms/blog/protocol/openid-connect/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'password',
        'username': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var tokenMap = _getDecodedTokenFromResponseBody(response.body);
      BlogUser user = BlogUser.fromMap(tokenMap[TokenKeyName.DECODED_TOKEN]);
      await _saveTokenToSecureStore(tokenMap[TokenKeyName.ACCESS_TOKEN],
          tokenMap[TokenKeyName.REFRESH_TOKEN]);

      return user;
    }

    return null;
  }

  Future<void> _saveTokenToSecureStore(
      String token, String refreshToken) async {
    await _storageService.writeValue(TokenKeyName.ACCESS_TOKEN, token);
    await _storageService.writeValue(TokenKeyName.REFRESH_TOKEN, refreshToken);
  }

  Map<String, dynamic> _getDecodedTokenFromResponseBody(String responseBody) {
    var jsonResponse = jsonDecode(responseBody);
    String accessToken = jsonResponse[TokenKeyName.ACCESS_TOKEN];
    String refreshToken = jsonResponse[TokenKeyName.REFRESH_TOKEN];
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

    Map<String, dynamic> tokenMap = {
      'decoded_token': decodedToken,
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };

    return tokenMap;
  }
}
