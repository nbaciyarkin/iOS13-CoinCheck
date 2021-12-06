import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(price: String, currency: String, coinName: String)
    func didFailedWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "API-KEY-HERE"

    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","TL"]
    
    let cryptoArray = ["BTC","DOGE","ETH","GRT","USDT","ADA","XRP","DOT","SOL","BCH","BUSD","TRX","CAKE","ATOM","BTT","COMP","TFUEL","PROM","FUN","TOMO","REQ","DODO","MVL"]
    
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String, for crypto: String) {
        
        let urlString = "\(baseURL)/\(crypto)/\(currency)?apikey=\(apiKey)"

        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    let coinPrice = self.parseJSON(safeData)
                    
                    let priceString = String(format: "%.2f", coinPrice ?? "no data for coin price")
                    self.delegate?.didUpdateCoin(price: priceString, currency: currency, coinName: crypto)
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        do {
            
            //try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //Get the last property from the decoded data.
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
           
        } catch {
            
            //Catch and print any errors.
            self.delegate?.didFailedWithError(error: error)
            return nil
        }
        
    }
    
}

