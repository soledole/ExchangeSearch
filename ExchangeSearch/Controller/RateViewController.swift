//
//  RateViewController.swift
//  ExchangeSearch
//
//  Created by Jędrzej Kuś on 25/02/2022.
//

import UIKit

class RateViewController: UIViewController {
  
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var tableRate: UITableView!
    
    var currencyName = ""
    var currencyCode = ""
    var tableChoosedString = ""
    let currentDate = Date()
    var ratesResults = [Rates2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyNameLabel.text = currencyName
        tableRate.register(UINib(nibName: "RateCell", bundle: nil), forCellReuseIdentifier: "RateCell")
        
        tableRate.dataSource = self
        tableRate.dataSource = self
        tableRate.rowHeight = 60
        tableRate.refreshControl = UIRefreshControl()
        tableRate.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        toDatePicker.isEnabled = false
        fromDatePicker.date = moveDaysInDate(from: currentDate, by: -1)
        fromDatePicker.maximumDate = moveDaysInDate(from: currentDate, by: -1)
        fromDatePicker.minimumDate = moveDaysInDate(from: currentDate, by: -367)
        toDatePicker.maximumDate = currentDate
    }
    
    //MARK: - Main methods
    
    @IBAction func fromActionDP(_ sender: Any) {
        
        toDatePicker.isEnabled = true
        toDatePicker.minimumDate = moveDaysInDate(from: fromDatePicker.date, by: 1)
    }
    
    @IBAction func toActionDP(_ sender: Any) {
        
        fetchRates(from: getStringFromDate(with: fromDatePicker.date), to: getStringFromDate(with: toDatePicker.date))
    }
    
    func fetchRates(from date: String, to date2: String) {
        
        let rateURL = "https://api.nbp.pl/api/exchangerates/rates/"
        
        let url = "\(rateURL+tableChoosedString)/\(currencyCode)/\(date)/\(date2)/?format=json"
        print(url)
        
        if let url = URL(string: url) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error == nil {
                    let decoder = JSONDecoder()
                    
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(Rate.self, from: safeData)
                            
                            //Special delay to show spinner
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            //DispatchQueue.main.async {
                                self.ratesResults = results.rates
                                self.tableRate.reloadData()
                                self.tableRate.refreshControl?.endRefreshing()
                            }
                        } catch { print(error) }
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Secondary methods
    
    private func getStringFromDate(with date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: date)
        
        return date
    }
    
    private func moveDaysInDate(from date: Date, by days: Int) -> Date {
        
        var dateComponent = DateComponents()
        dateComponent.day = days
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
        
        return futureDate!
    }
    
    @objc private func didPullToRefresh() {
        
        fetchRates(from: getStringFromDate(with: fromDatePicker.date), to: getStringFromDate(with: toDatePicker.date))
    }
    
}

//MARK: - Extensions

extension RateViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratesResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableRate.dequeueReusableCell(withIdentifier: "RateCell", for: indexPath) as? RateCell else { return UITableViewCell() }
        
        let rate = ratesResults[indexPath.row]
        
        cell.selectionStyle = .none
        cell.dateLabel.text = rate.effectiveDate
        cell.rateLabel.text = String(round(rate.mid * 100) / 100)
        
        return cell
    }
    
}
