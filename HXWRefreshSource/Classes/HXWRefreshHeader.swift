//
//  HXWRefreshHeader.swift
//  
//
//  Created by 51desk on 2017/5/25.
//
//

import UIKit

open class HXWRefreshHeader: HXWRefreshView{
    
    //MARK: /**刷新状态，根据刷新状态刷新header视图**/
    override var state: HXWRefreshState {
        didSet {
            if state == .normal {
                layoutSubviews()
                normal()
            }
            else if state == .willRefrsh {
                willRefresh()
            }
            else if state == .refreshing {
                refreshing()
            }
            else if state == .refreshed
            {
                refreshed()
            }
            else
            {
                waitNextRefresh()
            }
        }
    }
    //MARK: /**拖动进度，根据拖动进度改变刷新动画**/
    override public var progress: CGFloat {
        didSet {
            updateProgress()
        }
    }
    //MARK: /**刷新结果提示窗**/
    lazy var refreshPointLbl: UILabel = { [unowned self] in
        let lbl = UILabel.init()
        lbl.textColor = .black
        lbl.font = (HXWIPHONE6 ? UIFont.systemFont(ofSize: CGFloat(14)) : UIFont.systemFont(ofSize: CGFloat(14 * HXWIphone6PScale)))
        lbl.backgroundColor = .clear
        lbl.textAlignment = .center
        return lbl
    }()
    var headerHeight = CGFloat(60)//下拉刷新高度
    var refreshedHeaderHeight = CGFloat(60)//刷新后的提示高度
    var refreshedShowTime: Double = 0//刷新后的提示时间，默认为0不提示
    var isRefreshedSuccess = true//是否刷新成功
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        state = .normal//默认普通状态
        textLbl.textAlignment = .left
        addSubview(textLbl)
        addSubview(activityIndicator)
        addSubview(imgIndicator)
        addSubview(refreshPointLbl)
    }
    
    open override func layoutSubviews() {
        if state == .refreshed {
            if refreshedShowTime > 0 {
                refreshPointLbl.frame = CGRect (x: 0, y: height - self.refreshedHeaderHeight, width: width, height: self.refreshedHeaderHeight)
                refreshPointLbl.isHidden = false
                textLbl.isHidden = true
            }
            else {
                refreshPointLbl.isHidden = true
                textLbl.isHidden = false
            }
        }
        else
        {
            refreshPointLbl.isHidden = true
            textLbl.isHidden = false
            imgIndicator.frame = CGRect (x: width/2 - 45, y: (height - 40)/2, width: 15, height: 40)
            activityIndicator.center = imgIndicator.center
            textLbl.frame = CGRect (x: width/2 - 15, y: 0, width: width/2, height: height)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public final func didMoveToSuperview() {
        frame = CGRect (x: 0, y: -headerHeight, width: (contentScrollview?.width)!, height: headerHeight)
    }
    
}

//MARK: /***********************************************刷新过程，自定义header重载以下方法***********************************************/
extension HXWRefreshHeader {
    
    //MARK: /**普通**/
    
    @objc open func normal() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWPullDownToRefresh)
        if upOrDown == "up" {
            upOrDown = "down"
            UIView.animate(withDuration: 0.3, animations: {
                self.imgIndicator.transform = self.imgIndicator.transform.rotated(by: CGFloat(1*Double.pi))
            })
        }
        imgIndicator.isHidden = false
        activityIndicator.isHidden = true;
    }
    
    //MARK: /**即将刷新**/
    @objc open func willRefresh() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWReleaseToRefresh)
        if upOrDown == "down" {
            upOrDown = "up"
            UIView.animate(withDuration: 0.3, animations: {
                self.imgIndicator.transform = self.imgIndicator.transform.rotated(by: CGFloat(1*Double.pi))
            })
        }
    }

    //MARK: /**刷新中**/
    @objc open func refreshing() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWRefreshing)
        if upOrDown == "up" {
            upOrDown = "down"
            UIView.animate(withDuration: 0.3, animations: {
                self.imgIndicator.transform = self.imgIndicator.transform.rotated(by: CGFloat(1*Double.pi))
            })
        }
        imgIndicator.isHidden = true
        activityIndicator.isHidden = false;
        activityIndicator.startAnimating()
        if headerRefreshDelegate != nil {
            headerRefreshDelegate!.refresh()
        }
        if refreshBlock != nil {
            refreshBlock!()
        }
    }
    
    //MARK: /**刷新完成**/
    @objc open func refreshed() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true;
        if refreshedShowTime > 0 {
            //提示刷新结果
            if isRefreshedSuccess {
                refreshPointLbl.text = Bundle.HXWLocalizedString(key: HXWRefreshedSuccess)
            }
            else
            {
                refreshPointLbl.text = Bundle.HXWLocalizedString(key: HXWRefreshedFailed)
            }
        }
        else
        {
            imgIndicator.isHidden = false
            textLbl.text = Bundle.HXWLocalizedString(key: HXWPullDownToRefresh)
        }
    }
    
    //MARK: /**等待下一次刷新**/
    @objc open func waitNextRefresh() {
    }

    //MARK: /**更新拖动进度**/
    @objc open func updateProgress() {
    }

}

