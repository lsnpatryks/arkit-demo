//
//  Extensions.swift
//  arkit-demo
//
//  Created by Patryk Spanily on 19.03.2018.
//  Copyright © 2018 Patryk Spanily. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension Float {
    var cgFloat: CGFloat { return CGFloat(self) }
}
