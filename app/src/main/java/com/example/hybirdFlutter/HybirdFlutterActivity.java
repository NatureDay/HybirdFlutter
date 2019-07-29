package com.example.hybirdFlutter;

import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.ViewGroup;
import android.view.Window;

import io.flutter.facade.Flutter;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.view.FlutterView;

public class HybirdFlutterActivity extends AppCompatActivity {

    private FlutterView mFlutterView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        supportRequestWindowFeature(Window.FEATURE_NO_TITLE);
        initView();

        initBridge();
    }

    private void initView() {
        mFlutterView = Flutter.createView(
                HybirdFlutterActivity.this,
                getLifecycle(),
                "route1"
        );
        addContentView(mFlutterView, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    private void initBridge() {
        BasicMessageChannel basicMessageChannel = new BasicMessageChannel(mFlutterView, "BasicMessageChannel", StringCodec.INSTANCE);

        basicMessageChannel.setMessageHandler(new BasicMessageChannel.MessageHandler<String>() {
            @Override
            public void onMessage(@Nullable String s, @NonNull BasicMessageChannel.Reply<String> reply) {
                //第一个参数就是dart端发送过来的消息
                reply.reply("basicMessageChannel收到消息");//可以通过reply回复消息
            }
        });

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                basicMessageChannel.send("发送给dart端的消息", new BasicMessageChannel.Reply<String>() {
                    @Override
                    public void reply(@Nullable String s) {//来自dart的反馈
                        Log.e("fff", "---------reply==========" + s);
                    }
                });
            }
        }, 5000);


        MethodChannel methodChannel = new MethodChannel(mFlutterView, "methodChannel");
        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
                if (methodCall.method.equals("getName")) {
                    result.success("aaa");
                }
            }
        });
    }

    @Override
    public void onBackPressed() {
        if (mFlutterView != null) {
            mFlutterView.popRoute();
        } else {
            super.onBackPressed();
        }
    }
}
