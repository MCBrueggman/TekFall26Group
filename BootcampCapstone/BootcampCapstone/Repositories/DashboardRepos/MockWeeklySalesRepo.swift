//
//  MockWeeklySalesRepo.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/9/26.
//


import Foundationclass MockWeeklySalesRepo: RepositoryProtocol<WeeklySales> {        func getAll() async throws -> [WeeklySales] {        return [            WeeklySales(                salesDate: Date(),                totalSales: 12500.00,                totalProfit: 4200.00            ),            WeeklySales(                salesDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,                totalSales: 11800.00,                totalProfit: 3900.00            ),            WeeklySales(                salesDate: Calendar.current.date(byAdding: .day, value: -14, to: Date())!,                totalSales: 13200.00,                totalProfit: 4500.00            ),            WeeklySales(                salesDate: Calendar.current.date(byAdding: .day, value: -21, to: Date())!,                totalSales: 10900.00,                totalProfit: 3500.00            )        ]    }        func getById(_ id: WeeklySales.ID) async throws -> WeeklySales? {        return nil    }        func insert(_ item: WeeklySales) async throws -> WeeklySales {        throw URLError(.unsupportedURL)    }        func update(_ item: WeeklySales) async throws {        throw URLError(.unsupportedURL)    }        func delete(_ item: WeeklySales) async throws {        throw URLError(.unsupportedURL)    }}