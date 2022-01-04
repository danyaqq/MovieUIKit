//
//  Extensions.swift
//  navi
//
//  Created by Даня on 04.01.2022.
//

import Foundation

extension String{
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
