//
//  HeatmapPostProcessor.swift
//  DepthPrediction-CoreML
//
//  Created by Doyoung Gwak on 20/07/2019.
//  Copyright © 2019 Doyoung Gwak. All rights reserved.
//

import CoreML
import UIKit
import AVFoundation

class HeatmapPostProcessor {
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    var lastImpactTime = Date()
    var desiredInterval: Double?
    var hapticTimer: Timer?
    var confidence: Double?
    let measure = Measure()

    init() {
        print("Initializing Heatmap")
        createTimer()
    }
    
    func createTimer() {
        hapticTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if let desiredInterval = self.desiredInterval {
                if -self.lastImpactTime.timeIntervalSinceNow > desiredInterval {
                    self.feedbackGenerator.impactOccurred()
                    self.playSystemSound(id: 1103)
                    self.lastImpactTime = Date()
                }
            }
        }
    }
    /// Play the specified system sound.  If the system sound has been preloaded as an audio player, then play using the AVAudioSession.  If there is no corresponding player, use the `AudioServicesPlaySystemSound` function.
    ///
    /// - Parameter id: the id of the system sound to play
    func playSystemSound(id: Int) {
        AudioServicesPlaySystemSound(SystemSoundID(id))
    }
    func convertTo2DArray(from heatmaps: MLMultiArray) -> (Array<Array<Double>>, Double) {
        guard heatmaps.shape.count >= 3 else {
            print("heatmap's shape is invalid. \(heatmaps.shape)")
            return ([], 0.0)
        }
        let _/*keypoint_number*/ = heatmaps.shape[0].intValue
        let heatmap_w = heatmaps.shape[1].intValue
        let heatmap_h = heatmaps.shape[2].intValue
        
        
        var convertedHeatmap: Array<Array<Double>> = Array(repeating: Array(repeating: 0.0, count: heatmap_w), count: heatmap_h)
        
        var minimumValue: Double = Double.greatestFiniteMagnitude
        var maximumValue: Double = -Double.greatestFiniteMagnitude
        
        for i in 0..<heatmap_w {
            for j in 0..<heatmap_h {
                let index = i*(heatmap_h) + j
                self.confidence = heatmaps[index].doubleValue
                guard self.confidence! > 0 else { continue }
                convertedHeatmap[j][i] = self.confidence!
//                if confidence > 0.25 {
//                    convertedHeatmap[j][i] = 1
//                } else {
//                    convertedHeatmap[j][i] = confidence
//                }
//                if i == Int(heatmap_w/2) && j == Int(heatmap_h/2) {
//                    //desiredInterval = confidence/5
//                    print("depth in the center is \(confidence)")
//                }
                if minimumValue > self.confidence! {
                    minimumValue = self.confidence!
                }
                if maximumValue < self.confidence! {
                    maximumValue = self.confidence!
                }
            }
        }
        let minmaxGap = maximumValue - minimumValue
        
        for i in 0..<heatmap_w {
            for j in 0..<heatmap_h {
                convertedHeatmap[j][i] = (convertedHeatmap[j][i] - minimumValue) / minmaxGap
            }
        }

        // Calculation of how many beeps to run from
        let midpoint = convertedHeatmap[Int(heatmap_w/2)][Int(heatmap_h/2)]
        //let mid_Val = convertedHeatmap.max() - convertedHeatmap.min()
        
        var maxes: Array<Double> = []
        var mins: Array<Double> = []
        
        for i in 0...127 {
            do {
            maxes.append(convertedHeatmap[i].max()!)
            mins.append(convertedHeatmap[i].min()!)
            } catch {
            print("Error calculating max for \(i)")
            }
        }
        
//        print(maxes.max())
//        print(mins.min())
//        if midpoint > 0.25 {
        desiredInterval = (midpoint/maxes.max()!)
//        } else {
//            desiredInterval = 100000
//        }
        
        // print(desiredInterval)
        
        

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: convertedHeatmap, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            if let jsonString = jsonString {
                write(text: jsonString, to: "test1") // Test this further
                // Copying JSONs from terminal also works
            }
            // print(jsonString as Any)
            
        } catch {
            print(error.localizedDescription)
        }
        
        return (convertedHeatmap, self.confidence!)
    }
    
    func write(text: String, to fileNamed: String, folder: String = "SavedFiles") {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".rtf")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
    // this is just to change the git commit enough to re-commit
}


