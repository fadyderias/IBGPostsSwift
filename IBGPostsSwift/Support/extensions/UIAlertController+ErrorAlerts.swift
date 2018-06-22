//
//  UIAlertController+ErrorAlerts.swift
//  IBGPostsSwift
//
//  Created by Fady on 6/22/18.
//  Copyright © 2018 instabug. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func alertControllerWithTitle(title: String, message: String, _ handler: @escaping (() -> Void)) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (alertAction) in
            handler()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}
