//==================
import UIKit
//==================
class ViewController: UIViewController {
    //--------------------
    @IBOutlet weak var BackGround: UIImageView!
    @IBOutlet weak var ball: UIView!
    @IBOutlet weak var enemyAttackView: UIView!
    @IBOutlet weak var enemyAttackImage: UIImageView!
    @IBOutlet weak var target: UIView!
    @IBOutlet weak var monsterImage: UIImageView!
    @IBOutlet weak var Elminster: UIImageView!
    @IBOutlet weak var Player: UIView!
    @IBOutlet weak var expAtual: UIView!
    @IBOutlet weak var fireBall: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var lifeView: UIView!
    @IBOutlet weak var damageView: UIView!
    //--------------------
    var aTimer: Timer!
    var aTimerEnemy: Timer!
    var cos: Double!
    var sin: Double!
    var cosEnemy: Double!
    var sinEnemy: Double!
    var distance = 0
    var distanceEnemy = 0
    let loop = true
    var numberOfAttacks = 0
    var level = 1
    var monsterName: String!
    var monsterSpell: String!
    var monsterImageDead: String!
    //--------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        ball.layer.cornerRadius = 12.5
        target.layer.cornerRadius = 12.5
        enemyAttackView.layer.cornerRadius = 12.5
        monsterName = "lightElemental.png"
        monsterSpell = "lightning.png"
        monsterImageDead = "lightElementalDead.png"
        enemyAttackAnimation()
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first!
        if touch.view == Player {
            Player.center.x = touch.location(in: self.view).x
            lifeView.center.x = Player.center.x
        }
    }
    //--------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if distance == 0 {
            if let touch = touches.first {
                if (touch.location(in: self.view).y > UIScreen.main.bounds.height - Elminster.frame.height ) {
                    return
                }
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
        if distance > 1250 {
            aTimer.invalidate()
            aTimer = nil
            distance = 0
            return
        }
        if ball.frame.intersects(target.frame) {
            if aTimerEnemy != nil {
                aTimerEnemy.invalidate()
                aTimerEnemy = nil
            }
            self.monsterImage.image = UIImage(named: self.monsterImageDead)
            ball.center.x = -150
            ball.center.y = -150
            aTimer.invalidate()
            aTimer = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.experiencia()
                self.target.center.x = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 181)) + 100)
                self.target.center.y = (CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 500)) + 85))
                self.distance = 0
                self.numberOfAttacks = 0
                self.enemyAttackView.center.x = self.target.center.x
                self.enemyAttackView.center.y = self.target.center.y
                self.enemyAttackAnimation()
            })
        }
        ball.center.x += CGFloat(cos)
        ball.center.y += CGFloat(sin)
        distance += 1
    }
    //--------------------
    
    //--------------------
    func enemyAttackAnimation() {
        changeMonsterAttackDirection()
        if aTimerEnemy != nil {
            aTimerEnemy.invalidate()
            aTimerEnemy = nil
        }
        aTimerEnemy = Timer.scheduledTimer(timeInterval: 0.002, target: self, selector: #selector(animateEnemy), userInfo: nil, repeats: true)
    }
    
    func changeMonsterPosition() {
        if numberOfAttacks > 3 {
            self.target.center.x = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 181)) + 100)
            self.target.center.y = (CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 500)) + 85))
            numberOfAttacks = 0
        }
    }
    
    func changeMonsterAttackDirection() {
        self.distanceEnemy = 0
        let opp = CGFloat(arc4random_uniform(500))+(target.center.y - (Player.center.y)) - CGFloat(arc4random_uniform(500))
        let adj = CGFloat(arc4random_uniform(500)) + (target.center.x - (Player.center.x)) - CGFloat(arc4random_uniform(500))
        let radians = atan2f(Float(opp),Float(adj))
        let degrees = radians * 180 / Float(Double.pi)
        enemyAttackView.center.x = target.center.x
        enemyAttackView.center.y = target.center.y
        cosEnemy = __cospi(Double(degrees/180))
        sinEnemy = __sinpi(Double(degrees/180))
    }
    
    @objc func animateEnemy() {
        changeMonsters()
        if distanceEnemy > 1250 {
            distanceEnemy = 0
            numberOfAttacks += 1
            changeMonsterPosition()
            changeMonsterAttackDirection()
            return
        }
        if enemyAttackView.frame.intersects(Player.frame) {
            takeDamage()
            changeMonsterAttackDirection()
            enemyAttackView.center.x = target.center.x
            enemyAttackView.center.y = target.center.y
            distanceEnemy = 0
        }
        enemyAttackView.center.x -= CGFloat(cosEnemy)
        enemyAttackView.center.y -= CGFloat(sinEnemy)
        distanceEnemy += 1
    }
    
    func experiencia() {
        expAtual.frame.size.width += 30
        if expAtual.frame.width >= 240 {
            damageView.frame.size.width = 0
            expAtual.frame.size.width = 0
            ball.frame.size.width += 15
            ball.frame.size.height += 15
            fireBall.frame.size.width += 15
            fireBall.frame.size.height += 15
            level += 1
            levelLabel.text = "LEVEL: " + String(level)
            changeMonsters()
        }
    }
    
    func takeDamage() {
        damageView.frame.size.width += 35
        if damageView.frame.size.width >= 113 {
            damageView.frame.size.width = 113
            Elminster.image = UIImage(named: "ElminsterDieLight.png")
            aTimerEnemy.invalidate()
            aTimerEnemy = nil
        }
    }
    
    func changeMonsters() {
        if (level == 1) {
            monsterImage.image = UIImage(named: "kobolt.png")
            enemyAttackImage.image = UIImage (named: "lightning.png")
            monsterName = "kobolt.png"
            monsterSpell = "lightning.png"
            monsterImageDead = "koboltDie.png"
        } else if (level == 2) {
            monsterImage.image = UIImage(named: "lightElemental.png")
            enemyAttackImage.image = UIImage (named: "lightning.png")
            monsterName = "lightElemental.png"
            monsterSpell = "fireball.png"
            monsterImageDead = "lightElementalDead.png"
            target.frame.size.width = 150
            target.frame.size.width = 188
            monsterImage.frame.size.width = 150
            monsterImage.frame.size.height = 188
        }
        monsterImage.image = UIImage(named: monsterName)
        enemyAttackImage.image = UIImage(named: monsterSpell)
    }
}
//==================
