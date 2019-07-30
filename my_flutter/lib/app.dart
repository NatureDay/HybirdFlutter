import 'dart:convert';

import 'util/shared_preferences.dart';

///  应用token信息处理，包括登录之后token信息的存储与读取，删除等
///  全局变量，单例应用
class AppInfoHelper {
  static final String APP_LOGIN_INFO = "APP_LOGIN_INFO";
  static final String APP_USER_INFO = "APP_USER_INFO";

  static AppInfoHelper _sInstance;

  /// 用于存储登录后信息
  Map<String, dynamic> _loginInfo;

  /// 用于存储用户信息
  Map<String, dynamic> _userInfo;

  static AppInfoHelper get instance {
    return _getInstance();
  }

  static AppInfoHelper _getInstance() {
    if (_sInstance == null) {
      _sInstance = new AppInfoHelper();
    }
    return _sInstance;
  }

  /**
   * 获取登录信息
   */
  Map<String, dynamic> getAppLoginInfo() {
    return _loginInfo;
  }

  /**
   * 保存登录信息
   *
   * @param appInfo
   */
  void saveAppLoginInfo(Map<String, dynamic> appInfo) {
    this._loginInfo = appInfo;
    SpUtil.instance.then((value) {
      value.putString(APP_LOGIN_INFO, json.encode(appInfo));
    }, onError: (e) {
      print(e);
    });
  }

  /**
   * 获取token
   *
   * @return
   */
  String getAppToken() {
    if (_loginInfo == null) return "";
    String tokenType = _loginInfo["token_type"];
    String accessToken = _loginInfo["access_token"];
    return "$tokenType $accessToken";
  }

  /**
   * 获取token
   *
   * @return
   */
  String getUserId() {
    if (_userInfo == null) return "";
    return _userInfo["userId"];
  }

  /**
   * 初始化登录数据
   */
  void initAppLoginInfo() {
    SpUtil.instance.then((value) {
      String info = value.getString(APP_LOGIN_INFO);
      this._loginInfo = json.decode(info);
    }, onError: (e) {
      print(e);
    });
  }

  /**
   * 清除登录数据，通常用于退出登录
   */
  void clearAppLoginInfo() {
    this._loginInfo = null;
    SpUtil.instance.then((value) {
      value.remove(APP_LOGIN_INFO);
    }, onError: (e) {
      print(e);
    });
  }

  /**
   * 获取用户信息
   */
  Map<String, dynamic> getUserInfo() {
    return this._userInfo;
  }

  /**
   * 保存用户信息
   *
   * @param appInfo
   */
  void saveUserInfo(Map<String, dynamic> appInfo) {
    this._userInfo = appInfo;
    SpUtil.instance.then((value) {
      value.putString(APP_USER_INFO, json.encode(appInfo));
    }, onError: (e) {
      print(e);
    });
  }

  /**
   * 初始化用户数据
   */
  void initUserInfo() {
    SpUtil.instance.then((value) {
      String info = value.getString(APP_USER_INFO);
      this._userInfo = json.decode(info);
    }, onError: (e) {
      print(e);
    });
  }

  /**
   * 清除用户数据，通常用于退出登录
   */
  void clearUserInfo() {
    this._userInfo = null;
    SpUtil.instance.then((value) {
      value.remove(APP_USER_INFO);
    }, onError: (e) {
      print(e);
    });
  }

  /**
   * 初始化应用数据，包括登录数据与用户数据
   */
  void initAppData() {
    SpUtil.instance.then((value) {
      String loginInfo = value.getString(APP_LOGIN_INFO);
      if (loginInfo != null) {
        this._loginInfo = json.decode(loginInfo);
      }
      String userInfo = value.getString(APP_USER_INFO);
      if (userInfo != null) {
        this._userInfo = json.decode(userInfo);
      }
    }, onError: (e) {
      print(e);
    });
  }

  /**
   * 清除应用数据，通常用于退出登录
   */
  void clearAppData() {
    this._loginInfo = null;
    this._userInfo = null;
    SpUtil.instance.then((value) {
      value.remove(APP_LOGIN_INFO);
      value.remove(APP_USER_INFO);
    }, onError: (e) {
      print(e);
    });
  }

  /**
   * 退出应用
   */
  void exitApp() {
    // EventBus.getDefault().post(new AppExitLoginEvent());
  }
}
