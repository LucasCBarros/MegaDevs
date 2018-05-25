//
//  Extensions.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String, completionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: completionHandler))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    
    // Personal Colors
    func UIBlack() -> UIColor {
        let UIBlack = UIColor(red: 40/255, green: 43/255, blue: 53/255, alpha: 1.0)
        return UIBlack
    }
    
    func UIGreen() -> UIColor {
        let UIGreen = UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1.0)
        return UIGreen
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    var millisecondsSinceNow: Int64 {
        return Int64((self.timeIntervalSinceNow * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
