import 'package:flutter/services.dart'; //需要导入包

/// 与native进行通信
class Bridge {
  static const BasicMessageChannel _basicMessageChannel =
      BasicMessageChannel('BasicMessageChannel', StringCodec());

  static const MethodChannel _methodChannel = MethodChannel('methodChannel');

  //使用BasicMessageChannel接收来自native的消息，并向native回复
  void reviceData() {
    _basicMessageChannel.setMessageHandler(_handlerMessage);
  }

  Future<String> _handlerMessage(message) async {
    print("--------_handlerMessage------");
    return '收到native的消息${message}';
  }

//使用BasicMessageChannel向native发送消息，并接收native的回复
  void sendMessage() async {
    //response为native回复的消息
    try {
      String response = await _basicMessageChannel.send('发送给native的消息');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  //使用BasicMessageChannel接收来自native的消息，并向native回复
  void reviceData2() {
    _methodChannel.setMethodCallHandler(platformCallHandler);
  }

  Future<dynamic> platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "getName":
        return "Hello from Flutter";
        break;
    }
  }

//使用BasicMessageChannel向native发送消息，并接收native的回复
  Future<T> sendMessage2d<T>() async {
    return _methodChannel.invokeMethod("getName");
  }
}
