//
//  ViewController.swift
//  TrafficLight
//
//  Created by Dmitriy Opryatnov on 12/5/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var redView: UIView!
    @IBOutlet private weak var yelowView: UIView!
    @IBOutlet private weak var greenView: UIView!
    @IBOutlet private weak var mainTrafficLihtView: UIView!
    @IBOutlet private weak var postView: UIView!
    
    @IBOutlet private weak var redTimeLabel: UILabel!
    @IBOutlet private weak var greenTimeLabel: UILabel!
    
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var settingsButton: UIButton!
    
    private var secondsToSwitch: Int = 0
    private var timer: Timer?
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewsUI()
        configureLabelsUI()
        configureButtonsUI()
        if let value = defaults.value(forKey: "Seconds") as? Int {
            secondsToSwitch = value
        }
//            UserDefaults.standard.set(currentValue, forKey: "Seconds")
//            SecondsConstantModel.secondsToEnd
    }
    
    private func configureViewsUI() {
        redView.layer.cornerRadius = redView.frame.width / 2
        yelowView.layer.cornerRadius = yelowView.frame.width / 2
        greenView.layer.cornerRadius = greenView.frame.width / 2
        
        redView.backgroundColor = .systemRed
        yelowView.backgroundColor = .systemYellow
        greenView.backgroundColor = .systemGreen
        postView.backgroundColor = .systemGray
        
        mainTrafficLihtView.backgroundColor = .clear
        mainTrafficLihtView.layer.borderWidth = 1
        mainTrafficLihtView.layer.borderColor = UIColor.black.cgColor
        mainTrafficLihtView.layer.cornerRadius = 5
        
        redView.alpha = 0.3
        yelowView.alpha = 0.3
        greenView.alpha = 0.3
    }
    
    private func configureLabelsUI() {
        redTimeLabel.text = nil
        greenTimeLabel.text = nil
    }
    
    private func configureButtonsUI() {
        settingsButton.layer.cornerRadius = 17
        startButton.layer.cornerRadius = 17
        stopButton.layer.cornerRadius = 17
        
        startButton.setTitle("START", for: .normal)
        stopButton.setTitle("STOP", for: .normal)
        
        stopButton.isEnabled = false
        stopButton.backgroundColor = .systemGray
        stopButton.setTitle("STOP", for: .disabled)
    }
    
    @IBAction private func goToSettingsScreen(_ sernder: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func startButtonPressed(_ sender: UIButton) {
        startTimer()
        startButton.isEnabled = false
        startButton.backgroundColor = .systemGray
        startButton.setTitle("START", for: .disabled)
        
        stopButton.isEnabled = true
        stopButton.backgroundColor = .systemTeal
        stopButton.setTitle("STOP", for: .normal)
    }
    
    @IBAction private func stopButtonPressed(_ sender: UIButton) {
        startButton.setTitle("START", for: .normal)
        startButton.isEnabled = true
        startButton.backgroundColor = .systemTeal
        
        stopButton.isEnabled = false
        stopButton.backgroundColor = .systemGray
        stopButton.setTitle("STOP", for: .disabled)
        
        timer?.invalidate()
        timer = nil
        redView.alpha = 0.3
        yelowView.alpha = 0.3
        greenView.alpha = 0.3
        self.greenView.backgroundColor = .systemGreen
        redTimeLabel.text = nil
        greenTimeLabel.text = nil
        if let value = defaults.value(forKey: "Seconds") as? Int {
            secondsToSwitch = value
        }
    }
    
    private func startTimerForRedView() {
        redTimeLabel.text = "\(secondsToSwitch)"
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeSecondsToSwitchRedView), userInfo: nil, repeats: true)
        }
    }
    
    private func startTimer() {
        greenView.alpha = 1
        greenTimeLabel.text = "\(secondsToSwitch)"
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeSecondsToSwitch), userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        secondsToSwitch = 0
        greenView.alpha = 0.3
        greenView.backgroundColor = .systemGreen
        yelowView.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 1.7, options: []) { [self] in
            yelowView.alpha = 0.3
            redView.alpha = 1
        } completion: { _ in
            if let value = self.defaults.value(forKey: "Seconds") as? Int {
                self.secondsToSwitch = value
            }
            self.startTimerForRedView()
        }
    }
    
    private func stopTimerForRedView() {
        timer?.invalidate()
        timer = nil
        secondsToSwitch = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: []) { [self] in
            yelowView.alpha = 0.3
            redView.alpha = 0.3
        } completion: { _ in
            if let value = self.defaults.value(forKey: "Seconds") as? Int {
                self.secondsToSwitch = value
            }
            self.startTimer()
        }
    }
    
    @objc private func changeSecondsToSwitchRedView() {
        if secondsToSwitch >= 1 {
            secondsToSwitch -= 1
            redTimeLabel.text = "\(secondsToSwitch)"
        } else {
            redTimeLabel.text = nil
            stopTimerForRedView()
            return
        }
        changeRedViewAlpha(secondsToSwitch: secondsToSwitch)
    }
    
    @objc private func changeSecondsToSwitch() {
        secondsToSwitch -= 1
        if secondsToSwitch >= 1 {
            greenTimeLabel.text = "\(secondsToSwitch)"
        } else {
            greenTimeLabel.text = nil
            stopTimer()
            return
        }
        changeAlpha(secondsToSwitch: secondsToSwitch)
    }
    
    private func changeAlpha(secondsToSwitch: Int) {
        if secondsToSwitch < 6 && secondsToSwitch % 2 == 0 {
            greenView.alpha = 0.7
            greenView.backgroundColor = .clear
        } else if secondsToSwitch <= 6 && secondsToSwitch % 2 != 0 {
            greenView.alpha = 1
            greenView.backgroundColor = .systemGreen
        }
    }
    
    private func changeRedViewAlpha(secondsToSwitch: Int) {
        if secondsToSwitch < 1 {
            redView.alpha = 1
            yelowView.alpha = 1
            redTimeLabel.text = nil
        }
    }
}
