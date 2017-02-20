//
//  PuzzleTimer.swift
//  CollectionViewCatPicPuzzle
//
//  Created by ac on 2/19/17.
//  Copyright © 2017 Flatiron School. All rights reserved.
//

import Foundation

import UIKit

class PuzzleTimer {
    var timer: Timer!
    let timeInterval: TimeInterval = 0.05
    var timeCount: TimeInterval = 0.0
    var timerLabel: UILabel!

    
    init() {
        configureView()
    }

private func configureView() {
    print("In PuzzleTimer: configureView")
    timerLabel = UILabel()
    //timerLabel.font = UIFont.helveticaNeueLight(size: 20)
    
    //self.addSubview(timerLabel)
    
    //timerLabel.translatesAutoresizingMaskIntoConstraints = false
    //timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    //timerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    
}

func startTimer() {
    
    timeCount = 0.0
    timerLabel.text = timeString(time: timeCount)
    timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                 target: self,
                                 selector: #selector(countUp),
                                 userInfo: nil,
                                 repeats: true)
    
}

@objc private func countUp() {
    timeCount = timeCount + timeInterval
    timerLabel.text = timeString(time: timeCount)
}

private func timeString(time:TimeInterval) -> String {
    let minutes = Int(time) / 60
    let seconds = time - Double(minutes) * 60
    return String(format:"%02i:%02i",minutes,Int(seconds))
}
}
