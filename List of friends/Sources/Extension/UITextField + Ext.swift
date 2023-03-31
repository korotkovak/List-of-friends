//
//  UITextField + Ext.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import UIKit

extension UITextField {
    func setLeftIcon(_ image: UIImage) {
        let iconView = UIImageView(
            frame: CGRect(x: 20, y: 5, width: 20, height: 20)
        )
        
        iconView.image = image
        iconView.tintColor = .systemGray2
        
        let iconContainerView: UIView = UIView(
            frame: CGRect(x: 20, y: 0, width: 50, height: 30)
        )
        
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setRightIcon(_ image: UIImage) {
        let iconView = UIImageView(
            frame: CGRect(x: 10, y: 5, width: 20, height: 20)
        )
        
        iconView.image = image
        iconView.tintColor = .systemGray2
        
        let iconContainerView: UIView = UIView(
            frame: CGRect(x: 20, y: 0, width: 50, height: 30)
        )
        
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightViewMode = .always
    }
}
