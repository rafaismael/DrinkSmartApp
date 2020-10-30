//
//  ContentView.swift
//  DrinkSmart
//
//  Created by Rafael Oliveira on 2020-10-30.
//

import Foundation
import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var globalString: GlobalString
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Drink.entity(), sortDescriptors:[]) var drinkData: FetchedResults<Drink>
    
    @State private var dateAdded = Date()
    
    var body: some View {
        
        NavigationView{
            VStack{
                HStack{
                    Form{
                        DatePicker("Date", selection: $globalString.selectedDate, displayedComponents: .date)
                    }
                }
                    NavigationLink(destination: DrinksType()){
                        Text("Add")}
            }
        }
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
