#Midtrans Sample SNAP in Android & iOS WebView/WKWebView

if your mobile app is using WebView to display Snap, this is sample project that you can use to try open Snap using webview. 
You can try the demo apps from our [simulator](https://sample-demo-dot-midtrans-support-tools.et.r.appspot.com/snap-webview)

You need to make sure the app follows the points given below.
- Enable JavaScript capability for the WebView.
- Allow WebView to open bank web domain. For Android,the app is available in Java.
[Android Sample Code](https://github.com/Midtrans/Midtrans-Sample-SnapWebView/blob/main/Android/MidtransSnapWebView/app/src/main/java/com/midtrans/snapwebview/MyWebView.java#L40-L86)
```java
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
```

- For iOS, the app is available in Swift [iOS Sample Code](https://github.com/Midtrans/Midtrans-Sample-SnapWebView/blob/main/iOS/midtrans-snap-WebView-sample/MyWebViewController.swift#L38-L54)
```swift
    // WKWebView Configuration
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        // detect these specified deeplinks and e_money simulator to be handled by OS
        if url!.absoluteString.hasPrefix("https://simulator.sandbox.midtrans.com/gopay/partner/")
            || url!.absoluteString.hasPrefix("https://simulator.sandbox.midtrans.com/shopeepay/")
            || url!.absoluteString.hasPrefix("shopeeid://")
            || url!.absoluteString.hasPrefix("gojek://")
            || url!.absoluteString.hasPrefix("//wsa.wallet.airpay.co.id/") {
            decisionHandler(.cancel)
            UIApplication.shared.open(url!)
            
        // any other url will be loaded normally by the WebView
        } else {
            decisionHandler(.allow)
        }
    }
```

A lot of payment methods within Snap, redirect the customer to the bank's website. Your mobile developer needs to ensure that the app allows WebView to open the bank's website domains. All domains needs to be whitelisted, as the customers can use any issuing bank credit card with any website domain.
For testing or on Sandbox environment, allow WebView to open Midtrans simulator domain: https://simulator.midtrans.com. Those configs may found on app config/manifest. Or specific code when calling WebView.