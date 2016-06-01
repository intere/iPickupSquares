//
//  Globals.swift
//  iPickThingsUp
//
//  Created by Internicola, Eric on 3/8/16.
//  Copyright © 2016 iColasoft. All rights reserved.
//

import UIKit

/**
 Gets you a random number (CGFloat) between 0 and 1.
 - Returns: A pseudo-random number between 0 and 1.
 */
func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
}