//
//  Vector2.swift
//  
//
//  Created by v.prusakov on 8/12/21.
//

import Foundation

// TODO: (Vlad) Create object aka CGFloat for float or doubles
// TODO: (Vlad) when move to new vector object, we should use same object size

public struct Vector2: Hashable, Equatable, Codable {
    public var x: Float
    public var y: Float
    
    @inline(__always)
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}

public extension Vector2 {
    @inline(__always)
    init(_ scalar: Float) {
        self.x = scalar
        self.y = scalar
    }
    
    @inline(__always)
    init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
}

extension Vector2: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Float...) {
        assert(elements.count == 2)
        self.x = elements[0]
        self.y = elements[1]
    }
}

public extension Vector2 {
    subscript(_ index: Int) -> Float {
        get {
            switch index {
            case 0:
                return x
            case 1:
                return y
            default:
                fatalError("Index out of range.")
            }
        }
        
        set {
            switch index {
            case 0:
                self.x = newValue
            case 1:
                self.y = newValue
            default: fatalError("Index out of range.")
            }
        }
    }
}

public extension Vector2 {
    @inline(__always)
    var squaredLength: Float {
        return x * x + y * y
    }
    
    @inline(__always)
    var normalized: Vector2 {
        let length = self.squaredLength
        return self / sqrt(length)
    }
    
    @inline(__always)
    func dot(_ vector: Vector2) -> Float {
        return x * vector.x + y * vector.y
    }
}

// MARK: Math Operations

public extension Vector2 {
    
    // MARK: Scalar
    
    @inline(__always)
    static func * (lhs: Vector2, rhs: Float) -> Vector2 {
        return [lhs.x * rhs, lhs.y * rhs]
    }
    
    @inline(__always)
    static func + (lhs: Vector2, rhs: Float) -> Vector2 {
        return [lhs.x + rhs, lhs.y + rhs]
    }
    
    @inline(__always)
    static func - (lhs: Vector2, rhs: Float) -> Vector2 {
        return [lhs.x - rhs, lhs.y - rhs]
    }
    
    @inline(__always)
    static func / (lhs: Vector2, rhs: Float) -> Vector2 {
        return [lhs.x / rhs, lhs.y / rhs]
    }
    
    @inline(__always)
    static func * (lhs: Float, rhs: Vector2) -> Vector2 {
        return [lhs * rhs.x, lhs * rhs.y]
    }
    
    @inline(__always)
    static func + (lhs: Float, rhs: Vector2) -> Vector2 {
        return [lhs + rhs.x, lhs + rhs.y]
    }
    
    @inline(__always)
    static func - (lhs: Float, rhs: Vector2) -> Vector2 {
        return [lhs - rhs.x, lhs - rhs.y]
    }

    @inline(__always)
    static func / (lhs: Float, rhs: Vector2) -> Vector2 {
        return [lhs / rhs.x, lhs / rhs.y]
    }
    
    @inline(__always)
    static func *= (lhs: inout Vector2, rhs: Float) {
        lhs = lhs * rhs
    }
    
    @inline(__always)
    static func -= (lhs: inout Vector2, rhs: Float) {
        lhs = lhs - rhs
    }
    
    @inline(__always)
    static func /= (lhs: inout Vector2, rhs: Float) {
        lhs = lhs / rhs
    }
    
    @inline(__always)
    static func += (lhs: inout Vector2, rhs: Float) {
        lhs = lhs + rhs
    }
    
    // MARK: Vector
    
    @inline(__always)
    static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return [lhs.x + rhs.x, lhs.y + rhs.y]
    }
    
    @inline(__always)
    static func * (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return [lhs.x * rhs.x, lhs.y * rhs.y]
    }
    
    @inline(__always)
    static func - (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return [lhs.x - rhs.x, lhs.y - rhs.y]
    }
    
    @inline(__always)
    static func / (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return [lhs.x / rhs.x, lhs.y / rhs.y]
    }
    
    @inline(__always)
    static func *= (lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs * rhs
    }
    
    @inline(__always)
    static func += (lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs + rhs
    }
    
    @inline(__always)
    static func -= (lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs - rhs
    }
    
    @inline(__always)
    static func /= (lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs / rhs
    }
}

extension Vector2 {
    public var description: String {
        return String(describing: type(of: self)) + "(\(x), \(y))"
    }
}

public extension Vector2 {
    @inline(__always)
    static let zero: Vector2 = Vector2(0)
    
    @inline(__always)
    static let one: Vector2 = Vector2(1)
}

public typealias Point = Vector2

public extension Point {
    func applying(_ affineTransform: Transform2D) -> Point {
        let point = (affineTransform * Vector3(self.x, self.y, 1))
        return [point.x, point.y]
    }
}

// swiftlint:enable identifier_name
