//
//  WeakSet.swift
//  
//
//  Created by v.prusakov on 7/3/22.
//

struct WeakSet<T: AnyObject>: Sequence {
    
    typealias Element = T
    typealias Iterator = WeakIterator
    
    var buffer: Set<WeakBox<T>>
    
    class WeakIterator: IteratorProtocol {
        
        let buffer: [WeakBox<T>]
        let currentIndex: UnsafeMutablePointer<Int>
        
        init(buffer: Set<WeakBox<T>>) {
            self.buffer = Array(buffer.filter { !$0.isEmpty })
            self.currentIndex = UnsafeMutablePointer<Int>.allocate(capacity: 1)
            self.currentIndex.pointee = -1
        }
        
        deinit {
            self.currentIndex.deallocate()
        }
        
        func next() -> Element? {
            
            self.currentIndex.pointee += 1
            
            if buffer.endIndex == self.currentIndex.pointee {
                return nil
            }
            
            return buffer[self.currentIndex.pointee].value
        }
        
    }
    
    @inlinable func makeIterator() -> Iterator {
        return WeakIterator(buffer: self.buffer)
    }
    
    mutating func insert(_ member: T) {
        var buffer = self.buffer.filter { !$0.isEmpty }
        buffer.insert(WeakBox(value: member))
        self.buffer = buffer
    }
    
    mutating func remove(_ member: T) {
        self.buffer.remove(WeakBox(value: member))
    }
}

extension WeakSet: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = T
    
    init(arrayLiteral elements: ArrayLiteralElement...) {
        self.buffer = Set(elements.map { WeakBox(value: $0) })
    }
}
