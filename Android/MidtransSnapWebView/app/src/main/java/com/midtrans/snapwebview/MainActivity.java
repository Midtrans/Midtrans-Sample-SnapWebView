package com.midtrans.snapwebview;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private Button btnSnapShow;
    private EditText edtSnapUrl;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        bindView();

        btnSnapShow.setOnClickListener(v -> openUrlFromWebView());
    }

    private void bindView() {
        btnSnapShow = findViewById(R.id.btn_showSnap);
        edtSnapUrl = findViewById(R.id.et_snap_url);
    }

    private String getUrl() {
        if (edtSnapUrl.getText().toString().isEmpty()) {
            return "https://sample-demo-dot-midtrans-support-tools.et.r.appspot.com/snap-redirect/";
        } else {
            return edtSnapUrl.getText().toString();
        }
    }

    private void openUrlFromWebView() {
//        final ProgressDialog pd = new ProgressDialog(MainActivity.this);
//        pd.show();
        Intent intent = new Intent(this, MyWebView.class);
        intent.putExtra("URL", getUrl());
        startActivity(intent);
    }
}