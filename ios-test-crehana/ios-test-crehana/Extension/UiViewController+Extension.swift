//
//  UiViewController+Extension.swift
//  ios-test-crehana
//
//  Created by Miguel on 2/10/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showError( message:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) as UIStoryboard
        var viewController:UIViewController?

        viewController = storyboard.instantiateViewController(withIdentifier: "ScreenErrorView") as! ScreenErrorView
        (viewController as! ScreenErrorView).messageText = message
        guard let errorViewController = viewController else { return }
        self.present(errorViewController, animated: true, completion: nil)
    }
}
