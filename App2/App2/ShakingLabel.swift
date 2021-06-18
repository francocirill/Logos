import UIKit
/*
 Animazione per scuotere i label
 */
@IBDesignable
class ShakingLabel: UILabel {
    
    
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x-4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x+4, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
    
    public override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
        }
    
}
