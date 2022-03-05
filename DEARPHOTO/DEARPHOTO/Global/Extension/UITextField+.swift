//
//  UITextField+.swift
//  DEARPHOTO
//
//  Created by InJe Choi on 2022/03/05.
//

import UIKit

extension UITextField {
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
    
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
}
