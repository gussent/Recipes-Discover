//
//  RDFonts.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

extension UIFont
{
    class func rdBold(_ size: CGFloat)       -> UIFont {return UIFont(name: "AvenirNextCondensed-Bold", size: size)!}
    class func rdDemiBold(_ size: CGFloat)   -> UIFont {return UIFont(name: "AvenirNextCondensed-DemiBold", size: size)!}
    class func rdHeavy(_ size: CGFloat)      -> UIFont {return UIFont(name: "AvenirNextCondensed-Heavy", size: size)!}
    class func rdMedium(_ size: CGFloat)     -> UIFont {return UIFont(name: "AvenirNextCondensed-Medium", size: size)!}
    class func rdRegular(_ size: CGFloat)    -> UIFont {return UIFont(name: "AvenirNextCondensed-Regular", size: size)!}
    class func rdUltraLight(_ size: CGFloat) -> UIFont {return UIFont(name: "AvenirNextCondensed-UltraLight", size: size)!}
}
