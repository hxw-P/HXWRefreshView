//
//  HXWTableRefreshController.swift
//  HXWRefreshDemo
//
//  Created by 51desk on 2017/8/30.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit
import HXWRefreshView

let ISIPHONEX = (CGSize(width: CGFloat(375), height: CGFloat(812)).equalTo(UIScreen.main.bounds.size) ? true : false)//判断是否IphoneX

class HXWTableRefreshController: UIViewController {
    
    var myTableView = UITableView()
    var dataAry = [String]()
    var firstPageAry = [String]()
    var type: NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myTableView)
        myTableView.frame = CGRect (x: 0, y: 0, width: view.width, height: view.height)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        myTableView.showsVerticalScrollIndicator = true
        myTableView.showsHorizontalScrollIndicator = true
        myTableView.estimatedRowHeight = 44
        if #available(iOS 11.0, *) {
            // iOS 11 及其以上系统运行
            myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never;//解决刷新后弹屏
            myTableView.contentInset = UIEdgeInsetsMake( (ISIPHONEX ? 88 : 64), 0, 0, 0);//iPhoneX这里是88
            myTableView.scrollIndicatorInsets = myTableView.contentInset;//解决scrollview头部进入navibar 已下
        }

        if type == "普通下拉刷新" {
            //代理回调
//            myTableView.hxw_addRefreshHeaderView(refreshHeader: HXWRefreshHeader(), delegate: self)
            //block回调
            myTableView.hxw_addRefreshHeaderView(refreshHeader: HXWRefreshHeader()) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                    self.dataAry = self.firstPageAry
                    self.myTableView.reloadData()
                    self.myTableView.endRefreshing(false)
                    self.myTableView.hasMore()
                }
            }
        }
        else if type == "有刷新完成提示" {
            myTableView.hxw_addRefreshHeaderView(refreshHeader: HXWRefreshHeader(), delegate: self, refreshHeaderHeight: 60, refreshedShowTime: 0.5, refreshedHeaderHeight: 40)
        }
        else if type == "仿大众点评下拉刷新" {
            myTableView.hxw_addRefreshHeaderView(refreshHeader: HXWRefreshDianPingHeader(), delegate: self, refreshHeaderHeight: 60)
        }
        else if type == "普通上啦加载" {
            myTableView.hxw_addRefreshHeaderView(refreshHeader: HXWRefreshHeader(), delegate: self)
            myTableView.hxw_addRefreshFooterView(refreshFooter: HXWRefreshFooter(), delegate: self, refreshFooterHeight: 60, isInstant: false, isTail: false)
        }
        else if type == "没有松开后加载状态的上啦加载" {
            myTableView.hxw_addRefreshHeaderView(refreshHeader: HXWRefreshHeader(), delegate: self)
            myTableView.hxw_addRefreshFooterView(refreshFooter: HXWRefreshFooter(), delegate: self, refreshFooterHeight: 60, isInstant: true, isTail: false)
        }
        else if type == "有尾巴的上拉加载，可点击加载更多" {
            myTableView.hxw_addRefreshHeaderView(refreshHeader: HXWRefreshHeader(), delegate: self)
            myTableView.hxw_addRefreshFooterView(refreshFooter: HXWRefreshFooter(), refreshFooterHeight: 60, isInstant: true, isTail: true) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                    for i in (self.dataAry.count - 1) ..< (self.dataAry.count + 5) {
                        self.dataAry.append("第\(i + 1)行")
                    }
                    self.myTableView.reloadData()
                    if self.dataAry.count > 30 {
                        self.myTableView.endLoadMore(true, isNoMoreData: true)
                    }
                    else
                    {
                        self.myTableView.endLoadMore(true, isNoMoreData: false)
                    }
                }
//                if (Int(arc4random()%100)+1) > 50 {
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
//                        //上拉加载失败
//                        self.myTableView.endLoadMore(false, isNoMoreData: false)
//                    }
//                }
//                else
//                {
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
//                        for i in (self.dataAry.count - 1) ..< (self.dataAry.count + 5) {
//                            self.dataAry.append("第\(i + 1)行")
//                        }
//                        self.myTableView.reloadData()
//                        if self.dataAry.count > 30 {
//                            self.myTableView.endLoadMore(true, isNoMoreData: true)
//                        }
//                        else
//                        {
//                            self.myTableView.endLoadMore(true, isNoMoreData: false)
//                        }
//                    }
//                }
            }
        }

        if type == "有尾巴的上拉加载，可点击加载更多" {
            for i in 0 ..< 5 {
                firstPageAry.append("第\(i)行")
            }
        }
        else
        {
            for i in 0 ..< 20 {
                firstPageAry.append("第\(i)行")
            }
        }

        myTableView.startRefreshing()
    }

}

//MARK: /**HXWRefreshHeader代理**/
extension HXWTableRefreshController: HXWRefreshHeaderDelegate {
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.dataAry = self.firstPageAry
            self.myTableView.reloadData()
            self.myTableView.endRefreshing(false)
            self.myTableView.hasMore()
        }
    }
    
}

//MARK: /**HXWRefreshFooterDelegate代理**/
extension HXWTableRefreshController: HXWRefreshFooterDelegate {
    
    func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            for i in (self.dataAry.count - 1) ..< (self.dataAry.count + 20) {
                self.dataAry.append("第\(i + 1)行")
            }
            self.myTableView.reloadData()
            if self.dataAry.count > 100 {
                self.myTableView.endLoadMore(true, isNoMoreData: true)
            }
            else
            {
                self.myTableView.endLoadMore(true, isNoMoreData: false)
            }
        }
    }
    
}

//MARK: /**UITableView代理**/
extension HXWTableRefreshController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell .init(style: .default, reuseIdentifier: cellIdentifier)
            let line = UIView.init()
            line.backgroundColor = .lightGray
            line.frame = CGRect (x: 10, y: 43, width: view.width, height: 1)
            cell?.contentView.addSubview(line)
        }
        cell?.textLabel?.text = dataAry[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
