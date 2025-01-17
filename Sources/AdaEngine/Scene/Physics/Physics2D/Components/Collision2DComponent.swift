//
//  Collision2DComponent.swift
//  
//
//  Created by v.prusakov on 7/11/22.
//

public struct Collision2DComponent: Component {
    
    internal var runtimeBody: Body2D?
    public var shapes: [Shape2DResource] = []
    public var mode: Mode
    public var filter: CollisionFilter
    
    public init(
        shapes: [Shape2DResource],
        mode: Mode = .default,
        filter: CollisionFilter = CollisionFilter()
    ) {
        self.mode = mode
        self.shapes = shapes
        self.filter = filter
    }
    
    // MARK: - Codable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.shapes = try container.decode([Shape2DResource].self, forKey: .shapes)
        self.mode = try container.decode(Mode.self, forKey: .mode)
        self.filter = try container.decode(CollisionFilter.self, forKey: .filter)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.shapes, forKey: .shapes)
        try container.encode(self.filter, forKey: .filter)
        try container.encode(self.mode, forKey: .mode)
    }
    
    enum CodingKeys: CodingKey {
        case shapes
        case mode
        case filter
    }
}

public extension Collision2DComponent {
    enum Mode: Codable {
        case trigger
        case `default`
    }
}
