//
//  The MIT License (MIT)
//
//  Copyright (c) 2020 Keith Sharp.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

// MARK: Convert Radians to Degrees and Degrees to Radians
extension Double {
    var degreesAsRadians: Double {
        return self * .pi / 180.0
    }
    
    var radiansAsDegrees: Double {
        return self * 180.0 / .pi
    }
}

// MARK: Doubles to the specified number of decimal places
extension Double {
    /// Returns value rounded to the specified number of decimal places
    ///
    /// - Parameter places: The number of decimal places to round to..
    /// - Returns: The rounded value.
    ///
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
    
    /// Compares two values to the specified number of decimal places
    ///
    /// - Parameter value: The other value.
    /// - Parameter decimalPlaces: The number of decimal places.
    /// - Returns: `true` if the values match, otherwise, `false`.
    ///
    func compare(to value: Double, withDecimalPlaces decimalPlaces: Int) -> Bool {
        return self.round(to: decimalPlaces) == value.round(to: decimalPlaces)
    }
}
