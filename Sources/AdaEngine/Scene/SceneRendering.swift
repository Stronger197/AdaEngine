//
//  SceneRendering.swift
//  
//
//  Created by v.prusakov on 8/21/22.
//

import Math

public final class SceneRendering {
    
    struct SpotLightUniform {
        var spotlights: [SpotLightComponent] = []
        var count: Int = 0
    }
    
    struct DirectionalLightUniform {
        var lights: [DirectionalLightComponent] = []
        var count: Int = 0
    }
    
    struct CameraUniform {
        var modelMatrix: Transform3D = .identity
        var viewMatrix: Transform3D = .identity
        var projectionMatrix: Transform3D = .identity
    }
    
    struct Uniforms {
        var camera = CameraUniform()
        var spotlights = SpotLightUniform()
        var directionalLights = DirectionalLightUniform()
    }
    
    public unowned let scene: Scene
    
    public var renderer2D = Renderer2D.default
    
    var currentDraw: RID!
    
    var renderUniforms: Uniforms = Uniforms()
//    let cameraUniformRID: RID
//    let spotlightUniformRID: RID
    
    init(scene: Scene) {
        self.scene = scene
//
//        self.cameraUniformRID = RenderEngine.shared.makeUniform(CameraUniform.self, count: 1, offset: 0, options: .storageShared)
//
//        self.spotlightUniformRID = RenderEngine.shared.makeUniform(SpotLightUniform.self, count: 1, offset: 0, options: .storageShared)
        
    }
    
    func beginRendering() {
        
//        self.currentDraw = RenderEngine.shared.beginDraw(for: window)
    }
    
    func endRendering() {
        self.flush()
//        RenderEngine.shared.drawEnd(self.currentDraw)
    }
    
    func renderMesh(_ mesh: Mesh, material: Material) {
        
    }
    
    func addSpotLight(transform: Transform3D) {
//        RenderEngine.shared.updateUniform(self.spotlightUniformRID, value: <#T##T#>, count: 1)
    }
    
    func flush() {
//        RenderEngine.shared.bindUniformSet(self.currentDraw, uniformSet: self.cameraUniformRID, at: 0)
//        RenderEngine.shared.bindUniformSet(self.currentDraw, uniformSet: self.spotlightUniformRID, at: 1)
        
//        RenderEngine.shared.bindRenderState(self.cameraUniformRID, renderPipeline: self.shader)
    }
}
