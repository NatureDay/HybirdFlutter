package com.example.hybirdFlutter;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.ViewGroup;
import android.view.Window;

import io.flutter.facade.Flutter;
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

    private void initBridge(){

    }
}
