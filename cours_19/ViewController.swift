//==================
import UIKit
//==================
class ViewController: UIViewController {
    //--------------------
    @IBOutlet weak var BackGround: UIImageView!
    @IBOutlet weak var ball: UIView!
    @IBOutlet weak var enemyAttack: UIView!
    @IBOutlet weak var target: UIView!
    @IBOutlet weak var kobold: UIImageView!
    @IBOutlet weak var Elminster: UIImageView!
    @IBOutlet weak var Player: UIView!
    //--------------------
    var aTimer: Timer!
    var aTimerEnemy: Timer!
    var cos: Double!
    var sin: Double!
    var distance = 0
    var distanceEnemy = 0
    let loop = true
    //--------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        ball.layer.cornerRadius = 12.5
        target.layer.cornerRadius = 12.5
        enemyAttack.layer.cornerRadius = 12.5
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first!
        if touch.view == Player {
            Player.center.x = touch.location(in: self.view).x
        }
    }
    //--------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if distance == 0 {
            if let touch = touches.first {
                if (touch.location(in: self.view).y > UIScreen.main.bounds.height - Elminster.frame.height ) {
                    return
                }
                kobold.image = UIImage(named: "kobolt.png")
                if touch.view == self.view {
                    if aTimer != nil {
                        aTimer.invalidate()
                        aTimer = nil
                    }
                    ball.center.x = (Player.center.x + 60)
                    ball.center.y = UIScreen.main.bounds.height - 136
                    let opp = touch.location(in: self.view).y - (UIScreen.main.bounds.height - 136)
                    let adj = touch.location(in: self.view).x - (Player.center.x + 60)
                    let radians = atan2f(Float(opp),Float(adj))
                    let degrees = radians * 180 / Float(Double.pi)
                    cos = __cospi(Double(degrees/180))
                    sin = __sinpi(Double(degrees/180))
                    aTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
                }
            }
        }
    }
    //--------------------
    @objc func animate() {
        /*enemyAttack.center.x = target.center.x
        enemyAttack.center.y = target.center.y
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat], animations: {
            
            self.enemyAttack.frame = CGRect(x: self.Player.center.x, y: self.Player.center.y + 200, width: 15, height: 15)
            
        }, completion: nil)*/
        if distance > 1250 {
            aTimer.invalidate()
            aTimer = nil
            distance = 0
            return
        }
        if ball.frame.intersects(target.frame) {
            kobold.image = UIImage(named: "KoboldDie.png")
            ball.center.x = -15
            ball.center.y = -15
            aTimer.invalidate()
            aTimer = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.kobold.image = UIImage(named: "kobolt.png")
                self.target.center.x = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 181)) + 100)
                self.target.center.y = (CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 500)) + 85))
                self.distance = 0
            })
        }
        ball.center.x += CGFloat(cos)
        ball.center.y += CGFloat(sin)
        distance += 1
    }
    //--------------------
    
    //--------------------
  /*  func enemyAttackAnimation() {
        if aTimerEnemy != nil {
            aTimerEnemy.invalidate()
            aTimerEnemy = nil
        }
        aTimerEnemy = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(animateEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func animateEnemy() {
        
        if distanceEnemy > 1250 {
            aTimerEnemy.invalidate()
            aTimerEnemy = nil
            enemyAttack.center.x = target.center.x
            enemyAttack.center.y = target.center.y
            distanceEnemy = 0
            return
        }
        if enemyAttack.frame.intersects(Player.frame) {
            Elminster.image = UIImage(named: "KoboldDie.png")
            enemyAttack.center.x = target.center.x
            enemyAttack.center.y = target.center.y
            aTimerEnemy.invalidate()
            aTimerEnemy = nil
            distanceEnemy = 0
        }
        enemyAttack.center.x = CGFloat(target.center.x)
        enemyAttack.center.y += CGFloat(1)
        distanceEnemy += 1
    }*/
}
//==================
