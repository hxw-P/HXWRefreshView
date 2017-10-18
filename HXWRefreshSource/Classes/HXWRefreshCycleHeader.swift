//
//  HXWRefreshCycleHeader.swift
//  51DESK
//
//  Created by 51desk on 2017/8/24.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

class HXWRefreshCycleHeader: HXWRefreshHeader {

    lazy var refreshIndicater: HXWRefreshIndicater = { [unowned self] in
        var indicater = HXWRefreshIndicater()
        return indicater
        }()
    
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLbl)
        addSubview(refreshIndicater)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        refreshIndicater.frame = CGRect (x: 100, y: 20, width: height - 40, height: height - 40)
        textLbl.frame = CGRect (x: refreshIndicater.right + 30, y: 0, width: CalcTextWidth(textStr: "下拉加载", font: textLbl.font, height: height), height: height)
    }
    
    func CalcTextWidth(textStr: String,font: UIFont,height: CGFloat) -> CGFloat {
        let statusLabelText: String = textStr
        let size = CGSize(width: 900, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : AnyObject], context: nil).size
        return strSize.width + 5
    }

}

extension HXWRefreshCycleHeader {
    
    //MARK: /**普通**/
    override func normal() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWPullDownToRefresh)
    }
    
    //MARK: /**即将刷新**/
    override func willRefresh() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWReleaseToRefresh)
    }
    
    //MARK: /**刷新中**/
    override func refreshing() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWRefreshing)
        refreshIndicater.startRotate()
        headerRefreshDelegate?.refresh()
    }
    
    //MARK: /**刷新完成**/
    override func refreshed() {
        textLbl.text = Bundle.HXWLocalizedString(key: HXWPullDownToRefresh)
        refreshIndicater.endRotate()
        refreshIndicater.progress = 0
    }
    
    //MARK: /**更新拖动进度**/
    override func updateProgress() {
        refreshIndicater.progress = progress
    }
    
}

