//
//  Menu.swift
//  iDine
//
//  Created by Paul Hudson on 27/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

struct MenuSection: Codable,Identifiable {
    var id: UUID
    var name: String
    var items: [MenuItem]
}

struct MenuItem: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var photo: String
    //var price: Int
    var color: String

    #if DEBUG
    static let example = MenuItem(id: UUID(), name: "water", photo: "water", color: "blue")
    #endif
 
}
        

struct DrinksType: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Drink.entity(), sortDescriptors: []) var drinkData: FetchedResults<Drink>
    
    let drinksMenu = Bundle.main.decode([MenuSection].self, from: "drinks.json")
    let drinkSelected: String = "Water"
    
    var body: some View {
    
        VStack{
    
        
           
                List{
                    ForEach(drinksMenu) { section in
                        Section(header: Text(section.name)) {
                            ForEach(section.items) { item in
                                
                                DrinksRow(item:item)
                                    /* .onTapGesture {
                                        self.addDrink(requestDrink: item.name)
                                    }
                                    */
                            }
                        }
                    }
                }
                .navigationBarTitle("Select Drink", displayMode: .inline)
                //.navigationBarHidden(true)
                .listStyle(GroupedListStyle())
            
        }
     
        
        
}
    
/*
 func addDrink(requestDrink: String) {
        let newDrink = Drink(context: context)
        newDrink.id = UUID()
        newDrink.drinkName = requestDrink
        
        do {
            try context.save()
        } catch {
            print(error)
        }
}
*/
}

struct DrinksRow: View{
    var item: MenuItem
    
    var body: some View{
        NavigationLink(destination: BeerView(item:item)){
            
         HStack{
            Image(item.photo)
            VStack(alignment: .leading){
                Text(item.name)
            }
        }
    }
    }}


struct DrinksType_Previews: PreviewProvider {
    static var previews: some View {
        DrinksType()
    }
}
