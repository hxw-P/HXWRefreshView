//
//  HXWRefreshIndicater.swift
//  51DESK
//
//  Created by 51desk on 2017/5/27.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

let HXWRefreshIndicaterLineWidth = CGFloat(2)//旋转框宽度

class HXWRefreshIndicater: UIView {

    //设置进度值，重绘旋转框
    var progress: CGFloat = 0 {
        didSet {
            if progress >= 0.95 {
                progress = 0.95
            }
            setNeedsDisplay()
        }
    }
    //MARK: /**旋转框图层**/
    lazy var cycLayer: CAShapeLayer = { [unowned self] in
        var shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.strokeColor = UIColor.init(red: 226, green: 0, blue: 36, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = HXWRefreshIndicaterLineWidth
        shapeLayer.lineJoin = kCALineJoinRound//终点处理
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 1.0
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    //MARK: /**提示窗旋转**/
    func startRotate() {
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        // 2.设置动画的属性
        rotationAnim.toValue = 2*Double.pi
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 0.5;
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        rotationAnim.isRemovedOnCompletion = false
        // 3.将动画添加到layer中
        layer.add(rotationAnim, forKey: "rotateAnimation")
    }
    
    //MARK: /**提示窗停止旋转**/
    func endRotate() {
        // 移除旋转动画
        layer.removeAnimation(forKey: "rotateAnimation")
    }

    override func draw(_ rect: CGRect) {
        //MARK: /**UIBezierPath绘制旋转框圆形路径**/
        let cycPath = UIBezierPath()
        // radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise true为顺时针，false为逆时针
        cycPath.addArc(withCenter: CGPoint (x: width/2, y: height/2), radius: (width - 2*HXWRefreshIndicaterLineWidth)/2, startAngle: CGFloat(-Double.pi/2), endAngle: progress*CGFloat(2*Double.pi) + CGFloat(-Double.pi/2), clockwise: true)
        cycLayer.path = cycPath.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
