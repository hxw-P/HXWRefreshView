//
//  HXWTotalViewController.swift
//  HXWRefreshDemo
//
//  Created by 51desk on 2017/8/30.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

class HXWTotalViewController: UIViewController {

    var myTableView = UITableView()
    var dataAry = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        myTableView.showsVerticalScrollIndicator = true
        myTableView.showsHorizontalScrollIndicator = true
        myTableView.estimatedRowHeight = 44
        myTableView.frame = view.bounds
        view.addSubview(myTableView)
        
        dataAry = ["普通下拉刷新","有刷新完成提示","仿大众点评下拉刷新","普通上啦加载","没有松开后加载状态的上啦加载","有尾巴的上拉加载，可点击加载更多"]
    }

}

//MARK: /**UITableView代理**/
extension HXWTotalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell .init(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = dataAry[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        present(HXWTableRefreshController(), animated: true, completion: nil)
        let tableRefresh = HXWTableRefreshController()
        tableRefresh.type = dataAry[indexPath.row] as NSString
        navigationController?.pushViewController(tableRefresh, animated: true)
    }
    
}
