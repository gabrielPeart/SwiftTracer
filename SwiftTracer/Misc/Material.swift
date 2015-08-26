//
//  Material.swift
//  SwiftTracer
//
//  Created by Hugo Tunius on 09/08/15.
//  Copyright © 2015 Hugo Tunius. All rights reserved.
//

import Foundation

struct Material {
    let color: Color
    let ambientCoefficient: Double
    let diffuseCoefficient: Double
    let specularCoefficient: Double
    var isReflective: Bool {
        get {
            return specularCoefficient > 0.0
        }
    }
}
