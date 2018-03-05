//
//  RDSegmentedControl.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

class RDSegmentedControl: UISegmentedControl
{
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let previousIndex = selectedSegmentIndex

        super.touchesEnded(touches, with: event)

        if previousIndex == selectedSegmentIndex
        {
            let touchLocation = touches.first!.location(in: self)
            if bounds.contains(touchLocation) {sendActions(for: .valueChanged)}
        }
    }
}
