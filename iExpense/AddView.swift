//
//  AddView.swift
//  iExpense
//
//  Created by RANGA REDDY NUKALA on 07/09/20.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
     
    static let types = ["Bussiness","Personal"]
    
    @State private var showingAlert = false
    
    
    var body: some View {
        NavigationView {
            Form {
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                        
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Section(header: Text("Enter name of the Expense")) {
                    TextField("Name", text: $name)
                }
                    
                    
                Section(header: Text("Enter amount of the Expense")) {
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                }
                    
                    
                
                
                
                
            }.navigationBarTitle("Add new Expense")
            .navigationBarItems(leading: Button("Done"){
                addExpense()

            })
            .alert(isPresented: $showingAlert) {
                
                Alert(title: Text("Invalid Amount"), message: Text("Kindly add a proper valid number"), dismissButton: .default(Text("OK")))
                
            }
            
        }
    }
    
    func addExpense() {
        if let finalAmount = Int(amount) {
            let expenseItem = ExpenseItem(name: name, type: type, amount: finalAmount)
            expenses.items.append(expenseItem)
            presentationMode.wrappedValue.dismiss()
            
        } else {
            showingAlert.toggle()
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
