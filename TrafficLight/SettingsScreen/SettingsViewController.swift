//
//  SettingsViewController.swift
//  TrafficLight
//
//  Created by Dmitriy Opryatnov on 12/5/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var sliderValueLabel: UILabel!

    @IBOutlet private weak var openTrafficLighterScreen: UIButton!
    private var currentValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openTrafficLighterScreen.layer.cornerRadius = 17
        slider.value = Float(currentValue)
        slider.maximumValue = SecondsConstantModel.secondsToEnd
        sliderValueLabel.text = "\(currentValue)"
    }
    
    @IBAction private func openTrafficLighterScreen(_ sender: UIButton) {
        UserDefaults.standard.set(currentValue, forKey: "Seconds")
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController
            if let vc = vc {
                vc.modalTransitionStyle = .flipHorizontal
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            if let vc = vc {
                vc.modalTransitionStyle = .flipHorizontal
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        currentValue = Int(sender.value)
        sliderValueLabel.text = "\(currentValue)"
        
    }
}
