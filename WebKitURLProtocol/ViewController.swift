//
//  ViewController.swift
//  WebKitURLProtcol
//
//  Created by 冨平準喜 on 2020/05/30.
//  Copyright © 2020 冨平準喜. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UIWebViewDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tableView: UITableView!
    
    private var resposes = [URLResponse]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLProtocol.registerClass(WebKitURLProtocol.self)
        URLProtocol.wk_register(scheme: "https")
        URLProtocol.wk_register(scheme: "http")
        
        webView.load(URLRequest(url: URL(string: "https://github.com/tommy19970714/WebKitURLProtocol")!))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateNetworkLog), name: .didReceiveURLResponse, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let types = Set([WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: date, completionHandler: {
            
        })
    }
    
    @objc func updateNetworkLog(notification: NSNotification) {
        if let response = notification.userInfo?["response"] as? URLResponse {
            DispatchQueue.main.async {
                self.resposes.append(response)
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Network Logs"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resposes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkLogCell", for: indexPath)
        cell.textLabel?.text = resposes[indexPath.row].url?.absoluteString
        cell.detailTextLabel?.text = resposes[indexPath.row].mimeType
        return cell
    }
}

