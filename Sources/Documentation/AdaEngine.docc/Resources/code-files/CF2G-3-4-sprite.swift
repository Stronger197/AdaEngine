import AdaEngine

class FirstScene {
    func makeScene() -> Scene {
        let scene = Scene()
        
        let cameraEntity = Entity(name: "Camera")
        
        let camera = Camera()
        camera.projection = .orthographic
        camera.isPrimal = true
        
        cameraEntity.components += camera
        scene.addEntity(cameraEntity)
        
        self.makePlayer(for: scene)
        
        return scene
    }
    
    func makePlayer(for scene: Scene) {
        let url = Bundle.main.url(forResource: "player", withExtension: "png")!
        let image = try! Image(contentsOf: url)
        
        let texture = Texture2D(image: image)
        
        let playerEntity = Entity(name: "Player")
        playerEntity.components += SpriteComponent(texture: texture)
        
        scene.addEntity(playerEntity)
    }
}
