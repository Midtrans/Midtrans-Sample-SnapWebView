//
//  ViewController.swift
//  midtrans-snap-WebView-sample
//
//  Created by Zaki Ibrahim on 06/08/21.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    
    private var activityIndicatorContainer: UIView!
    private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // WKWebView Configuration
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if url!.absoluteString.hasPrefix("https://simulator.sandbox.midtrans.com/gopay/partner/")
            || url!.absoluteString.hasPrefix("https://simulator.sandbox.midtrans.com/shopeepay/")
            || url!.absoluteString.hasPrefix("shopeeid://")
            || url!.absoluteString.hasPrefix("gojek://")
            || url!.absoluteString.hasPrefix("//wsa.wallet.airpay.co.id/") {
            
            decisionHandler(.cancel)
            UIApplication.shared.open(url!)
        } else {
            decisionHandler(.allow)
        }
    }
    
    @IBOutlet weak var tfLink: UITextField!
    
    // Open Snap URL from WKWebVIew
    @IBAction func btnSnapOpen(_ sender: Any) {
        
        // Get URL from text field, if empty get Snap URL from Sample web
        var url: URL
        if let snapUrl = tfLink.text, !snapUrl.isEmpty
        {
            url = URL(string: snapUrl)!
        } else {
            url = URL(string:  "https://sample-demo-dot-midtrans-support-tools.et.r.appspot.com/snap-redirect")!
        }
        
        // Initiate WKWebView and Open URL
        webView = WKWebView()
        webView.frame = view.bounds
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
    }
    
    
    // Loading animator
    fileprivate func setActivityIndicator() {
        // Configure the background containerView for the indicator
        activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicatorContainer.center.x = webView.center.x
        // Need to subtract 44 because WebKitView is pinned to SafeArea
        //   and we add the toolbar of height 44 programatically
        activityIndicatorContainer.center.y = webView.center.y - 44
        activityIndicatorContainer.backgroundColor = UIColor.black
        activityIndicatorContainer.alpha = 0.8
        activityIndicatorContainer.layer.cornerRadius = 10
      
        // Configure the activity indicator
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorContainer.addSubview(activityIndicator)
        webView.addSubview(activityIndicatorContainer)
        
        // Constraints
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor).isActive = true
      }
    
    // Helper function to control activityIndicator's animation
      fileprivate func showActivityIndicator(show: Bool) {
        if show {
          activityIndicator.startAnimating()
        } else {
          activityIndicator.stopAnimating()
          activityIndicatorContainer.removeFromSuperview()
        }
      }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      self.showActivityIndicator(show: false)
    }
      
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      // Set the indicator everytime webView started loading
      self.setActivityIndicator()
      self.showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      self.showActivityIndicator(show: false)
    }

}
