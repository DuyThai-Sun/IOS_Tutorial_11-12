//
//  ReuseableViewExtension.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thai on 21/12/2022.
//

import Foundation
import UIKit

extension ReusableTableViewCell where Self : UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}

extension UITableView {
    func register<T: UITableViewCell>(nibName name: T.Type, atBundle bundleClass: AnyClass? = nil) where T: ReusableTableViewCell {
        let identifier = T.defaultReuseIdentifier
        let nibName = T.nibName
        var bundle: Bundle? = nil
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T where T: ReusableTableViewCell {
        guard let cell =  self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}
