//
//  Entity.swift
//  
//
//  Created by v.prusakov on 11/1/21.
//

import Foundation.NSUUID // TODO: Replace to own realization
import OrderedCollections

/// An enity describe
open class Entity: Identifiable {
    
    public var name: String
    
    public private(set) var id: UUID
    
    public internal(set) var components: ComponentSet
    
    public internal(set) weak var scene: Scene? {
        didSet {
            self.children.forEach {
                $0.scene = scene
            }
        }
    }
    
    public internal(set) var children: OrderedSet<Entity>
    
    public internal(set) weak var parent: Entity?
    
    public init(name: String = "Entity") {
        self.name = name
        self.id = UUID()
        self.components = ComponentSet()
        self.children = []
        
        defer {
            self.components.entity = self
            self.components[Transform.self] = Transform()
        }
    }
    
    // MARK: - Codable
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.children = try container.decode(OrderedSet<Entity>.self, forKey: .children)
        var components = try container.decode(ComponentSet.self, forKey: .components)
        self.components.set(components.buffer.values.elements)
        
        self.children.forEach { $0.parent = self }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.children, forKey: .children)
        try container.encode(self.components, forKey: .components)
    }
    
    // MARK: - Public
    
    open func update(_ deltaTime: TimeInterval) {
        for component in components.buffer.values {
            if !component.isAwaked {
                component.ready()
                component.isAwaked = true
            }
            
            component.update(deltaTime)
        }
    }
    
    open func physicsUpdate(_ deltaTime: TimeInterval) {
        for component in components.buffer.values where component.isAwaked {
            component.physicsUpdate(deltaTime)
        }
    }
    
    public func removeFromScene() {
        self.scene?.removeEntity(self)
    }
    
}

extension Entity: Hashable {
    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.identifier)
    }
}

extension Entity: Identifiable {
    public var id: UUID {
        return self.identifier
    }
}

extension Entity {
    
    /// Copying entity with components
    /// - Parameter recursive: Flags indicate that child enities will copying too
    open func copy(recursive: Bool = true) -> Entity {
        let newEntity = Entity()
        
        if recursive {
            var childrens = self.children
            
            for index in 0..<childrens.count {
                let child = self.children[index].copy(recursive: true)
                childrens.updateOrAppend(child)
            }
            
            newEntity.children = childrens
        }
        
        newEntity.components = self.components
        newEntity.scene = self.scene
        newEntity.parent = self.parent
        
        return newEntity
    }
    
    open func addChild(_ entity: Entity) {
        assert(!self.children.contains { $0 === entity }, "Currenlty has entity in child")
        
        self.children.append(entity)
        entity.parent = self
    }
    
    open func removeChild(_ entity: Entity) {
        guard let index = self.children.firstIndex(where: { $0 === entity }) else {
            return
        }
        
        entity.parent = nil
        
        self.children.remove(at: index)
    }
    
    /// Remove entity from parent
    open func removeFromParent() {
        guard let parent = self.parent else { return }
        parent.removeChild(self)
    }
}

extension Entity: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name
        case components
        case children
    }
}
