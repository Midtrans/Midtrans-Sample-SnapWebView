//
//  MyWebViewController.swift
//  midtrans-snap-WebView-sample
//
//  Created by Zaki Ibrahim on 14/09/21.
//

import UIKit
import WebKit

class MyWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var selectedName: String = ""

    @IBOutlet weak var webView: WKWebView!
    
    private var activityIndicatorContainer: UIView!
    private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var urlS : URL
        
        // Get URL from text field, if empty get Snap URL from Sample web
        if !selectedName.isEmpty {
            urlS = URL(string: selectedName)!
        } else {
            urlS = URL(string: "https://sample-demo-dot-midtrans-support-tools.et.r.appspot.com/snap-redirect")!
        }

        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.load(URLRequest(url: urlS))
    }
    

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
    
    // Loading animator
    fileprivate func setActivityIndicator() {
        activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicatorContainer.center.x = webView.center.x
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
