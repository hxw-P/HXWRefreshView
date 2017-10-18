//
//  HXWRefreshFooter.swift
//  51DESK
//
//  Created by 51desk on 2017/5/25.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

open class HXWRefreshFooter: HXWRefreshView{
    
    //MARK: /**刷新状态，根据刷新状态刷新footer视图**/
    override var state: HXWRefreshState {
        didSet {
            if state == .normal {
                if noMoreData {
                    normalStateNoMore()
                }
                else
                {
                    normalStateHasMore()
                }
            }
            else if state == .willRefrsh {
                willRefresh()
            }
            else if state == .refreshing {
                if isLoading == false {
                    isLoading = true
                    refreshing()
                }
            }
            else
            {
                if noMoreData {
                    refreshedNoMore()
                }
                else
                {
                    refreshedHasMore()
                }
            }
        }
    }
    //MARK: /**刷新按钮，可以点击刷新**/
    lazy var refreshBtn: UIButton = { [unowned self] in
        var btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(tapRefreshBtn), for: .touchUpInside)
        return btn
    }()
    open var footerHeight = CGFloat(50)//上拉加载高度
    var originalHeight: CGFloat?//初始scrollView的高度，判断内容(高度)是否变化
    var noMoreData = false//是否有多页标志
    var isInstant = false//是否没有松开加载那个状态
    var isTail = false//是否tableview的bottom要缩进一直显示footer
    var isLoading = false//是否在加载中，避免点击refreshBtn重复加载
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        state = .normal
        addSubview(textLbl)
        addSubview(refreshBtn)
    }
    
    @objc func tapRefreshBtn() {
        if noMoreData == false {
            state = .refreshing
        }
    }
    
    override open func layoutSubviews() {
        if isTail {
            if self.contentScrollview?.contentSize.height != 0 {
                //有数据内容时加footer
                frame = CGRect (x: 0, y: (contentScrollview?.contentSize.height)!, width: (contentScrollview?.width)!, height: footerHeight)
                self.contentScrollview?.contentInset = UIEdgeInsetsMake((self.contentScrollview?.contentInset.top)!, 0, footerHeight, 0);
            }
        }
        else
        {
            if Float((contentScrollview?.height)!) > Float((contentScrollview?.contentSize.height)!) {
                //contentScrollview没有铺满，不设footerView
                frame = CGRect.zero
                return
            }
            else
            {
                frame = CGRect (x: 0, y: (contentScrollview?.contentSize.height)!, width: (contentScrollview?.width)!, height: footerHeight)
            }
        }
        originalHeight = contentScrollview?.contentSize.height
        textLbl.frame = CGRect (x: 0, y: 0, width: width, height: height)
        refreshBtn.frame = textLbl.frame
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: /***********************************************加载过程，自定义footer重载以下方法***********************************************/
extension HXWRefreshFooter {
    
    //MARK: /**普通状态下已到最后一页**/
    @objc open func normalStateNoMore() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWLoadedNoMore)
    }
    
    //MARK: /**普通状态下未到最后一页**/
    @objc open func normalStateHasMore() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWLoadedHasMore)
    }
    
    //MARK: /**即将加载更多**/
    @objc open func willRefresh() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWReleaseToLoadMore)
    }
    
    //MARK: /**加载中**/
    @objc open func refreshing() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWLoadingMore)
        if footerRefreshDelegate != nil {
            footerRefreshDelegate?.loadMore()
        }
        if refreshBlock != nil {
            refreshBlock!()
        }
    }
    
    //MARK: /**刷新完成已到最后一页**/
    @objc open func refreshedNoMore() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWLoadedNoMore)
    }
    
    //MARK: /**刷新完成未到最后一页**/
    @objc open func refreshedHasMore() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWLoadedHasMore)
    }
    
    //MARK: /**更新拖动进度**/
    @objc open func updateProgress() {
    }
    
}

//MARK: /***********************************************加载控制***********************************************/
extension HXWRefreshFooter {

    //MARK: /**结束上啦加载更多**/
    final func endLoadMore(_ isSuccess: Bool,isNoMoreData: Bool) {
        if state != .refreshing {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            if self.isTail {
                self.contentScrollview?.contentInset = UIEdgeInsetsMake((self.contentScrollview?.contentInset.top)!, 0, self.footerHeight, 0);
            }
            else
            {
                self.contentScrollview?.contentInset = UIEdgeInsetsMake((self.contentScrollview?.contentInset.top)!, 0, 0, 0);
            }
        }) { (yes) in
            self.noMoreData = isNoMoreData
            self.isLoading = false
            if isSuccess {
                self.state = .refreshed
            }
            else
            {
                self.state = .normal
            }
        }
        
    }
    
    //MARK: /**只有一页**/
    final func noMore() {
        noMoreData = true
        state = .normal
    }
    
    //MARK: /**有多页**/
    final func hasMore() {
        noMoreData = false
        state = .normal
    }
    
    //MARK: /**根据拖动距离，切换刷新状态**/
    override public final func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //MARK: /**如果scrollView内容有增减，重新调整refreshFooter位置**/
        if contentScrollview?.contentSize.height != originalHeight {
            layoutSubviews()
        }
        
        if (keyPath != "contentOffset")||(state == .refreshing)||noMoreData||(contentScrollview?.height == 0||Float((contentScrollview?.height)!) > Float((contentScrollview?.contentSize.height)!)) {
            return
        }
        guard let point = change?[NSKeyValueChangeKey.newKey] as? CGPoint else {
            return
        }
        let offsetY = point.y//向上滑动point.y>0  在navigation下初始为-64
        print("offsetY =========== \(offsetY)")
        
        if isInstant {
            //MARK: /**这种是上拉加载后直接触发加载状态**/
            //MARK: /**触发加载状态: 处于普通状态，向上拖动距离大于原本高度**/
            if ((offsetY >= ((contentScrollview?.contentSize.height)! - (contentScrollview?.height)! + footerHeight + (contentScrollview?.contentInset.bottom)!))&&(state == .normal)) {
                state = .refreshing
            }
        }
        else
        {
            //MARK: /**这种是上拉加载后松开后触发加载状态**/
            //MARK: /**触发加载状态: 处于即将刷新状态，向上拖动距离大于原本高度，scrollview不在拖动状态**/
            if ((state == .willRefrsh)&&((contentScrollview?.isDragging)! == false)) {
                state = .refreshing
                contentScrollview?.contentInset = UIEdgeInsetsMake((contentScrollview?.contentInset.top)!, 0, footerHeight, 0);
            }
            
            //MARK: /**触发即将加载状态: 处于普通状态，向上拖动距离大于原本高度**/
            if ((offsetY >= ((contentScrollview?.contentSize.height)! - (contentScrollview?.height)! + footerHeight + (contentScrollview?.contentInset.bottom)!))&&(state == .normal)) {
                state = .willRefrsh
            }
        }
        
        //MARK: /**触发普通状态: 不处于普通状态，向上拖动距离小于原本高度，scrollview在拖动状态**/
        if ((offsetY < ((contentScrollview?.contentSize.height)! - (contentScrollview?.height)! + footerHeight))&&(state != .normal)&&(contentScrollview?.isDragging)!) {
            state = .normal
        }
        
    }

}
