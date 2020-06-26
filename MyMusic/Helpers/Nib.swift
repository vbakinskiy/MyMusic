//
//  Nib.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/26/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as! T
    }
}
