//
//  DrawingHeatmapView.swift
//  DepthPrediction-CoreML
//
//  Created by Doyoung Gwak on 20/07/2019.
//  Copyright © 2019 Doyoung Gwak. All rights reserved.
//

import UIKit

class DrawingHeatmapView: UIView {
    
    var heatmap: Array<Array<Double>>? = nil {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        
        if let ctx = UIGraphicsGetCurrentContext() {
            
            ctx.clear(rect);
            
            guard let heatmap = self.heatmap else { return }
            
            let size = self.bounds.size
            let heatmap_w = heatmap.count
            let heatmap_h = heatmap.first?.count ?? 0
            let w = size.width / CGFloat(heatmap_w)
            let h = size.height / CGFloat(heatmap_h)
            
            for j in 0..<heatmap_h {
                for i in 0..<heatmap_w {
                    let value = heatmap[i][j]
                    var alpha: CGFloat = CGFloat(value)
                    if alpha > 1 {
                        alpha = 1
                    } else if alpha < 0 {
                        alpha = 0
                    }
                    
                    let rect: CGRect = CGRect(x: CGFloat(i) * w, y: CGFloat(j) * h, width: w, height: h)
                    
                    // color
                    //let hue: CGFloat = alpha * (240.0 / 360.0)
                    //let color: UIColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.94)

                    // gray
                    var color: UIColor = UIColor(white: 1-alpha, alpha: 1)
                    
                    let bpath: UIBezierPath = UIBezierPath(rect: rect)
                    
                    color.set()
                    //bpath.stroke()
                    bpath.fill()
                }
            }
            
            // Adding a crosshair at the center of the box to show where the depth detection is located
            let crosshair_l: CGRect = CGRect(x: CGFloat(79)*w-5, y: CGFloat(63)*h, width: 10, height: 1)
            let crosshair_r: CGRect = CGRect(x: CGFloat(79)*w, y: CGFloat(63)*h-5, width: 1, height: 10)
            
            let color: UIColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
            let bpath_l: UIBezierPath = UIBezierPath(rect: crosshair_l)
            let bpath_r: UIBezierPath = UIBezierPath(rect: crosshair_r)
            
            color.set()
            bpath_l.fill()
            bpath_r.fill()
        }
    } // end of draw(rect:)

}
