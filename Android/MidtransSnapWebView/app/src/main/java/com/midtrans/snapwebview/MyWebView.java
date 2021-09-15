package com.midtrans.snapwebview;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.AppCompatButton;

public class MyWebView extends AppCompatActivity {

    AppCompatButton btnCloseSnap;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_web_view);
        btnCloseSnap = findViewById(R.id.btn_closeSnap);
        btnCloseSnap.setOnClickListener(view -> {
            Intent intent = new Intent(this, MainActivity.class);
            startActivity(intent);
        });

        Intent in = getIntent();
        String url = in.getStringExtra("URL");

        openUrlFromWebView(url);
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void openUrlFromWebView(String url) {
        WebView webView = findViewById(R.id.myWebView);
        webView.setWebViewClient(new WebViewClient() {
            final ProgressDialog pd = new ProgressDialog(MyWebView.this);
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                String requestUrl = request.getUrl().toString();
                if (requestUrl.contains("gojek://")
                        || requestUrl.contains("shopeeid://")
                        || requestUrl.contains("//wsa.wallet.airpay.co.id/")

                        // This is handle for sandbox Simulator
                        || requestUrl.contains("/gopay/partner/")
                        || requestUrl.contains("/shopeepay/")) {

                    final Intent intent = new Intent(Intent.ACTION_VIEW, request.getUrl());
                    startActivity(intent);
                    // `true` means for the specified url, will be handled by OS by starting Intent
                    return true;
                } else {
                    // `false` means any other url will be loaded normally by the WebView
                    return false;
                }
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon)
            {
                pd.setMessage("loading");
                pd.show();
                super.onPageStarted(view, url, favicon);
            }

            @Override
            public void onPageFinished(WebView view, String url)
            {
                pd.hide();
                super.onPageFinished(view, url);
            }
        });

        webView.getSettings().setLoadsImagesAutomatically(true);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.setScrollBarStyle(View.SCROLLBARS_INSIDE_OVERLAY);
        webView.loadUrl(url);
    }
}