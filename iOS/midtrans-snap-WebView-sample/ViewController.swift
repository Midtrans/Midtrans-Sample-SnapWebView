//
//  ViewController.swift
//  midtrans-snap-WebView-sample
//
//  Created by Zaki Ibrahim on 06/08/21.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBOutlet weak var tfLink: UITextField!
    
    // Open Snap URL from WKWebVIew
    @IBAction func btnSnapOpen(_ sender: Any) {
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myWebViewController" {
                let controller = segue.destination as! MyWebViewController
                controller.selectedName = tfLink.text!
            
        }
    }
    


}
