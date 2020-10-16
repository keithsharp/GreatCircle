import XCTest
import CoreLocation
@testable import GreatCircle

final class GreatCircleTests: XCTestCase {
    // Testing accuracy.
    let kAccuracyGood = 0.01;
    let kAccuracyBetter = 0.001;
    let kAccuracyBest = 0.000000001;

    // Distance between the Eiffel Tower and Versailles.
    let kDistanceEiffelTowerToVersailles: CLLocationDistance = 14084.280704919687

    // The initial and final bearings between the Eiffel Tower and Versailles.
    let kInitialBearingEiffelTowerToVersailles: CLLocationDistance = 245.13460296861962
    let kFinalBearingEiffelTowerToVersailles: CLLocationDistance = 245.00325395138532

    // The initial and final bearings between Versailles and the Eiffel Tower.
    let kInitialBearingVersaillesToEiffelTower: CLLocationDistance = 65.003253951385318
    let kFinalBearingVersaillesToEiffelTower: CLLocationDistance = 65.134602968619618

    let locationSaintGermain = CLLocation(latitude: 48.897728, longitude: 2.094977)
    let locationOrly = CLLocation(latitude: 48.747114, longitude: 2.400526)
    let locationEiffelTower = CLLocation(latitude: 48.858158, longitude: 2.294825)
    let locationVersailles = CLLocation(latitude: 48.804766, longitude: 2.120339)
    let locationIndianPond = CLLocation(latitude: 43.930912, longitude: -72.053811)
    
    func testInitialBearingSameLocationObject() {
        let bearing = locationIndianPond.initialBearingTo(otherLocation: locationIndianPond)
        XCTAssertEqual(bearing, 0.0)
    }
    
    func testInitialBearingSameLocation() {
        let newLocation = CLLocation(latitude: 43.930912, longitude: -72.053811)
        let bearing = locationIndianPond.initialBearingTo(otherLocation: newLocation)
        XCTAssertEqual(bearing, 0.0)
    }
    
    func testInitialBearingEiffelTowerToVersailles() {
        let bearing = locationEiffelTower.initialBearingTo(otherLocation: locationVersailles)
        XCTAssertEqual(bearing, kInitialBearingEiffelTowerToVersailles)
    }
    
    func testInitialBearingVersaillesToEiffelTower() {
        let bearing = locationVersailles.initialBearingTo(otherLocation: locationEiffelTower)
        XCTAssertEqual(bearing, kInitialBearingVersaillesToEiffelTower)
    }
    
    func testFinalBearingEiffelTowerToVersailles() {
        let bearing = locationEiffelTower.finalBearingTo(otherLocation: locationVersailles)
        XCTAssertEqual(bearing, kFinalBearingEiffelTowerToVersailles)
    }
    
    func testFinalBearingVersaillesToEiffelTower() {
        let bearing = locationVersailles.finalBearingTo(otherLocation: locationEiffelTower)
        XCTAssertEqual(bearing, kFinalBearingVersaillesToEiffelTower)
    }
    
    func testIntersection() {
        
        if let location = CLLocation(intersectionOf: locationSaintGermain, andBearing: locationSaintGermain.initialBearingTo(otherLocation: locationOrly), withLocation: locationEiffelTower, andBearing: kInitialBearingEiffelTowerToVersailles) {
            XCTAssertEqual(location.coordinate.latitude, 48.83569094988361, accuracy: kAccuracyBest)
            XCTAssertEqual(location.coordinate.longitude, 2.2212520313073583, accuracy: kAccuracyBest)
        } else {
            XCTAssertFalse(true)
        }
    }
    
    func testDistanceSameLocations() {
        let distance = locationIndianPond.distanceTo(otherLocation: locationIndianPond)
        XCTAssertEqual(distance, 0.0)
    }
    
    func testDistanceEqualLocations() {
        let newLocation = CLLocation(latitude: 43.930912, longitude: -72.053811)
        let distance = locationIndianPond.distanceTo(otherLocation: newLocation)
        XCTAssertEqual(distance, 0.0)
    }
    
    func testDistanceEiffelTowerToVersailles() {
        let distance = locationEiffelTower.distanceTo(otherLocation: locationVersailles)
        XCTAssertEqual(distance, kDistanceEiffelTowerToVersailles)
    }
    
    func testDistanceVersaillesToEiffelTower() {
        let distance = locationVersailles.distanceTo(otherLocation: locationEiffelTower)
        XCTAssertEqual(distance, kDistanceEiffelTowerToVersailles)
    }
    
    func testMidpointEiffelTowerToVersailles() {
        let midpointA = locationEiffelTower.midpointTo(otherLocation: locationVersailles)
        let midpointB = locationEiffelTower.locationWith(bearing: kInitialBearingEiffelTowerToVersailles, distance: kDistanceEiffelTowerToVersailles / 2.0)
        
        let distanceA = locationEiffelTower.distanceTo(otherLocation: midpointA)
        let distanceB = locationVersailles.distanceTo(otherLocation: midpointB)
        
        XCTAssertEqual(distanceA, kDistanceEiffelTowerToVersailles / 2.0, accuracy: kAccuracyBest)
        XCTAssertEqual(distanceB, kDistanceEiffelTowerToVersailles / 2.0, accuracy: kAccuracyBest)
        XCTAssertEqual(midpointA.coordinate.latitude, midpointB.coordinate.latitude, accuracy: kAccuracyBest)
        XCTAssertEqual(midpointA.coordinate.longitude, midpointB.coordinate.longitude, accuracy: kAccuracyBest)
    }
    
