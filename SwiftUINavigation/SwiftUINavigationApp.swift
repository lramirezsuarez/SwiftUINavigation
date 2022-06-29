//
//  SwiftUINavigationApp.swift
//  SwiftUINavigation
//
//  Created by Luis Alejandro Ramirez Suarez on 5/03/22.
//

import SwiftUI

@main
struct SwiftUINavigationApp: App {
    let keyboard = Item(name: "Keyboard", color: .blue, status: .inStock(quantity: 100))
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init(inventoryViewModel: .init(
                    inventory: [
                        .init(item: keyboard, route: .duplicate(keyboard)),
                        .init(item: Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20))),
                        .init(item: Item(name: "Phone", color: .green, status: .outOfStock(isOnBackOrder: true))),
                        .init(item: Item(name: "Headphones", color: .green, status: .outOfStock(isOnBackOrder: false))),
                    ]), selectedTab: .inventory
            ))
        }
    }
}
