//
//  ContentView.swift
//  iExpense
//
//  Created by RANGA REDDY NUKALA on 06/09/20.
//

import SwiftUI

//enum ExpenseType {
//    case credit
//    case debit
//}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}

struct ContentView: View {
    
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    
    

    var body: some View {
        
        NavigationView {
                List {
                    ForEach(expenses.items) { item in
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name.capitalized)
                                    .font(.headline)
                                            Text(item.type)
                                                .font(.footnote)
                            }
                            Spacer()
                            Text("Rs.\(item.amount)")
                        }
                    }
                    .onDelete(perform: { indexSet in
                        removeItems(at: indexSet)
                    })
                }.navigationBarTitle("iExpense")
                .navigationBarItems(trailing: Button(action: {
                    showingAddExpense.toggle()
                }, label: {
                    Image(systemName: "plus")
                }).sheet(isPresented: $showingAddExpense, content: {
                    AddView(expenses: expenses)
                }))

        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
