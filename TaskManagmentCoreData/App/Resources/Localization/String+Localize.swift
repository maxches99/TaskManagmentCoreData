//
//  String+Localize.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 10.04.2022.
//

import Foundation
import SwiftUI

extension String {
    var localizationString: String {
        NSLocalizedString(self, comment: "")
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
}
