//
//  String+DisplayLabel.swift
//  Plentifood
//
//  Created by Mami on 2/2/26.
//

import SwiftUI

extension String {
   var displayLabel: String {
      self.replacingOccurrences(of: "_", with: " ")
         .capitalized
   }
}


//#Preview {
//    String_DisplayLabel()
//}
