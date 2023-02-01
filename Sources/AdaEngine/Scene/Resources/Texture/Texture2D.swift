//
//  Texture2D.swift
//  
//
//  Created by v.prusakov on 6/28/22.
//

import Foundation
import Yams

/// The base class represents a 2D texture.
/// If the texture isn't held by any object, then the GPU resource will freed immediately.
open class Texture2D: Texture {
    
    public private(set) var width: Float
    public private(set) var height: Float
    
    public init(image: Image) {
        let descriptor = TextureDescriptor(
            width: image.width,
            height: image.height,
            pixelFormat: image.format.toPixelFormat,
            textureUsage: [.read],
            textureType: .texture2D,
            image: image
        )
        
        let gpuTexture = RenderEngine.shared.makeTexture(from: descriptor)
        
        self.width = Float(image.width)
        self.height = Float(image.height)
        
        super.init(gpuTexture: gpuTexture, textureType: .texture2D)
    }
    
    // FIXME: Should return image?
    public var image: Image? {
//        RenderEngine.shared.getImage(for: self.rid)
        return nil
    }
    
    open internal(set) var textureCoordinates: [Vector2] = [
        [0, 1], [1, 1], [1, 0], [0, 0]
    ]
    
    internal init(gpuTexture: GPUTexture, size: Size) {
        self.width = size.width
        self.height = size.height
        
        super.init(gpuTexture: gpuTexture, textureType: .texture2D)
    }
    
    // MARK: - Codable
    
    public convenience required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let path = try container.decode(String.self)
        
        let image = try ResourceManager.load(path) as Image
        self.init(image: image)
        
        let context = decoder.userInfo[.assetsDecodingContext] as? AssetDecodingContext
        context?.appendResource(self)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        if self.resourcePath.isEmpty {
            try container.encode(self.resourcePath)
            return
        }
        
        try container.encode(self.resourcePath)
    }
    
    // MARK: - Resource
    
    public required init(asset decoder: AssetDecoder) throws {
        let image = try Image(asset: decoder)
        
        let descriptor = TextureDescriptor(
            width: image.width,
            height: image.height,
            pixelFormat: image.format.toPixelFormat,
            textureUsage: [.read],
            textureType: .texture2D,
            image: image
        )
        
        let gpuTexture = RenderEngine.shared.makeTexture(from: descriptor)
        
        self.width = Float(image.width)
        self.height = Float(image.height)
        
        super.init(gpuTexture: gpuTexture, textureType: .texture2D)
    }
    
    public override func encodeContents(with encoder: AssetEncoder) throws {
        try self.image?.encodeContents(with: encoder)
    }
}