//MARK: /***********************************************刷新控制***********************************************/
extension HXWRefreshHeader {
    
    //MARK: /**结束下拉刷新**/
    final func endRefreshing(_ isSuccess: Bool) {
        if state != .refreshing {
            return
        }
        
        isRefreshedSuccess = isSuccess
        state = .refreshed
        
        if refreshedShowTime > 0 {
            //设置刷新结果提示
            if refreshedHeaderHeight != headerHeight {
                self.setNeedsLayout()//刷新后提示刷新成功或者失败,需要重新布局，layoutSubviews有两种布局，一种是刷新完成提示信息时的布局，另一种为正常布局，刷新完成提示信息时的布局只在设置refreshedShowTime后才会调用
                UIView.animate(withDuration: 0.3, animations: {
                    self.contentScrollview?.contentInset = UIEdgeInsetsMake((self.contentScrollview?.contentInset.top)! - self.headerHeight + self.refreshedHeaderHeight, 0, 0, 0);
                }) { (yes) in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(self.refreshedShowTime * 1000)), execute: {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.contentScrollview?.contentInset = UIEdgeInsetsMake((self.contentScrollview?.contentInset.top)! - self.refreshedHeaderHeight, 0, 0, 0);
                        }) { (yes) in
                            self.state = .waitNextRefresh
                        }
                    })
                }
            }
            else
            {
                self.setNeedsLayout()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(self.refreshedShowTime * 1000)), execute: {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.contentScrollview?.contentInset = UIEdgeInsetsMake((self.contentScrollview?.contentInset.top)! - self.headerHeight, 0, 0, 0);
                    }) { (yes) in
                        self.state = .waitNextRefresh
                    }
                })
            }
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.contentScrollview?.contentInset = UIEdgeInsetsMake((self.contentScrollview?.contentInset.top)! - self.headerHeight, 0, 0, 0);
                //结束刷新后设置contentInset是不走contentOffset的kvo方法的，所有state一直为refreshed，直到contentInset动画结束时state变为waitNextRefresh,等到下一次下拉开始再变为normal
            }) { (yes) in
                self.state = .waitNextRefresh
            }
        }
        
    }
    
    //MARK: /**开始下拉刷新**/
    final func startRefreshing() {
        if state != .normal && state != .refreshed {
            return
        }
        state = .refreshing
        progress = 1
        contentScrollview?.contentInset = UIEdgeInsetsMake((contentScrollview?.contentInset.top)! + headerHeight, 0, 0, 0);
    }
    
    //MARK: /**根据拖动距离，切换刷新状态**/
    override public final func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //刷新中和刷新完成状态，对scrollview的拖曳无效
        if (keyPath != "contentOffset")||(state == .refreshing)||(state == .refreshed)||(contentScrollview?.height == 0) {
            return
        }
        guard let point = change?[NSKeyValueChangeKey.newKey] as? CGPoint else {
            return
        }
        let offsetY = CGFloat(0 - point.y)//向下滑动point.y<0
        //        print("offsetY =========== \(offsetY)")
        if (offsetY < 0) {
            return
        }
        
        //MARK: /**触发刷新状态: 处于即将刷新状态，scrollview不在拖动状态**/
        if ((state == .willRefrsh)&&((contentScrollview?.isDragging)! == false)) {
            state = .refreshing
            UIView.animate(withDuration: 0.3, animations: {
                self.contentScrollview?.contentInset = UIEdgeInsetsMake((self.contentScrollview?.contentInset.top)! + self.headerHeight, 0, 0, 0);
            })
            //            print("松手后刷新中 Inset.top =========== \((contentScrollview?.contentInset.top)!)")
        }
        
        //MARK: /**触发即将刷新状态: 处于普通状态或者等待下次刷新状态，向下拖动距离大于默认高度，scrollview在拖动状态**/
        if ((offsetY >= (headerHeight + (contentScrollview?.contentInset.top)!))&&(state == .normal||state == .waitNextRefresh)&&((contentScrollview?.isDragging)!)) {
            state = .willRefrsh
            progress = 1//刷新时进度设为1，防止滑动太快，进度动画来不及完成
        }
        
        //MARK: /**拖动触发普通状态: 不处于普通状态，向下拖动距离小于默认高度，scrollview在拖动状态**/
        if ((offsetY < (headerHeight + (contentScrollview?.contentInset.top)!))&&(state != .normal)&&((contentScrollview?.isDragging)!)) {
            state = .normal
        }
        
        if state == .normal {
            //设置拖动百分比
            progress = (offsetY - (contentScrollview?.contentInset.top)!)/headerHeight
        }
        
    }
    
}
