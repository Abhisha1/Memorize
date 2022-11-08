//
//  Pie.swift
//  Memorize
//
//  Created by Abhisha Nirmalathas on 8/11/2022.
//

import SwiftUI

struct Pie: Shape {
    // need to be var so they can be animated
    var startAngle: Angle
    var endAngle: Angle
    
    // must be var if someone wants to specify as a dif value
    var clockWise: Bool  = false
    
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let radius = min(rect.width, rect.height) / 2
        
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
            )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockWise)
        p.addLine(to: center)
        return p
    }
}
