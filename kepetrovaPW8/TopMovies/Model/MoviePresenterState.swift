//
//  File.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 17.03.2022.
//

import Foundation
import UIKit

enum MoviePresenterState {
    case none
    case loading
    case success([Movie])
    case error(Error)
}
