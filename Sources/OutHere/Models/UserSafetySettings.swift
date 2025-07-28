import Foundation

struct UserSafetySettings: Codable {
    var blockedSpotIDs: [UUID] = []
    var mutedSpotIDs: [UUID] = []
    var safeHours: [ClosedRange<Int>] = []

    enum CodingKeys: String, CodingKey {
        case blockedSpotIDs
        case mutedSpotIDs
        case safeHours
    }

    init(blockedSpotIDs: [UUID] = [], mutedSpotIDs: [UUID] = [], safeHours: [ClosedRange<Int>] = []) {
        self.blockedSpotIDs = blockedSpotIDs
        self.mutedSpotIDs = mutedSpotIDs
        self.safeHours = safeHours
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(blockedSpotIDs, forKey: .blockedSpotIDs)
        try container.encode(mutedSpotIDs, forKey: .mutedSpotIDs)
        let ranges = safeHours.map { [$0.lowerBound, $0.upperBound] }
        try container.encode(ranges, forKey: .safeHours)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        blockedSpotIDs = try container.decode([UUID].self, forKey: .blockedSpotIDs)
        mutedSpotIDs = try container.decode([UUID].self, forKey: .mutedSpotIDs)
        let ranges = try container.decode([[Int]].self, forKey: .safeHours)
        safeHours = ranges.compactMap { range in
            guard range.count == 2 else { return nil }
            return range[0]...range[1]
        }
    }
}
