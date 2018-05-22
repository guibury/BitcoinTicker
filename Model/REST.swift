//
//  REST.swift
//  BitcoinTicker
//
//  Created by Guilherme Bury on 21/05/2018.
//  Copyright © 2018 Guilherme Bury. All rights reserved.
//

import Foundation

protocol ResponseDelegate: class {
    func didReceiveResponse(bitcoin: Bitcoin)
}

enum ResponseError {
    case url
    case noResponse
    case noData
    case invalidJSON
    case responseStatusCode(code: Int)
}

class REST {
    
    weak var delegate: ResponseDelegate?
    
    func loadCurrency(with url: String) {
        guard let url = URL(string: url) else {
            print(ResponseError.url)
            return
        }
        
        //MARK: - Data task
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            
            if error == nil {
                guard let response = urlResponse as? HTTPURLResponse else {
                    print(ResponseError.noResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {
                        print(ResponseError.noData)
                        return
                    }
                    do {
                        //MARK: - JSON Parsing
                        let bitcoin = try JSONDecoder().decode(Bitcoin.self, from: data)
                        self.delegate?.didReceiveResponse(bitcoin: bitcoin)
                    } catch {
                        print(ResponseError.invalidJSON)
                    }
                } else {
                    print(ResponseError.responseStatusCode(code: response.statusCode))
                }
            } else {
                print(error!)
            }
        }
        
        dataTask.resume()
    }
}
