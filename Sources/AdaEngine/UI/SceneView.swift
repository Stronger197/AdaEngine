//
//  SceneView.swift
//  
//
//  Created by v.prusakov on 1/9/23.
//

public class SceneView: View {
    
    public let sceneManager: SceneManager
    
    public override var window: Window? {
        didSet {
            self.sceneManager.window = self.window
        }
    }
    
    public required init(frame: Rect) {
        self.sceneManager = SceneManager()
        super.init(frame: frame)
    }
    
    public convenience init(scene: Scene, frame: Rect) {
        self.init(frame: frame)
        self.sceneManager.presentScene(scene)
    }
    
    override func frameDidChange() {
        super.frameDidChange()
    }
    
    public override func update(_ deltaTime: TimeInterval) {
        self.sceneManager.update(deltaTime)
    }
    
}