    func testMidpointVersaillesToEiffelTower() {
        let midpointA = locationVersailles.midpointTo(otherLocation: locationEiffelTower)
        let midpointB = locationVersailles.locationWith(bearing: kInitialBearingVersaillesToEiffelTower, distance: kDistanceEiffelTowerToVersailles / 2.0)
        
        let distanceA = locationVersailles.distanceTo(otherLocation: midpointA)
        let distanceB = locationEiffelTower.distanceTo(otherLocation: midpointB)
        
        XCTAssertEqual(distanceA, kDistanceEiffelTowerToVersailles / 2.0, accuracy: kAccuracyBest)
        XCTAssertEqual(distanceB, kDistanceEiffelTowerToVersailles / 2.0, accuracy: kAccuracyBest)
        XCTAssertEqual(midpointA.coordinate.latitude, midpointB.coordinate.latitude, accuracy: kAccuracyBest)
        XCTAssertEqual(midpointA.coordinate.longitude, midpointB.coordinate.longitude, accuracy: kAccuracyBest)
    }
    
    func testGenerateLocationVersailles() {
        let location = locationEiffelTower.locationWith(bearing: kInitialBearingEiffelTowerToVersailles, distance: kDistanceEiffelTowerToVersailles)
        XCTAssertEqual(location.coordinate.latitude, locationVersailles.coordinate.latitude, accuracy: kAccuracyBest)
        XCTAssertEqual(location.coordinate.longitude, locationVersailles.coordinate.longitude, accuracy: kAccuracyBest)
    }
    
    func testGenerateLocationEiffelTower() {
        let location = locationVersailles.locationWith(bearing: kInitialBearingVersaillesToEiffelTower, distance: kDistanceEiffelTowerToVersailles)
        XCTAssertEqual(location.coordinate.latitude, locationEiffelTower.coordinate.latitude, accuracy: kAccuracyBest)
        XCTAssertEqual(location.coordinate.longitude, locationEiffelTower.coordinate.longitude, accuracy: kAccuracyBest)
    }
    
    func testCrossTrackDistance90Degrees200Meters() {
        let midpoint = locationEiffelTower.midpointTo(otherLocation: locationVersailles)
        let bearing = locationEiffelTower.initialBearingTo(otherLocation: locationVersailles)
        let testBearing = fmod(bearing + 90.0, 360.0)
        let testLocation = midpoint.locationWith(bearing: testBearing, distance: 200.0)
        
        let distance = testLocation.crossTrackDistanceTo(startLocation: locationEiffelTower, endLocation: locationVersailles)
        
        XCTAssertEqual(distance, 200.0, accuracy: kAccuracyBetter)
    }
    
    func testCrossTrackDistance270Degrees200Meters() {
        let midpoint = locationEiffelTower.midpointTo(otherLocation: locationVersailles)
        let bearing = locationEiffelTower.initialBearingTo(otherLocation: locationVersailles)
        let testBearing = fmod(bearing + 270.0, 360.0)
        let testLocation = midpoint.locationWith(bearing: testBearing, distance: 200.0)
        
        let distance = testLocation.crossTrackDistanceTo(startLocation: locationEiffelTower, endLocation: locationVersailles)
        
        XCTAssertEqual(distance, -200.0, accuracy: kAccuracyBetter)
    }
    
    func testCrossTrackDistanceThatShouldBeVeryCloseToZero() {
        let midpoint = locationEiffelTower.midpointTo(otherLocation: locationVersailles)
        let distance = fabs(midpoint.crossTrackDistanceTo(startLocation: locationEiffelTower, endLocation: locationVersailles))
        
        XCTAssertEqual(distance, 0.0, accuracy: kAccuracyBest)
    }
    
    func testCrossTrackPointThatShouldBeOnTheLine() {
        let midpoint = locationEiffelTower.midpointTo(otherLocation: locationVersailles)
        let crossTrackLocation = midpoint.crossTrackLocationTo(startLocation: locationEiffelTower, endLocation: locationVersailles)
        
        XCTAssertEqual(midpoint.distance(from: crossTrackLocation), 0.0, accuracy: kAccuracyBest)
    }
    
    func testCrossTrackLocation90Degrees200Meters() {
        let midpoint = locationEiffelTower.midpointTo(otherLocation: locationVersailles)
        let bearing = locationEiffelTower.initialBearingTo(otherLocation: locationVersailles)
        let testBearing = fmod(bearing + 90.0, 360.0)
        let testLocation = midpoint.locationWith(bearing: testBearing, distance: 200.0)

        let crossTrackLocation = testLocation.crossTrackLocationTo(startLocation: locationEiffelTower, endLocation: locationVersailles)

        XCTAssertEqual(midpoint.distance(from: crossTrackLocation), 0.0, accuracy: kAccuracyGood)
    }
    
    func testCrossTrackLocation270Degrees200Meters() {
        let midpoint = locationEiffelTower.midpointTo(otherLocation: locationVersailles)
        let bearing = locationEiffelTower.initialBearingTo(otherLocation: locationVersailles)
        let testBearing = fmod(bearing + 270.0, 360.0)
        let testLocation = midpoint.locationWith(bearing: testBearing, distance: 200.0)
        
        let crossTrackLocation = testLocation.crossTrackLocationTo(startLocation: locationEiffelTower, endLocation: locationVersailles)
        let midDist = midpoint.distance(from: crossTrackLocation)
        XCTAssertEqual(midDist, 0.0, accuracy: kAccuracyGood)
    }
}
