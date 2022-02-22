//
//  ViewController.swift
//  ExchangeSearch
//
//  Created by Jędrzej Kuś on 22/02/2022.
//

import UIKit

class MainViewController: UIViewController {
    
    var Exchanges: [Exchange] = [
        Exchange(date: "date", name: "bat (Tajlandia)", code: "THB", value: 0.1238),
        Exchange(date: "date", name: "dolar amerykański", code: "USD", value: 4.012),
        Exchange(date: "date", name: "dolar australijski", code: "AUD", value: 2.8919)
    ]
    
    @IBOutlet weak var tableChoosed: UISegmentedControl!
    @IBOutlet weak var tableExchange: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableExchange.dataSource = self
        tableExchange.delegate = self
    }

    @IBAction func indexChanged(_ sender: Any) {
        switch tableChoosed.selectedSegmentIndex {
        case 0:
            print("first table selected")
        case 1:
            print("secound table selected")
        case 2:
            print("third table selected")
        default:
            break
        }
    }
    
}

//MARK: - Extensions

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Exchanges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableExchange.dequeueReusableCell(withIdentifier: "ExchangeCell", for: indexPath)
        cell.textLabel?.text = Exchanges[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
