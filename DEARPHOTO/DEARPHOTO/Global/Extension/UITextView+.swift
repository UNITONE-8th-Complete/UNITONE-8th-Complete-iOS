//
//  UITextView+.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/06.
//

import UIKit

extension UITextView {
    func setAllMarginToZero() {
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
    }
    func setTextViewToViewer() {
        isScrollEnabled = false
        isUserInteractionEnabled = false
    }
    func setTextViewPlaceholder(_ placeholder: String) {
        if text == "" {
            text = placeholder
            textColor = .gray5
        } else if text == placeholder {
            text = ""
            textColor = .gray2
        }
    }
}
