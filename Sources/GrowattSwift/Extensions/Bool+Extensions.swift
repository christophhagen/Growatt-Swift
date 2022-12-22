import Foundation

extension Bool {

    init(value: UInt16) {
        self = value > 0
    }
}
