//
//  Circle2DRenderSystem.swift
//  
//
//  Created by v.prusakov on 5/10/22.
//

struct Render2DSystem: System {
    
    static var dependencies: [SystemDependency] = [.after(ViewContainerSystem.self)]
    
    static let spriteQuery = EntityQuery(where: (.has(Circle2DComponent.self) || .has(SpriteComponent.self)) && .has(Transform.self))
    
    let render2D = RenderEngine2D()
    
    init(scene: Scene) { }
    
    func update(context: UpdateContext) {
        let spriteEntities = context.scene.performQuery(Self.spriteQuery)
        
        guard !spriteEntities.isEmpty else { return }
        
        guard let window = context.scene.window else {
            return
        }
        
        render2D.beginContext(for: window.id, camera: context.scene.activeCamera)
        render2D.setDebugName("Start 2D Rendering scene")
        
        spriteEntities.forEach { entity in
            guard let transform = entity.components[Transform.self] else {
                assert(true, "Render 2D System don't have required Transform component")
                
                return
            }
            
            if let circle = entity.components[Circle2DComponent.self] {
                render2D.drawCircle(
                    transform: transform.matrix,
                    thickness: circle.thickness,
                    fade: circle.fade,
                    color: circle.color
                )
            }
            
            if let sprite = entity.components[SpriteComponent.self] {
                render2D.drawQuad(
                    transform: transform.matrix,
                    texture: sprite.texture,
                    color: sprite.tintColor
                )
            }
        }
        
        render2D.commitContext()
    }
}
