//
//  MetalIndexBuffer.swift
//  
//
//  Created by v.prusakov on 1/18/23.
//

#if METAL

import Metal

class MetalIndexBuffer: MetalBuffer, IndexBuffer {
    
    let indexFormat: IndexBufferFormat
    let offset: Int
    
    init(buffer: MTLBuffer, offset: Int, indexFormat: IndexBufferFormat) {
        self.indexFormat = indexFormat
        self.offset = offset
        
        super.init(buffer: buffer)
    }
    
}

#endif
