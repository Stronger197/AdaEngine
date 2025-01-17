//
//  Scene.swift
//  
//
//  Created by v.prusakov on 11/1/21.
//

import OrderedCollections

enum SceneSerializationError: Error {
    case invalidExtensionType
    case unsupportedVersion
    case notRegistedObject(Any)
}

// FIXME: (Vlad) Systems should updated and stored in a DAG graph

public final class Scene: Resource {
    
    static var currentVersion: Version = "1.0.0"
    
    public var name: String
    public private(set) var id: UUID
    
    public internal(set) weak var window: Window?
    public internal(set) var viewport: Viewport = Viewport()
    
    public var resourcePath: String = ""
    public var resourceName: String = ""
    
    private var plugins: [ScenePlugin] = []
    private(set) var world: World
    
    private(set) var eventManager: EventManager = EventManager.default
    
    public private(set) lazy var sceneRenderGraph = RenderGraph()
    
    private let systemGraph = SystemsGraph()
    private let systemGraphExecutor = SystemsGraphExecutor()
    
    // Options for content in a scene that can aid debugging.
    public var debugOptions: DebugOptions = []
    public var debugPhysicsColor: Color = .green
    
    public weak var sceneManager: SceneManager?
    
    // MARK: - Initialization -
    
    public init(name: String? = nil) {
        self.id = UUID()
        self.name = name ?? "Scene"
        self.world = World()
    }
    
    // MARK: - Resource -
    
    public static var resourceType: ResourceType = .scene
    
    public func encodeContents(with encoder: AssetEncoder) throws {
        guard encoder.assetMeta.filePath.pathExtension == Self.resourceType.fileExtenstion else {
            throw SceneSerializationError.invalidExtensionType
        }
        
        let sceneData = SceneRepresentation(
            version: Self.currentVersion,
            scene: self.name,
            plugins: self.plugins.map {
                ScenePluginRepresentation(name: type(of: $0).swiftName)
            },
            systems: self.systemGraph.systems.map {
                SystemRepresentation(name: type(of: $0).swiftName)
            },
            entities: self.world.getEntities()
        )
        
        try encoder.encode(sceneData)
    }
    
    public convenience init(asset decoder: AssetDecoder) throws {
        guard decoder.assetMeta.filePath.pathExtension == Self.resourceType.fileExtenstion else {
            throw SceneSerializationError.invalidExtensionType
        }
        
        let sceneData = try decoder.decode(SceneRepresentation.self)
        
        if Self.currentVersion < sceneData.version {
            throw SceneSerializationError.unsupportedVersion
        }
        
        self.init(name: sceneData.scene)
        
        for system in sceneData.systems {
            guard let systemType = SystemStorage.getRegistredSystem(for: system.name) else {
                throw SceneSerializationError.notRegistedObject(system)
            }
            self.addSystem(systemType)
        }
        
        for plugin in sceneData.plugins {
            guard let pluginType = ScenePluginStorage.getRegistredPlugin(for: plugin.name) else {
                throw SceneSerializationError.notRegistedObject(plugin)
            }
            
            self.addPlugin(pluginType.init())
        }
        
        for entity in sceneData.entities {
            self.addEntity(entity)
        }
    }
    
    // MARK: - Public methods -
    
    /// Add new system to the scene.
    public func addSystem<T: System>(_ systemType: T.Type) {
        let system = systemType.init(scene: self)
        self.systemGraph.addSystem(system)
    }
    
    /// Add new scene plugin to the scene.
    public func addPlugin<T: ScenePlugin>(_ plugin: T) {
        plugin.setup(in: self)
        self.plugins.append(plugin)
    }
    
    // MARK: - Internal methods
    
    // TODO: Looks like not a good solution here
    /// Check the scene will not run earlier
    private(set) var isReady = false
    
    func ready() {
        // TODO: In the future we need minimal scene plugin for headless mode.
        self.addPlugin(DefaultScenePlugin())
        
        self.isReady = true
        
        self.systemGraph.linkSystems()
        self.world.tick() // prepare all values
        self.eventManager.send(SceneEvents.OnReady(scene: self), source: self)
    }
    
    func update(_ deltaTime: TimeInterval) {
        self.world.tick()
        
        let context = SceneUpdateContext(scene: self, deltaTime: deltaTime)
        self.systemGraphExecutor.execute(self.systemGraph, context: context)
    }
}

// MARK: - ECS

public extension Scene {
    /// Perform query to the ECS World.
    func performQuery(_ query: EntityQuery) -> QueryResult {
        return self.world.performQuery(query)
    }
}

// MARK: - Entity

public extension Scene {
    func addEntity(_ entity: Entity) {
        precondition(entity.world !== self.world, "Entity has different world reference, and can't be added")
        self.world.appendEntity(entity)
        
        self.eventManager.send(SceneEvents.DidAddEntity(entity: entity), source: self)
    }
    
    func findEntityByID(_ id: Entity.ID) -> Entity? {
        return self.world.getEntityByID(id)
    }
    
    /// Find an entity by name.
    /// - Note: Not efficient way to find an entity.
    /// - Complexity: O(n)
    /// - Returns: An entity with matched name or nil if entity with given name not exists.
    func findEntityByName(_ name: String) -> Entity? {
        self.world.getEntityByName(name)
    }
    
    func removeEntity(_ entity: Entity) {
        self.eventManager.send(SceneEvents.WillRemoveEntity(entity: entity), source: self)
        
        self.world.removeEntityOnNextTick(entity)
    }
}

// MARK: - World Transform

public extension Scene {
    func worldTransform(for entity: Entity) -> Transform {
        let worldMatrix = self.worldTransformMatrix(for: entity)
        return Transform(matrix: worldMatrix)
    }
    
    func worldTransformMatrix(for entity: Entity) -> Transform3D {
        var transform = Transform3D.identity
        
        if let parent = entity.parent {
            transform = self.worldTransformMatrix(for: parent)
        }
        
        guard let entityTransform = entity.components[Transform.self] else {
            return transform
        }
        
        return transform * entityTransform.matrix
    }
}

// MARK: - EventSource

extension Scene: EventSource {
    
    /// Receives events of the given type.
    /// - Parameters event: The type of the event, like `CollisionEvents.Began.Self`.
    /// - Parameters completion: A closure to call with the event.
    /// - Returns: A cancellable object. You should store it in memory, to recieve events.
    public func subscribe<E>(to event: E.Type, on eventSource: EventSource?, completion: @escaping (E) -> Void) -> AnyCancellable where E : Event {
        return self.eventManager.subscribe(to: event, on: eventSource ?? self, completion: completion)
    }
}

public extension Scene {
    struct DebugOptions: OptionSet {
        public var rawValue: UInt16
        
        public init(rawValue: UInt16) {
            self.rawValue = rawValue
        }
        
        public static let showPhysicsShapes = DebugOptions(rawValue: 1 << 0)
        public static let showFPS = DebugOptions(rawValue: 1 << 1)
        public static let showBoundingBoxes = DebugOptions(rawValue: 1 << 2)
    }
}

public enum SceneEvents {
    
    public struct OnReady: Event {
        public let scene: Scene
    }
    
    public struct DidAddEntity: Event {
        public let entity: Entity
    }
    
    public struct WillRemoveEntity: Event {
        public let entity: Entity
    }
    
}
