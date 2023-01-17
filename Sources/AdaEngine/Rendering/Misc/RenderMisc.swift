//
//  RenderMisc.swift
//  
//
//  Created by v.prusakov on 1/18/23.
//

// TODO: (Vlad) Add documentations for all enums

// MARK: - Blending -

public enum BlendFactor: UInt {
    
    case zero
    
    case one
    
    case sourceColor
    
    case oneMinusSourceColor
    
    case sourceAlpha
    
    case oneMinusSourceAlpha
    
    case destinationColor
    
    case oneMinusDestinationColor
    
    case destinationAlpha
    
    case oneMinusDestinationAlpha
    
    case sourceAlphaSaturated
    
    case blendColor
    
    case oneMinusBlendColor
    
    case blendAlpha
    
    case oneMinusBlendAlpha
}

public enum BlendOperation: UInt {
    
    case add
    
    case subtract
    
    case reverseSubtract
    
    case min
    
    case max
}

// MARK: - Depth & Stencil -

public enum StencilOperation: UInt {
    
    case zero
    
    case keep
    
    case replace
    
    case incrementAndClamp
    
    case decrementAndClamp
    
    case invert
    
    case incrementAndWrap
    
    case decrementAndWrap
}

// MARK: - Others -

public enum AttachmentLoadAction {
    
    case clear
    
    case load
    
    case dontCare
}

public enum CompareOperation: UInt {

    case never
    
    case always

    case equal
    
    case notEqual
    
    case less
    
    case lessOrEqual
    
    case greater
    
    case greaterOrEqual
    
}

public enum PixelFormat {
    case none
    
    case bgra8
    case bgra8_srgb
    
    case rgba8
    case rgba_16f
    case rgba_32f
    
    case depth_32f_stencil8
    case depth_32f
    case depth24_stencil8
    
    var isDepthFormat: Bool {
        self == .depth_32f_stencil8 || self == .depth_32f || self == .depth24_stencil8
    }
}
