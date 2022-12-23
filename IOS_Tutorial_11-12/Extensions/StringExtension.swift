//
//  StringExtension.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thái on 21/12/2022.
//

import Foundation

extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func removeWhitespace() -> String {
       return self.replace(string: " ", replacement: "")
   }
 }
