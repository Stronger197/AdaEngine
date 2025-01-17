//
//  RenderEngine.swift
//  
//
//  Created by v.prusakov on 10/25/21.
//

import OrderedCollections

public class RenderEngine: RenderBackend {
    
    public static let shared: RenderEngine = {
        let renderBackend: RenderBackend
        
        #if METAL
        renderBackend = MetalRenderBackend(appName: "Ada Engine")
        #elseif VULKAN
        // vulkan here
        #endif
        
        return RenderEngine(renderBackend: renderBackend)
    }()
    
    private let renderBackend: RenderBackend
    
    private init(renderBackend: RenderBackend) {
        self.renderBackend = renderBackend
    }
    
    // MARK: - RenderBackend
    
    public var currentFrameIndex: Int {
        return self.renderBackend.currentFrameIndex
    }
    
    public func createWindow(_ windowId: Window.ID, for view: RenderView, size: Size) throws {
        try self.renderBackend.createWindow(windowId, for: view, size: size)
    }
    
    public func resizeWindow(_ windowId: Window.ID, newSize: Size) throws {
        try self.renderBackend.resizeWindow(windowId, newSize: newSize)
    }
    
    public func destroyWindow(_ windowId: Window.ID) throws {
        try self.renderBackend.destroyWindow(windowId)
    }
    
    func beginFrame() throws {
        try self.renderBackend.beginFrame()
    }
    
    func endFrame() throws {
        try self.renderBackend.endFrame()
    }
    
    // MARK: - Buffers -
    
    func makeBuffer(length: Int, options: ResourceOptions) -> Buffer {
        return self.renderBackend.makeBuffer(length: length, options: options)
    }
    
    func makeBuffer(bytes: UnsafeRawPointer, length: Int, options: ResourceOptions) -> Buffer {
        return self.renderBackend.makeBuffer(bytes: bytes, length: length, options: options)
    }
    
    func makeIndexBuffer(index: Int, format: IndexBufferFormat, bytes: UnsafeRawPointer, length: Int) -> IndexBuffer {
        return self.renderBackend.makeIndexBuffer(index: index, format: format, bytes: bytes, length: length)
    }
    
    func makeVertexBuffer(length: Int, binding: Int) -> VertexBuffer {
        self.renderBackend.makeVertexBuffer(length: length, binding: binding)
    }
    
    // MARK: - Shaders
    
    func makeSampler(from descriptor: SamplerDescriptor) -> Sampler {
        return self.renderBackend.makeSampler(from: descriptor)
    }
    
    func makeFramebuffer(from descriptor: FramebufferDescriptor) -> Framebuffer {
        return self.renderBackend.makeFramebuffer(from: descriptor)
    }
    
    func makeRenderPipeline(from descriptor: RenderPipelineDescriptor) -> RenderPipeline {
        return self.renderBackend.makeRenderPipeline(from: descriptor)
    }
    
    func makeShader(from descriptor: ShaderDescriptor) -> Shader {
        return self.renderBackend.makeShader(from: descriptor)
    }
    
    // MARK: - Uniforms -
    
    func makeUniformBuffer(length: Int, binding: Int) -> UniformBuffer {
        self.renderBackend.makeUniformBuffer(length: length, binding: binding)
    }
    
    func makeUniformBufferSet() -> UniformBufferSet {
        self.renderBackend.makeUniformBufferSet()
    }
    
    // MARK: - Texture -
    
    func makeTexture(from descriptor: TextureDescriptor) -> GPUTexture {
        self.renderBackend.makeTexture(from: descriptor)
    }
    
    func getImage(for texture2D: RID) -> Image? {
        self.renderBackend.getImage(for: texture2D)
    }
    
    // MARK: - Drawing -
    
    func beginDraw(for window: Window.ID, clearColor: Color) -> DrawList {
        self.renderBackend.beginDraw(for: window, clearColor: clearColor)
    }
    
    func beginDraw(to framebuffer: Framebuffer, clearColors: [Color]?) -> DrawList {
        self.renderBackend.beginDraw(to: framebuffer, clearColors: clearColors)
    }
    
    func draw(_ list: DrawList, indexCount: Int, instancesCount: Int) {
        self.renderBackend.draw(list, indexCount: indexCount, instancesCount: instancesCount)
    }
    
    func endDrawList(_ drawList: DrawList) {
        self.renderBackend.endDrawList(drawList)
    }
}

public extension RenderEngine {
    func makeUniformBuffer<T>(_ uniformType: T.Type, count: Int = 1, binding: Int) -> UniformBuffer {
        self.makeUniformBuffer(length: MemoryLayout<T>.stride * count, binding: binding)
    }
}
