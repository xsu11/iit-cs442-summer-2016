//
//  ConverterCalc.swift
//  UnitConverter
//
//  Created by xinsu on 6/10/16.
//  Copyright © 2016 Illinois Institute of Technology. All rights reserved.
//

import Foundation

class ConverterCalc {
    
    var basicType: String = ""
    var coefficients = [String:[Double]]()
    
    func convert(base: Double, coefficients: [Double]) -> Double {
        return coefficients[1] * base + coefficients[0]
    }
    
    func reverse(current: Double, coefficients: [Double]) -> Double {
        return (current - coefficients[0]) / coefficients[1]
    }
    
    
    
}