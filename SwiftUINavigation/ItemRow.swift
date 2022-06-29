//
//  ItemRow.swift
//  SwiftUINavigation
//
//  Created by Luis Alejandro Ramirez Suarez on 12/05/22.
//

import SwiftUI
import CasePaths

class ItemRowViewModel: Identifiable, ObservableObject {
    @Published var item: Item
    @Published var route: Route?
    
    enum Route {
        case deleteAlert
        case duplicate(Item)
        case edit(Item)
    }
    
    var onDelete: () -> Void = {}
    
    var id: Item.ID { self.item.id }
    
    init(
        item: Item, route: Route? = nil) {
        self.item = item
            self.route = route
    }
    
    func deleteButtonTapped() {
        self.route = .deleteAlert
    }
    
    func deleteConfirmationButtonTapped() {
        self.onDelete()
    }
    
    func editButtonTapped() {
        self.route = .edit(self.item)
    }
    
    func edit(item: Item) {
        self.item = item
        self.route = nil
    }
    
    func cancelButtonTapped() {
        self.route = nil
    }
}

struct ItemRowView: View {
    @ObservedObject var viewModel: ItemRowViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(self.viewModel.item.name)
                
                switch self.viewModel.item.status {
                case let .inStock(quantity):
                    Text("In stock: \(quantity)")
                case let .outOfStock(isOnBackOrder):
                    Text("Out of stock" + (isOnBackOrder ? ": on back order" : ""))
                }
            }
            
            Spacer()
            
            if let color = self.viewModel.item.color {
                Rectangle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color.swiftUIColor)
                    .border(Color.black, width: 1)
            }
            
            Button(
                action: {
                    self.viewModel.editButtonTapped()
                }
            ) {
                Image(systemName: "pencil")
            }
            .padding(.leading)
            
            Button(
                action: {
                    self.viewModel.deleteButtonTapped()
                }
            ) {
                Image(systemName: "trash.fill")
            }
            .padding(.leading)
        }
        .buttonStyle(.plain)
        .foregroundColor(self.viewModel.item.status.isInStock ? nil : Color.gray)
        .alert(self.viewModel.item.name,
               isPresented: self.$viewModel.route.isPresent(/ItemRowViewModel.Route.deleteAlert)
               ,
               actions: {
            Button("Delete", role: .destructive) {
                self.viewModel.deleteConfirmationButtonTapped()
            }
        }, message: {
            Text("Are you sure you want to delete this item?")
        })
                .sheet(unwrap: self.$viewModel.route.case(/ItemRowViewModel.Route.edit)
                ) { $item in
                    NavigationView {
                        ItemView(item: $item)
                            .navigationBarTitle("Edit")
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancel") {
                                        self.viewModel.cancelButtonTapped()
                                    }
                                }
                                ToolbarItem(placement: .primaryAction) {
                                    Button("Save") {
                                        self.viewModel.edit(item: item)
                                    }
                                }
                            }
                    }
                }
    }
}
