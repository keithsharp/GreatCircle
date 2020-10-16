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

    func testIntersection() {
        let locationSaintGermain = CLLocation(latitude: 48.897728, longitude: 2.094977)
        let locationOrly = CLLocation(latitude: 48.747114, longitude: 2.400526)
        let locationEiffelTower = CLLocation(latitude: 48.858158, longitude: 2.294825)
        //let locationVersailles = CLLocation(latitude: 48.804766, longitude: 2.120339)
        
        if let location = CLLocation(intersectionOf: locationSaintGermain, andBearing: locationSaintGermain.initialBearingTo(otherLocation: locationOrly), withLocation: locationEiffelTower, andBearing: kInitialBearingEiffelTowerToVersailles) {
            XCTAssertEqual(location.coordinate.latitude, 48.83569094988361, accuracy: kAccuracyBest)
            XCTAssertEqual(location.coordinate.longitude, 2.2212520313073583, accuracy: kAccuracyBest)
        } else {
            XCTAssertFalse(true)
        }
    }
}