//
//  ScreenErrorView.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import UIKit

class ScreenErrorView: UIViewController {

    public var messageText:String?
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.okButton.layer.backgroundColor = UIColor(red: 1, green: 0.259, blue: 0.251, alpha: 1).cgColor
        self.okButton.layer.cornerRadius = 4
        self.okButton.layer.borderWidth = 1
        self.okButton.layer.borderColor = UIColor(red: 1, green: 0.259, blue: 0.251, alpha: 1).cgColor
        self.messageLabel.text = self.messageText;
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
