//
//  Extensions.swift
//  NetflixClone
//
//  Created by Kailash Bora on 23/04/24.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
