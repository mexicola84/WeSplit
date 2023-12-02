//
//  ContentView.swift
//  WeSplit
//
//  Created by Jan Grimm on 29.11.23.
//

import SwiftUI

//Day 24 challenge: if you choose 0% tip, the total amount including tip is colored red. Therefore there is a ViewModifier and an extension that's making the VM easy to implement.
struct Knauser: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.red)
    }
}

extension View {
    func knauserStyle() -> some View {
        modifier(Knauser())
    }
}



struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    //to make the numpad go away, you have to check if it is in focus.
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalAmount: Double {
        let tipSelection = Double(tipPercentage)
        
        let tipValues = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValues
        
        return grandTotal
    }
    
    var totalPerPerson: Double {
        //add 2 to people count because of the picker ranging from 2 to 99 and our number of People start at 2.
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    //Locale takes the users preferences, in this case the currency. Currency is seen as optional as the user may not have a preferred currency set up. This is why there is a default value of USD set.
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    //We don't want the user to write text in the text field, so we defined that another kind of keyboard type is shown when you click in the text field.
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused) // Check if keyboard is in focus
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    //to implement the picker style, have to wrap the sections in a navigation stack which is making sure, different views can be loaded.
                    //.pickerStyle(.navigationLink)
                }
                
                //to add a title to a section, simply put a string into parantheses.
                Section ("How much do you want to tip?"){
 
                    
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<101) {
                            Text("\($0) %")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section ("Total Amount including Tip") {
                    if tipPercentage == 0 {
                        // if tip is 0% the total amount is shown in red.
                        Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .knauserStyle()
                    } else {
                        Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                }
                
                Section ("Amount per person"){
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            //Titles inside the nav stack, because there can be different views inside the nav stack, which allows for the titles to change dynamicially and to have nice "back" buttons with the corresponding title.
            .navigationTitle("WeSplit")
            //add a button in the toolbar area if the numpad is onscreen (in focus) to make it disapper.
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
