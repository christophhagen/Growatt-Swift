import Foundation

extension Int {

    init?(_ value: UInt16, in range: ClosedRange<Int>) {
        self.init(value)
        guard range.contains(self) else {
            return nil
        }
    }
}
