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

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/* Adapted from:                                                                                  */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/* Latitude/longitude spherical geodesy tools                         (c) Chris Veness 2002-2016  */
/*                                                                                   MIT Licence  */
/* www.movable-type.co.uk/scripts/latlong.html                                                    */
/* www.movable-type.co.uk/scripts/geodesy/docs/module-latlon-spherical.html                       */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

import CoreLocation

// Radius of the Earth in metres
let kEarthRadiusInMeters = 6371000.0

extension CLLocation {
    /// Compares this location to the other location for equality.
    ///
    /// - Parameter otherLocation: The other location to compare to this location.
    /// - Returns: `true` if this location and the other location are equal; otherwise, `false`
    ///
    func isEqualTo(otherLocation: CLLocation) -> Bool {
        return self == otherLocation || (self.coordinate.latitude == otherLocation.coordinate.latitude && self.coordinate.longitude == otherLocation.coordinate.longitude)
    }
    
    /// Returns the initial bearing (in degrees) between this location and the other location.
    ///
    /// - Parameter otherLocation: The other location.
    /// - Returns: The initial bearing (in degrees) between this location and the other location.
    ///
    func initialBearingTo(otherLocation: CLLocation) -> CLLocationDirection {
        if self.isEqualTo(otherLocation: otherLocation) {
            return 0.0
        }
        
        let φ1 = self.coordinate.latitude.degreesAsRadians
        let φ2 = otherLocation.coordinate.latitude.degreesAsRadians
        let Δλ = (otherLocation.coordinate.longitude - self.coordinate.longitude).degreesAsRadians
                
        // see http://mathforum.org/library/drmath/view/55417.html
        let y = sin(Δλ) * cos(φ2)
        let x = cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(Δλ)
        let θ = atan2(y, x)
        
        return fmod(θ.radiansAsDegrees + 360.0, 360.0);
    }
    
    /// Creates a `CLLocation` from the intersection of two locations and bearings.
    ///
    /// - Parameter locationOne: The first location.
    /// - Parameter bearingOne: The bearing from the first location.
    /// - Parameter locationTwo: The second location.
    /// - Parameter bearingTwo: The bearing from the second location.
    ///
    convenience init?(intersectionOf locationOne: CLLocation, andBearing bearingOne: CLLocationDirection, withLocation locationTwo: CLLocation, andBearing bearingTwo: CLLocationDirection) {
        // see http://williams.best.vwh.net/avform.htm#Intersection
        let φ1 = locationOne.coordinate.latitude.degreesAsRadians
        let λ1 = locationOne.coordinate.longitude.degreesAsRadians
        let φ2 = locationTwo.coordinate.latitude.degreesAsRadians
        let λ2 = locationTwo.coordinate.longitude.degreesAsRadians
        let θ13 = bearingOne.degreesAsRadians
        let θ23 = bearingTwo.degreesAsRadians
        let Δφ = φ2 - φ1
        let Δλ = λ2-λ1
        
        let δ12 = 2.0 * asin(sqrt(sin(Δφ / 2.0) * sin(Δφ / 2.0) + cos(φ1) * cos(φ2) * sin(Δλ / 2.0) * sin(Δλ / 2.0)))
        if (δ12 == 0) {
            return nil
        }
        
        var θ1 = acos((sin(φ2) - sin(φ1) * cos(δ12)) / (sin(δ12) * cos(φ1)))
        if (θ1.isNaN) {
            // Protect against rounding.
            θ1 = 0.0
        }
        
        let θ2 = acos((sin(φ1) - sin(φ2) * cos(δ12)) / (sin(δ12) * cos(φ2)))
        
        let θ12 = sin(λ2-λ1) > 0.0 ? θ1 : 2.0 * .pi - θ1
        let θ21 = sin(λ2-λ1) > 0.0 ? 2.0 * .pi - θ2 : θ2
        
        let α1 = fmod(θ13 - θ12 + .pi, (2.0 * .pi) - .pi) // angle 2-1-3
        let α2 = fmod(θ21 - θ23 + .pi, (2.0 * .pi) - .pi) // angle 1-2-3
        
        // Infinite intersections.
        if (sin(α1) == 0.0 && sin(α2) == 0.0) {
            return nil
        }
        
        // Ambiguous intersection.
        if (sin(α1) * sin(α2) < 0.0) {
            return nil
        }
        
        let α3 = acos(-cos(α1) * cos(α2) + sin(α1) * sin(α2) * cos(δ12))
        let δ13 = atan2(sin(δ12) * sin(α1) * sin(α2), cos(α2) + cos(α1) * cos(α3))
        let φ3 = asin(sin(φ1) * cos(δ13) + cos(φ1) * sin(δ13) * cos(θ13))
        let Δλ13 = atan2(sin(θ13) * sin(δ13) * cos(φ1), cos(δ13) - sin(φ1) * sin(φ3))
        let λ3 = λ1 + Δλ13
        
        let lat = φ3.radiansAsDegrees
        let lon = fmod(λ3.radiansAsDegrees + 540.0, 360.0) - 180.0
        
        self.init(latitude: lat, longitude: lon)
    }
}
