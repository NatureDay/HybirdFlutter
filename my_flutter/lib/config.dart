/**
 * 应用相关配置类
 */
class AppConfig {

  static final bool DEBUG = true;

  /// 开发环境
  static final String _BASEURL_DEV = "http://192.168.5.184:9999/";

  /// 测试环境
  static final String _BASEURL_TEST = "http://salesman.anb.test.qmant.com/";

  /// 生产环境
  static final String _BASEURL_PRODUCT = "http://192.168.5.108:9132/";

  /// 应用 base url
  static final String baseUrl = _BASEURL_TEST;
}
