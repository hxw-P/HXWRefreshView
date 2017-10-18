//
//  HXWBundleExtension.swift
//  HXWRefreshView
//
//  Created by 51desk on 2017/10/9.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

public extension Bundle{
    
    //单例类写法
    public static var HXWRefreshBundle:Bundle? {
        struct StaticBundle {
            static let rbundle : Bundle = Bundle(path: Bundle(for: HXWRefreshView.classForCoder()).path(forResource: "Resource", ofType: "bundle")!)!
        }
        return StaticBundle.rbundle
    }
    
    public static var HXWLanguageBundle:Bundle?{
        var language = Locale.preferredLanguages.first
        if (language?.hasPrefix("en"))! {
            language="en"
        }else if (language?.hasPrefix("zh"))! {
            if ((language?.range(of: "Hans")) != nil) {
                language="zh-Hans"
            }else{
                //zh-Hant\zh-HK\zh-TW
                language="zh-Hant"
            }
        }else{
            language="en"
        }
        return Bundle(path: (Bundle.HXWRefreshBundle?.path(forResource: language, ofType: "lproj"))!)
    }
        
    public class func HXWLocalizedString(key:String) -> String? {
        let valueReal = self.HXWLanguageBundle?.localizedString(forKey: key, value: nil, table: nil)
        //自己的配置文件重新改数据，不修改就用默认的
        return self.main.localizedString(forKey: key, value: valueReal, table: nil)
    }
    
}
