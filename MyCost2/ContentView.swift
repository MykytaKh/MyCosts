//
//  ContentView.swift
//  MyCost2
//
//  Created by Никита Хламов on 15.10.2021.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable { //подписали эту структуру на протокол "Identifiable" чтобы экземпляры этой стуктуры могли быть идинтифицированы уникально с помощью "UUID".
    //подписали эту структуру на протокол "Codable" чтобы объкты внутри структуры можно было архивировать и разархивировать (в нашем случае при помощи "JSONEncoder").
    var id = UUID() //universally unique identifier(UUID) - присваевает каждому itemy идентификатор в 16ричной системе исчесления.
    let name: String
    let type: String
    let amount: Int
} //Создали структуру, которая представляет собой одну затрату.

class Expenses: ObservableObject { //создали класс в котором будем хранить массив затрат в одной переменной.
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") { //можем прочитать нашу затрату по ключу, с помощью "UserDefaults"
            let decoder = JSONDecoder() //далее мы её декодируем из формата JSON снова в строку.
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) { //далее просим decoder конвертировать данные которые получили от UserDefaults в массив ExpenseItem.
                self.items = decoded //мы присваиваем результирующий массив к массиву items, в противном случае items будет пустым массивом.
                return
            }
        }
    }
}

struct ContentView: View {
    
    @State private var showingAddExpense = false //Это нужно для того чтобы использовать sheet.
    
    @ObservedObject var expenses = Expenses() //тут мы просим SwiftUi наблюдать за "expenses" и когда @Published свойство "items" меняется - у нас всё вью будет обновляться.
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    //ForEach(expenses.items, id: \.name) { item in - можно было бы написать так, если бы структура "ExpenseItem" не была подписана на протокол "Identifiable". Тогда при помощи "id: \.name" - мы говорим ForEach идентифицировать каждый элемент в массиве items по его имени. И затем ниже "Text(item.name)" - распечатывать это имя в качестве ряда в нашем списке.
                    HStack {
                        VStack(alignment: .leading) { //выравнивание по левому краю
                            Text(item.name)  //Создали список в котором увидим наши затраты!
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                    }
                }
                .onDelete(perform: removeItems) //создали кнопку, чтобы удалять строки, используя функцию "removeItems", которую создали ниже.
            }
            .navigationBarTitle("Мои расходы")
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showingAddExpense = true //при нажатии на кнопку будем переходить на второе вью.
            }) {
                Image(systemName: "plus")
            }
            )
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: self.expenses)
            }
        }
    }
    func removeItems(as offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}


































struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
