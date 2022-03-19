import Foundation
import UIKit

enum MoviePresenterState {
    case none
    case loading
    case success([Movie])
    case error(Error)
}
