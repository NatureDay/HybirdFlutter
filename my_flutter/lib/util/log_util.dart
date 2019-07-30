import '../config.dart';

class LogUtil {
  static final bool debug = AppConfig.DEBUG;

  static i(Object object) {
    print(object);
  }
}
