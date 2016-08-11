//
//  ConverterCalc.swift
//  UnitConverter
//
//  Created by xinsu on 6/10/16.
//  Copyright © 2016 Illinois Institute of Technology. All rights reserved.
//

import Foundation

class ConverterCalc {
    
    /*
        fahr to celsius
     */
    func fahrToCelsius(f: Double) -> Double {
        return (f - 32.0) * 5.0 / 9.0
    }
    
    /*
        celsius to fahr
     */
    func celsiusToFahr(c: Double) -> Double {
        return c * 9.0 / 5.0 + 32.0
    }
    
    /*
        mile to kilometer
     */
    func mileToKilometer(m: Double) -> Double {
        return 0.621 * m
    }
    
    /*
        kilometer to mile
     */
    func kilometerToMile(k: Double) -> Double {
        return 1.609 * k
    }
    
    /*
        gallon to liter
     */
    func gallonToLiter(g: Double) -> Double {
        return 0.264 * g
    }
    
    /*
        liter to gallon
     */
    func literToGallon(l: Double) -> Double {
        return 3.785 * l
    }
    
}