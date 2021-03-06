<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/black">

    <com.qianmo.common.gallery.view.HackyViewPager
        android:id="@+id/view_pager"
        android:layout_width="match_parent"
        android:layout_height="match_parent" />

    <RelativeLayout
        android:id="@+id/top_area"
        android:layout_width="match_parent"
        android:layout_height="69dp"
        android:background="@color/mainColor"
        android:clickable="true"
        android:focusable="true"
        android:paddingTop="25dp">

        <android.support.v7.widget.AppCompatImageView
            android:id="@+id/back"
            android:layout_width="@dimen/app_bar_height"
            android:layout_height="@dimen/app_bar_height"
            android:padding="10dp"
            app:srcCompat="@drawable/ic_navigation_icon_white" />

        <android.support.v7.widget.AppCompatTextView
            android:id="@+id/delete"
            style="@style/AppTextStyleWhite_14"
            android:layout_width="wrap_content"
            android:layout_height="@dimen/app_bar_height"
            android:layout_alignParentEnd="true"
            android:layout_alignParentRight="true"
            android:gravity="center"
            android:paddingLeft="@dimen/app_horizontal_padding"
            android:paddingRight="@dimen/app_horizontal_padding"
            android:text="@string/delete" />
    </RelativeLayout>

</FrameLayout>













                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            