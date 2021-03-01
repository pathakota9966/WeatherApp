//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by apple on 01/03/21.
//

import UIKit
protocol SettingsDelegate {
    func didUpdateUnitsWith(_ isMetriEnabled:Bool)
}
class SettingsViewController: UIViewController {
    var settingsDelegate: SettingsDelegate?
    let defaults = UserDefaults.standard
    var switchON : Bool = true
    @IBOutlet weak var unitSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User Settins"
        if defaults.value(forKey: "switchON") != nil{
            let switchON: Bool = defaults.value(forKey: "switchON")  as! Bool
            if switchON == true {
                unitSwitch.setOn(true, animated: false)
            }
            else if switchON == false{
                unitSwitch.setOn(false, animated: false)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if (sender.isOn == true) {
            switchON = true
            defaults.set(switchON, forKey: "switchON")
            settingsDelegate?.didUpdateUnitsWith(true)
        }
        if (sender.isOn == false) {
            switchON = false
            defaults.set(switchON, forKey: "switchON")
            settingsDelegate?.didUpdateUnitsWith(false)
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func userHelpClicked(_ sender: Any) {
        //TODO
        //WebView has to open with instructions
    }
    
}
