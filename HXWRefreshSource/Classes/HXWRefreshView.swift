//
//  HXWRefreshView.swift
//  51DESK
//
//  Created by 51desk on 2017/5/24.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

public typealias HXWRefreshBlock = () -> ()

//MARK: /**判断设备尺寸**/
let HXWIPHONE6 = (CGSize(width: CGFloat(414), height: CGFloat(736)).equalTo(UIScreen.main.bounds.size) ? false : true)//判断是否6p以下
let HXWIPHONE5_Only = (CGSize(width: CGFloat(320), height: CGFloat(568)).equalTo(UIScreen.main.bounds.size) ? true : false)//判断是否5
let HXWIPHONE6_Only = (CGSize(width: CGFloat(375), height: CGFloat(667)).equalTo(UIScreen.main.bounds.size) ? true : false)//判断是否6
let HXWIphone6PScale = 1.1

enum HXWRefreshState {
    case normal//普通状态
    case willRefrsh//即将刷新
    case refreshing//刷新中
    case refreshed//刷新完成
    case waitNextRefresh//等待下一次刷新(刷新完成后回到普通状态)
}

public protocol HXWRefreshHeaderDelegate {
    //MARK: /**下拉刷新**/
    func refresh()
}

public protocol HXWRefreshFooterDelegate {
    //MARK: /**加载更多**/
    func loadMore()
}

open class HXWRefreshView: UIView, UIScrollViewDelegate {

    weak var contentScrollview: UIScrollView? {
        didSet
        {
            contentScrollview?.addSubview(self)
            contentScrollview?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    public var refreshBlock: HXWRefreshBlock?//下拉刷新和上拉加载回调
    public var headerRefreshDelegate: HXWRefreshHeaderDelegate?
    public var footerRefreshDelegate: HXWRefreshFooterDelegate?
    public var progress: CGFloat = 0//拖动百分比
    
    var upOrDown = "down"//箭头方向
    var state: HXWRefreshState = .normal
    
    lazy var textLbl: UILabel = { [unowned self] in
        let lbl = UILabel.init()
        lbl.textColor = .black
        lbl.font = (HXWIPHONE6 ? UIFont.systemFont(ofSize: CGFloat(14)) : UIFont.systemFont(ofSize: CGFloat(14 * HXWIphone6PScale)))
        lbl.backgroundColor = .clear
        lbl.textAlignment = .center
        return lbl
    }()
    //菊花
    lazy var activityIndicator: UIActivityIndicatorView = { [unowned self] in
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return activity
    }()
    //箭头
    lazy var imgIndicator: UIImageView = { [unowned self] in
        let img = UIImageView.init()
        
        img.image = (UIImage(contentsOfFile: (Bundle.HXWRefreshBundle?.path(forResource: "HXWRefeshView_Arrow@2x", ofType: "png"))!)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        img.tintColor = .gray;
        //UIImageRenderingModeAutomatic        // 根据图片的使用环境和所处的绘图上下文自动调整渲染模式(默认属性)。
        //UIImageRenderingModeAlwaysOriginal   // 始终绘制图片原始状态，设置Tint Color属性无效。
        //UIImageRenderingModeAlwaysTemplate   // 始终根据Tint Color绘制图片（颜色）显示，忽略图片的颜色信息（也就是图片原本的东西是不显示的）。
        //        imgV.backgroundColor = .red;
        return img
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: /**当控制器被回收时移除观察者**/
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            superview?.removeObserver(self, forKeyPath: "contentOffset")
            self.removeFromSuperview()
        }
    }

}
