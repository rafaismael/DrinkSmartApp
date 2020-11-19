//
//  FilterList.swift
//  DrinkSmart
//
//  Created by Rafael Oliveira on 2020-11-18.
//

import SwiftUI

struct FilterList: View {
    
    @ObservedObject var myGlobalString = GlobalString()
    
    
    var drinkData : FetchRequest<Drink>
    var drinks : FetchedResults<Drink>{drinkData.wrappedValue}
    
        init(filter:Date){
            drinkData = FetchRequest(entity: Drink.entity(), sortDescriptors: [], predicate: NSPredicate(format: "dateAdded >= %@", filter as CVarArg))}
    
   
    var sumMl: Int32 {
        drinkData.wrappedValue.reduce(0) { $0 + $1.drinkMl}
    }
    
    var body: some View {
        
        Text("\(sumMl)")
        
        List {
            ForEach(drinkData.wrappedValue, id: \.self) { (drink:Drink) in
                HStack{
                    Image("\(drink.drinkName?.lowercased() ?? "water")")
                    VStack{
                        Text("\(drink.drinkName!)")
                        Text("\(drink.drinkMl) mL")
                        
                    }
                }
            }
        }
    }
}


