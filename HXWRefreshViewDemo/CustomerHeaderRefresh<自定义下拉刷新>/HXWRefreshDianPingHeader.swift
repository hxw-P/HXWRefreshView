//
//  HXWRefreshDianPingHeader.swift
//  51DESK
//
//  Created by 51desk on 2017/8/28.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit
import HXWRefreshView

class HXWRefreshDianPingHeader: HXWRefreshHeader {

    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.frame = CGRect(x: 0, y: 0, width: 50*progress, height: 50*progress)
        imageView.center = CGPoint(x: width/2.0, y: (height - imageView.height/2 - 5))
    }

}

extension HXWRefreshDianPingHeader {
    
    //MARK: /**普通**/
    override func normal() {
    }
    
    //MARK: /**即将刷新**/
    override func willRefresh() {
    }
    
    //MARK: /**刷新中**/
    override func refreshing() {
        headerRefreshDelegate?.refresh()
        let images = ["dropdown_loading_01","dropdown_loading_02","dropdown_loading_03"].map { (name) -> UIImage in
            return UIImage(named:name)!
        }
        imageView.animationImages = images
        imageView.animationDuration = Double(images.count) * 0.15
        imageView.startAnimating()
    }
    
    //MARK: /**刷新完成**/
    override func refreshed() {
        imageView.animationImages = nil
        imageView.stopAnimating()
        imageView.image = UIImage (named: "dropdown_loading_03")
    }
    
    //MARK: /**等待下一次刷新**/
    override func waitNextRefresh() {
        progress = 0
    }
    
    //MARK: /**更新拖动进度**/
    override func updateProgress() {
        print("------------%f",progress)
        let imageName = "dropdown_anim__000\(Int(progress * 60))"
        let image = UIImage (named: imageName)
        imageView.image = image
        setNeedsLayout()
    }
    
}
