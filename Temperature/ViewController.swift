//
//  ViewController.swift
//  Temperature
//
//  Created by Antoine DAUGUET on 11/06/2017.
//  Copyright © 2017 Antoine DAUGUET. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    let temperatures = Array(stride(from: 36.0, to: 38.0, by: 0.05).reversed())
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foo()
    }
    
    func foo() {
        if let index = temperatures.index(of: 36.6) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    func addToCalendar(temperature: Double) {
        let store = EKEventStore()
        store.requestAccess(to: .event, completion: { (granted, error) in
            guard granted else {
                if let error = error {
                    print(error)
                }
                return
            }
            let event = EKEvent(eventStore: store)
            event.title = "\(temperature) °C"
            event.startDate = Date()
            event.endDate = event.startDate
            event.calendar = store.defaultCalendarForNewEvents
            do {
                try store.save(event, span: .thisEvent, commit: true)
            } catch {
                print(error)
            }
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func tapAddToCalendar(_ sender: Any) {
        let temperature = temperatures[pickerView.selectedRow(inComponent: 0)]
        let alert = UIAlertController(title: "Ajouter \(temperature)°C ?", message: nil, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Oui", style: .default) { _ in
            self.addToCalendar(temperature: temperature)
        }
        let cancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return temperatures.count
    }
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 100.0)
        let temperatureView = TemperatureView(frame: frame)
        temperatureView.configure(temperature: temperatures[row])
        return temperatureView
    }
}
