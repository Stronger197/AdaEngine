//
//  TextAttribute.swift
//  
//
//  Created by v.prusakov on 3/6/23.
//

public protocol TextAttributeKey {
    associatedtype Value: Hashable
    
    static var defaultValue: Value { get }
}

public struct FontTextAttribute: TextAttributeKey {
    public typealias Value = Font
    public static var defaultValue: Font = Font.system(weight: .regular)
}

public struct ForegroundColorTextAttribute: TextAttributeKey {
    public typealias Value = Color
    public static var defaultValue: Color = .black
}

public struct OutlineColorTextAttribute: TextAttributeKey {
    public typealias Value = Color
    public static var defaultValue: Color = .clear
}

public struct KernColorTextAttribute: TextAttributeKey {
    public typealias Value = Float
    public static var defaultValue: Float = 0
}

public extension TextAttributeContainer {
    var foregroundColor: Color {
        get {
            self[ForegroundColorTextAttribute.self] ?? ForegroundColorTextAttribute.defaultValue
        }
        
        set {
            self[ForegroundColorTextAttribute.self] = newValue
        }
    }
    
    var font: Font {
        get {
            self[FontTextAttribute.self] ?? FontTextAttribute.defaultValue
        }
        
        set {
            self[FontTextAttribute.self] = newValue
        }
    }
    
    var outlineColor: Color {
        get {
            self[OutlineColorTextAttribute.self] ?? OutlineColorTextAttribute.defaultValue
        }
        
        set {
            self[OutlineColorTextAttribute.self] = newValue
        }
    }
    
    var kern: Float {
        get {
            self[KernColorTextAttribute.self] ?? KernColorTextAttribute.defaultValue
        }
        
        set {
            self[KernColorTextAttribute.self] = newValue
        }
    }
    
}

public enum LineBreakMode {
    case byCharWrapping
    case byWordWrapping
}

public enum TextAlignment {
    case center
    case trailing
    case leading
}
