//
//  ViewController.swift
//  ExchangeSearch
//
//  Created by Jędrzej Kuś on 22/02/2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableChoosed: UISegmentedControl!
    @IBOutlet weak var tableExchange: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var exchangeResults = [Rates]()
    var exchangeDate: String?
    var tableChoosedString = "A"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableExchange.dataSource = self
        tableExchange.delegate = self
        tableExchange.rowHeight = 60
        activityIndicator.hidesWhenStopped = true
        
        tableExchange.register(UINib(nibName: "ExchangeCell", bundle: nil), forCellReuseIdentifier: "ExchangeCell")
        
        //Load data first
        fetchExchanges(with: "A")
        tableExchange.reloadData()
    }
    
    //MARK: - Main methods

    @IBAction func indexChanged(_ sender: Any) {
        
        switch tableChoosed.selectedSegmentIndex {
        case 0:
            print("first table selected")
            fetchExchanges(with: "A")
            tableChoosedString = "A"
        case 1:
            print("secound table selected")
            fetchExchanges(with: "B")
            tableChoosedString = "B"
        case 2:
            print("third table selected")
            fetchExchanges(with: "C")
            tableChoosedString = "C"
        default:
            break
        }
    }
    
    func fetchExchanges(with tableNumber: String) {
        
        self.activityIndicator.startAnimating()
        let exchangeURL = "https://api.nbp.pl/api/exchangerates/tables/"
        
        let url = "\(exchangeURL+tableNumber)/?format=json"
        print(url)
        
        if let url = URL(string: url) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error == nil {
                    let decoder = JSONDecoder()
                    
                    if let safeData = data {
                        do {
                            let results = try decoder.decode([Exchanges].self, from: safeData)
                            
                            //Special delay to show spinner
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            //DispatchQueue.main.async {
                                self.exchangeResults = results[0].rates
                                self.exchangeDate = results[0].effectiveDate
                                self.tableExchange.reloadData()
                                self.activityIndicator.stopAnimating()
                            }
                        } catch { print(error) }
                    }
                }
            }
            task.resume()
        }
    }
}


//MARK: - Extensions

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableExchange.dequeueReusableCell(withIdentifier: "ExchangeCell", for: indexPath) as? ExchangeCell else { return UITableViewCell() }
        
        let exchange = exchangeResults[indexPath.row]
        
        cell.selectionStyle = .none
        cell.codeLabel.text = exchange.code
        cell.nameLabel.text = exchange.currency
        cell.dateLabel.text = exchangeDate
        cell.rateLabel.text = String(round(exchange.mid * 100) / 100)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToRateScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToRateScreen") {
            
            let RateVC = segue.destination as! RateViewController
            
            if let indexPath = tableExchange.indexPathForSelectedRow {

                let exchange = exchangeResults[indexPath.row]
                RateVC.currencyName = exchange.currency
                RateVC.currencyCode = exchange.code
                RateVC.tableChoosedString = tableChoosedString
            }
        }
    }
    
}
