//
//  Color.swift
//  Moment
//
//  Created by QingTian Chen on 2/27/16.
//  Copyright © 2016 QingTian Chen. All rights reserved.
//

import UIKit

class Color: UIColor {
    class func twitterBlue() -> UIColor {
        return UIColor(hue: 205/360, saturation: 64/100, brightness: 93/100, alpha: 1.0) /* #55acee */
    }
    
    class func twitterBlack() -> UIColor {
        return UIColor(hue: 204/360, saturation: 19/100, brightness: 20/100, alpha: 1.0) /* #292f33 */
    }
    
    class func twitterGrayDark() -> UIColor {
        return UIColor(hue: 204/360, saturation: 19/100, brightness: 49/100, alpha: 1.0) /* #66757f */
    }
    
    class func twitterGray() -> UIColor {
        return UIColor(hue: 204/360, saturation: 7/100, brightness: 86/100, alpha: 1.0) /* #ccd6dd */
    }
    
    class func twitterGrayLight() -> UIColor {
        return UIColor(hue: 203/360, saturation: 5/100, brightness: 92/100, alpha: 1.0) /* #e0e8ed */
    }
}
