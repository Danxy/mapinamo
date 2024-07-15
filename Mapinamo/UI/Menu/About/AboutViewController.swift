//
//  AboutViewController.swift
//  Mapinamo
//
//  Created by Daniel on 12.10.2022.
//  Copyright © 2022 Db. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVersion()
    }
    
    private func setupVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "v. " + version
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func openStringUrl(_ string: String) {
        if let url = URL(string: string) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func supportButtonAction(_ sender: UIButton) {
        openStringUrl("mailto:mapinamo.sup@gmail.com")
    }
    
    @IBAction func webButtonAction(_ sender: UIButton) {
        openStringUrl("https://www.mapinamo.com")
    }
    
    @IBAction func termsButtonAction(_ sender: UIButton) {
        openStringUrl("https://mapinamo-docs.s3-eu-west-1.amazonaws.com/Terms+and+Conditions.pdf")
    }
    
    @IBAction func policyButtonAction(_ sender: UIButton) {
        openStringUrl("https://mapinamo-docs.s3-eu-west-1.amazonaws.com/Privacy+policy.pdf")
        
    }
}
