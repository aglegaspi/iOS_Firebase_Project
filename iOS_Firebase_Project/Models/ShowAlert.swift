//
//  ShowAlert.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/13/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//

import Foundation
import UIKit

struct ShowAlert {
    static func showAlert(with title: String, and message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertVC
    }
}
