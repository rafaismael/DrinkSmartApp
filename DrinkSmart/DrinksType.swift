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
      
        
        VStack{
            Image("waveadd")
                .resizable()
                .frame(width:.infinity, height: 200)
                .offset(x: 0, y: -190)
                .edgesIgnoringSafeArea(.horizontal)
            
            TextField("Procurar", text: $filterDrink).offset(x: 0, y: -260) .textFieldStyle(RoundedBorderTextFieldStyle()).frame(width:330)
            
            HStack{
                Button(action: {
                    // add water
                }){ Image("water").resizable().frame(width: 50, height:75).padding()}
                
                Button(action: {
                    // add water
                }){Image("redwine").resizable().frame(width: 50, height:75).padding()}
                
                Button(action: {
                    // add water
                }){Image("coffee").resizable().frame(width: 50, height:75).padding()}
                
                Button(action: {
                    // add water
                }){Image("beer").resizable().frame(width: 50, height:75).padding()}
            }.offset(x: 0, y: -200)
        }
            
        
        
}}

struct DrinksType_Previews: PreviewProvider {
    static var previews: some View {
        DrinksType()
    }
}
