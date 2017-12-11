//==================
import UIKit
//==================
class ViewController: UIViewController {
    //--------------------
    @IBOutlet weak var wheel: UIImageView!
    @IBOutlet weak var ball: UIView!
    @IBOutlet weak var target: UIView!
    @IBOutlet weak var kobolt: UIImageView!
    //--------------------
    var aTimer: Timer!
    var cos: Double!
    var sin: Double!
    //--------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        ball.layer.cornerRadius = 12.5
        target.layer.cornerRadius = 12.5
    }
    //--------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            kobolt.image = UIImage(named: "kobolt.png")
            if touch.view == self.view {
                if aTimer != nil {
                    aTimer.invalidate()
                    aTimer = nil
                }
                ball.center.x = UIScreen.main.bounds.width / 2
                ball.center.y = UIScreen.main.bounds.height - 260
                target.center.x = touch.location(in: self.view).x
                target.center.y = touch.location(in: self.view).y
                let opp = touch.location(in: self.view).y - (UIScreen.main.bounds.height - 260)
                let adj = touch.location(in: self.view).x - (UIScreen.main.bounds.width / 2)
                let radians = atan2f(Float(opp),Float(adj))
                let degrees = radians * 180 / Float(Double.pi)
                cos = __cospi(Double(degrees/180))
                sin = __sinpi(Double(degrees/180))
                aTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
            }
        }
    }
    //--------------------
    @objc func animate() {
        if ball.frame.intersects(target.frame) {
            kobolt.image = UIImage(named: "KoboldDie.png")
            ball.center.x = target.center.x
            ball.center.y = target.center.y
            aTimer.invalidate()
            aTimer = nil
        }
        ball.center.x += CGFloat(cos)
        ball.center.y += CGFloat(sin)
    }
    //--------------------
}
//==================
