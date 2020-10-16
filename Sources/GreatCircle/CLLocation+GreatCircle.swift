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
    /// Creates a `CLLocation` from the intersection of two locations and bearings.
    ///
    /// - Parameter locationOne: The first location.
    /// - Parameter bearingOne: The bearing from the first location.
    /// - Parameter locationTwo: The second location.
    /// - Parameter bearingTwo: The bearing from the second location.
    /// - Returns: A new CLLocation representing the intersection, or `nil` if there is no intersection.
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
        
        return fmod(θ.radiansAsDegrees + 360.0, 360.0)
    }
    
    /// Returns the final bearing (in degrees) between this location and the other location.
    ///
    /// The final bearing will differ from the initial bearing by varying degrees according to distance and latitude.
    ///
    /// - Parameter otherLocation: The other location.
    /// - Returns: The final bearing (in degrees) between this location and the other location.
    ///
    func finalBearingTo(otherLocation: CLLocation) -> CLLocationDirection {
        if self.isEqualTo(otherLocation: otherLocation) {
            return 0.0
        } else {
            return fmod(otherLocation.initialBearingTo(otherLocation: self) + 180.0, 360.0)
        }
    }
    
    /// Returns the distance (in meters) between this location and the other location.
    ///
    /// - Parameter otherLocation: The other location.
    /// - Returns: The distance (in meters) between this location and the other location.
    ///
    func distanceTo(otherLocation: CLLocation) -> CLLocationDistance {
        if self.isEqualTo(otherLocation: otherLocation) {
            return 0.0
        }
        
        let φ1 = self.coordinate.latitude.degreesAsRadians
        let λ1 = self.coordinate.longitude.degreesAsRadians
        let φ2 = otherLocation.coordinate.latitude.degreesAsRadians
        let λ2 = otherLocation.coordinate.longitude.degreesAsRadians
        let Δφ = φ2 - φ1
        let Δλ = λ2 - λ1
        let a = sin(Δφ / 2.0) * sin(Δφ / 2.0) + cos(φ1) * cos(φ2) * sin(Δλ / 2.0) * sin(Δλ / 2.0)
        let c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
        let d = kEarthRadiusInMeters * c
                
        return d;
    }
    
    /// Returns a location representing the midpoint between this location and the other location.
    ///
    /// - Parameter otherLocation: The other location.
    /// - Returns: A location representing the midpoint between this location and the other location.
    ///
    func midpointTo(otherLocation: CLLocation) -> CLLocation {
        if self.isEqualTo(otherLocation: otherLocation) {
            return self
        }
        
        // φm = atan2( sinφ1 + sinφ2, √( (cosφ1 + cosφ2⋅cosΔλ) ⋅ (cosφ1 + cosφ2⋅cosΔλ) ) + cos²φ2⋅sin²Δλ )
        // λm = λ1 + atan2(cosφ2⋅sinΔλ, cosφ1 + cosφ2⋅cosΔλ)
        // see http://mathforum.org/library/drmath/view/51822.html for derivation
        let φ1 = self.coordinate.latitude.degreesAsRadians
        let λ1 = self.coordinate.longitude.degreesAsRadians
                
        let φ2 = otherLocation.coordinate.latitude.degreesAsRadians
        let Δλ = (otherLocation.coordinate.longitude - self.coordinate.longitude).degreesAsRadians
                
        let Bx = cos(φ2) * cos(Δλ)
        let By = cos(φ2) * sin(Δλ)
                
        let x = sqrt((cos(φ1) + Bx) * (cos(φ1) + Bx) + By * By)
        let y = sin(φ1) + sin(φ2)
        let φ3 = atan2(y, x)
                
        let λ3 = λ1 + atan2(By, cos(φ1) + Bx)
        
        let lat = φ3.radiansAsDegrees
        let lon = fmod(λ3.radiansAsDegrees + 540.0, 360.0) - 180.0
        
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    /// Returns a location representing the point that lies at the specified bearing and distance from this location.
    ///
    /// - Parameter bearing: The bearing, in degrees.
    /// - Parameter distance: The distance, in meters.
    /// - Returns:A location representing the point that lies at the specified bearing and distance from this location.
    ///
    func locationWith(bearing: CLLocationDirection, distance: CLLocationDistance) -> CLLocation {
        if distance == 0.0 {
            return self
        }
        
        // φ2 = asin( sinφ1⋅cosδ + cosφ1⋅sinδ⋅cosθ )
        // λ2 = λ1 + atan2( sinθ⋅sinδ⋅cosφ1, cosδ − sinφ1⋅sinφ2 )
        // see http://williams.best.vwh.net/avform.htm#LL
        let δ = distance / kEarthRadiusInMeters // angular distance in radians
        let θ = bearing.degreesAsRadians
                
        let φ1 = self.coordinate.latitude.degreesAsRadians
        let λ1 = self.coordinate.longitude.degreesAsRadians
                
        let φ2 = asin(sin(φ1)*cos(δ) + cos(φ1)*sin(δ)*cos(θ))
        let x = cos(δ) - sin(φ1) * sin(φ2)
        let y = sin(θ) * sin(δ) * cos(φ1)
        let λ2 = λ1 + atan2(y, x)
        
        let lat = φ2.radiansAsDegrees
        let lon = fmod(λ2.radiansAsDegrees + 540.0, 360.0) - 180.0
        
        return CLLocation(latitude: lat, longitude: lon)
    }
}
