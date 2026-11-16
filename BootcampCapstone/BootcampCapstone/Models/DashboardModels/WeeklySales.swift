//
//  Dashboard.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/1/26.
//

import Foundation

class WeeklySales: Codable, Identifiable {
    let salesDate: Date
    let totalSales: Double
    let totalProfit: Double
    var id: Date{
        salesDate
    }
    init(salesDate: Date, totalSales: Double, totalProfit: Double){
        self.salesDate = salesDate
        self.totalSales = totalSales
        self.totalProfit = totalProfit
    }
}
