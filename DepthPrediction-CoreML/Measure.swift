//
//  Measure.swift
//  TurtleApp-CoreML
//
//  Created by GwakDoyoung on 03/07/2018.
//  Copyright © 2018 GwakDoyoung. All rights reserved.
//

import UIKit

protocol MeasureDelegate {
    func updateMeasure(inferenceTime: Double, executionTime: Double, fps: Int, dist: Double)
}
// Performance Measurement
class Measure {
    
    var delegate: MeasureDelegate?
    var distance: Double = 2.0
    var index: Int = -1
    var measurements: [Dictionary<String, Double>]
    
    init() {
        print("initializing object")
        let measurement = [
            "start": CACurrentMediaTime(),
            "end": CACurrentMediaTime()
        ]
        measurements = Array<Dictionary<String, Double>>(repeating: measurement, count: 30)
    }
    
    // start
    func start() {
        index += 1
        index %= 30
        measurements[index] = [:]
        
        label(for: index, with: "start")
    }
    
    // stop
    func stop(conf: Double) {
        label(for: index, with: "end")
        
        // let heatMap = HeatmapPostProcessor()
        let beforeMeasurement = getBeforeMeasurment(for: index)
        let currentMeasurement = measurements[index]
        if let startTime = currentMeasurement["start"],
            let endInferenceTime = currentMeasurement["endInference"],
            let endTime = currentMeasurement["end"],
            let beforeStartTime = beforeMeasurement["start"] {
            delegate?.updateMeasure(inferenceTime: endInferenceTime - startTime,
                                    executionTime: endTime - startTime,
                                    fps: Int(1/(startTime - beforeStartTime)),
                                    dist: conf)
                                    
        }
        
    }
    
    // labeling with
    func label(with msg: String? = "") {
        label(for: index, with: msg)
    }
    
    private func label(for index: Int, with msg: String? = "") {
        if let message = msg {
            measurements[index][message] = CACurrentMediaTime()
        }
    }
    
    private func getBeforeMeasurment(for index: Int) -> Dictionary<String, Double> {
        return measurements[(index + 30 - 1) % 30]
    }
    
    // log
    func log() {
        
    }
    
}

class MeasureLogView: UIView {
    let etimeLabel = UILabel(frame: .zero)
    let fpsLabel = UILabel(frame: .zero)
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
