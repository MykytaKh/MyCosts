//
//  AddView.swift
//  MyCost2
//
//  Created by Никита Хламов on 15.10.2021.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode //чтобы после сохранения затраты второе вью закрывалось.
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    
    let types = ["Personal", "Business"]
    var body: some View {
        NavigationView {
            Form {
                TextField("Название", text: $name)
                Picker("Тип", selection: $type) {
                    ForEach(self.types, id: \.self) {
                        Text($0) //Для каждого элемента в массиве "types" мы распечатываем его название! При этом при помощи "id: \.self" - SwiftUI будет идентифицировать каждый элемент по его названию.
                    }
                }
                TextField("Стоимость", text: $amount)
                    .keyboardType(.numberPad) //чтобы в этой строке была клавиатура только с цифрами.
            }
            .navigationBarTitle("Добавить")
            .navigationBarItems(trailing: Button("Сохранить") {
                if let actualAmount = Int(self.amount) { //сделали проверку на nil
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss() //после сохранения затраты второе вью закрывается.
                }
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
