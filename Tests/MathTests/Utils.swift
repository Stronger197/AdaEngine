//
//  Utils.swift
//  
//
//  Created by v.prusakov on 5/22/22.
//

import XCTest

#if canImport(simd)
import simd
#endif

#if canImport(QuartzCore)
import QuartzCore
#endif

@testable import Math

enum TestUtils {
    
#if canImport(simd)
    
    static func assertEqual(_ simd_matrix: matrix_float4x4, _ transform: Transform3D, accuracy: Float = 0.00001) {
        XCTAssertEqual(simd_matrix[0, 0], transform[0, 0], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[0, 1], transform[0, 1], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[0, 2], transform[0, 2], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[0, 3], transform[0, 3], accuracy: accuracy)
        
        XCTAssertEqual(simd_matrix[1, 0], transform[1, 0], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[1, 1], transform[1, 1], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[1, 2], transform[1, 2], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[1, 3], transform[1, 3], accuracy: accuracy)
        
        XCTAssertEqual(simd_matrix[2, 0], transform[2, 0], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[2, 1], transform[2, 1], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[2, 2], transform[2, 2], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[2, 3], transform[2, 3], accuracy: accuracy)
        
        XCTAssertEqual(simd_matrix[3, 0], transform[3, 0], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[3, 1], transform[3, 1], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[3, 2], transform[3, 2], accuracy: accuracy)
        XCTAssertEqual(simd_matrix[3, 3], transform[3, 3], accuracy: accuracy)
    }
    
    static func assertEqual(_ simd_quat: simd_quatf, _ quat: Quat, accuracy: Float = 0.00001) {
        XCTAssertEqual(simd_quat.vector.x, quat.x, accuracy: accuracy)
        XCTAssertEqual(simd_quat.vector.y, quat.y, accuracy: accuracy)
        XCTAssertEqual(simd_quat.vector.z, quat.z, accuracy: accuracy)
        XCTAssertEqual(simd_quat.vector.w, quat.w, accuracy: accuracy)
    }
    
#endif
    
#if canImport(QuartzCore)
    
    static func assertEqual(_ caTransform3D: CATransform3D, _ transform: Transform3D) {
        XCTAssertEqual(Float(caTransform3D.m11), transform[0, 0])
        XCTAssertEqual(Float(caTransform3D.m12), transform[1, 0])
        XCTAssertEqual(Float(caTransform3D.m13), transform[2, 0])
        XCTAssertEqual(Float(caTransform3D.m14), transform[3, 0])
        
        XCTAssertEqual(Float(caTransform3D.m21), transform[0, 1])
        XCTAssertEqual(Float(caTransform3D.m22), transform[1, 1])
        XCTAssertEqual(Float(caTransform3D.m23), transform[2, 1])
        XCTAssertEqual(Float(caTransform3D.m24), transform[3, 1])
        
        XCTAssertEqual(Float(caTransform3D.m31), transform[0, 2])
        XCTAssertEqual(Float(caTransform3D.m32), transform[1, 2])
        XCTAssertEqual(Float(caTransform3D.m33), transform[2, 2])
        XCTAssertEqual(Float(caTransform3D.m34), transform[3, 2])
        
        XCTAssertEqual(Float(caTransform3D.m41), transform[0, 3])
        XCTAssertEqual(Float(caTransform3D.m42), transform[1, 3])
        XCTAssertEqual(Float(caTransform3D.m43), transform[2, 3])
        XCTAssertEqual(Float(caTransform3D.m44), transform[3, 3])
    }
    
    static func assertEqual(
        _ cgAffineTransform: CGAffineTransform,
        _ transform: Transform2D,
        accuracy: Float = 0.00001
    ) {
        XCTAssertEqual(Float(cgAffineTransform.a), transform[0, 0], accuracy: accuracy)
        XCTAssertEqual(Float(cgAffineTransform.b), transform[0, 1], accuracy: accuracy)
        XCTAssertEqual(Float(cgAffineTransform.c), transform[1, 0], accuracy: accuracy)
        XCTAssertEqual(Float(cgAffineTransform.d), transform[1, 1], accuracy: accuracy)
        
        XCTAssertEqual(Float(cgAffineTransform.tx), transform[2, 0], accuracy: accuracy)
        XCTAssertEqual(Float(cgAffineTransform.ty), transform[2, 1], accuracy: accuracy)
    }
    
    static func assertEqual(
        _ cgPoint: CGPoint,
        _ point: Point,
        accuracy: Float = 0.00001
    ) {
        XCTAssertEqual(Float(cgPoint.x), point.x, accuracy: accuracy)
        XCTAssertEqual(Float(cgPoint.y), point.y, accuracy: accuracy)
    }
    
    static func assertEqual(
        _ cgRect: CGRect,
        _ rect: Rect,
        accuracy: Float = 0.00001
    ) {
        XCTAssertEqual(Float(cgRect.minX), rect.minX, accuracy: accuracy)
        XCTAssertEqual(Float(cgRect.minY), rect.minY, accuracy: accuracy)
        XCTAssertEqual(Float(cgRect.maxX), rect.maxX, accuracy: accuracy)
        XCTAssertEqual(Float(cgRect.maxY), rect.maxY, accuracy: accuracy)
    }
    
#endif
    
}

#if canImport(simd)

extension Math.Vector2 {
    var simd: SIMD2<Float> {
        return [x, y]
    }
}

extension Math.Vector3 {
    var simd: SIMD3<Float> {
        return [x, y, z]
    }
}

extension Math.Vector4 {
    var simd: SIMD4<Float> {
        return [x, y, z, w]
    }
}

extension simd_float4x4 {
    init(columnsVector4: [Math.Vector4]) {
        self.init(columnsVector4.map { $0.simd })
    }
}

extension SIMD3 where Scalar == Float {
    var vec: Math.Vector3 {
        return [x, y, z]
    }
}

extension SIMD2 where Scalar == Float {
    var vec: Math.Vector2 {
        return [x, y]
    }
}

extension SIMD4 where Scalar == Float {
    var vec: Math.Vector4 {
        return [x, y, z, w]
    }
}
#endif
