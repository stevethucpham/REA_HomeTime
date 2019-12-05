//
//  UIViewControllerExtension.swift
//  HomeTime
//
//  Created by iOS Developer on 12/5/19.
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Display alert view controller
    /// - Parameters:
    ///   - title: The alert title
    ///   - message: The alert message
    ///   - okButtonTitle: The title of button
    func alert(title: String, message: String, okButtonTitle: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let actionOk = UIAlertAction(title: okButtonTitle,
                                        style: .default,
                                        handler: nil)
           
           alert.addAction(actionOk)
           self.present(alert, animated: true, completion: nil)
       }
}
