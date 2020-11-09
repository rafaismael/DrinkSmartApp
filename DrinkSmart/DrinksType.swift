//
//  DrinksType.swift
//  DrinkSmart
//
//  Created by Rafael Oliveira on 2020-10-30.
//

import SwiftUI

struct DrinksType: View {
    
    @State private var filterDrink = ""
    
    var body: some View {
     
        NavigationView{
        VStack{
            Image("waveadd")
                .resizable()
                .frame(width:.infinity, height: 190)
                .offset(x: 0, y: -160)
                .edgesIgnoringSafeArea(.horizontal)
            
            TextField("Procurar", text: $filterDrink).offset(x: 0, y: -240) .textFieldStyle(RoundedBorderTextFieldStyle()).frame(width:300)
            
            
            HStack(alignment: .top){
                
                if filterDrink == "" || filterDrink == "W" || filterDrink == "Wa" || filterDrink == "Wat" || filterDrink == "Wate" || filterDrink == "Water"  {
               
                    NavigationLink(destination: BeerView()){
                        Image("water").resizable().frame(width: 50, height:75).padding()}
                    }
                    
                
                if filterDrink == "" || filterDrink == "W" || filterDrink == "Wi" || filterDrink == "Win" || filterDrink == "Wine"{
                    Button(action: {
                        // add water
                    }){Image("redwine").resizable().frame(width: 50, height:75).padding()}
                }
                
                if filterDrink == "" || filterDrink == "C" || filterDrink == "Co" || filterDrink == "Cof" || filterDrink == "Coff" || filterDrink == "Coffe" || filterDrink == "Coffee" {
                    Button(action: {
                        // add water
                    }){Image("coffee").resizable().frame(width: 50, height:75).padding()}
                }
                
                if filterDrink == "" || filterDrink == "B" || filterDrink == "Be" || filterDrink == "Bee" || filterDrink == "Beer" {
                    Button(action: {
                        // add water
                    }){Image("beer").resizable().frame(width: 50, height:75).padding()}
                }
                
            }.offset(x: 0, y: -200)
       
            
        }
            
        }
        
}}

struct DrinksType_Previews: PreviewProvider {
    static var previews: some View {
        DrinksType()
    }
}
