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
    @ObservedObject var tabManager = TabMenuManager()
    //@EnvironmentObject var globalString: GlobalString
    //@State var selectedDate = Date()
    //@Environment(\.managedObjectContext) var managedObjectContext
    //@FetchRequest(entity: Drink.entity(), sortDescriptors:[]) var drinkData: FetchedResults<Drink>
    
    //@State private var dateAdded = Date()
    @ObservedObject var myGlobalString = GlobalString()
    
    var body: some View {
        NavigationView{
        VStack{
            
            switch tabManager.lastSelected {
            case 0:
                HeaderHome(globalString: myGlobalString)
               
                    NavigationLink(destination: DrinksType()){
                        AddButton()
                           
                    }
                   
            case 1:
                Text("Star")
            case 2:
                Text("Chart")
            case 3:
                Text("A")
            default:
                Text("Menu")
            }
            
            Spacer()
            CustomTab(menuManager: tabManager)
                .padding(.leading, 30)
                .padding(.trailing, 30)
        }
        .navigationBarTitle("" , displayMode: .inline)
        .navigationBarHidden(true)
       
        }
          
        
    }}


struct HeaderHome: View{
    @ObservedObject var globalString: GlobalString
    var body: some View{
       
        ZStack{
            Image("wave")
                .resizable()
                .frame(width:.infinity, height: 190)
                .edgesIgnoringSafeArea(.horizontal)
            
        }
        
        ZStack{
           /*
            Rectangle()
                .fill(Colors.blueLight)
                .frame(width: .infinity, height:45)
                .shadow(color: Color.black.opacity(0.1),radius:20, x:0.0, y:-20.0)
          */
            

            DatePicker("Data", selection: $globalString.selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.leading, 10)

            
        }//.offset(y:-10)
    
    }
}

struct AddButton: View {
    var body: some View{
       ZStack{
            Circle()
                .fill(Colors.blueBright)
                .frame(width: 50, height: 50)
            VStack{
                Image(systemName: "plus.circle")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
    }
}

struct CustomTab: View{
    @ObservedObject var menuManager: TabMenuManager
    var body: some View{
        ZStack{
                Rectangle()
                    .fill(Color.white)
                    .frame(width:800, height:80)
                    .shadow(color: Color.black.opacity(0.1),radius:20, x:0.0, y:-20.0)
                HStack{
                    ForEach(menuManager.tabMenusInfo) { menu in
                        MenuItemView(menu: menu)
                            .onTapGesture {
                                menuManager.selectMenu(index: menu.id)
                            }
                    }
                }
        }.onAppear{ menuManager.selectMenu(index: 0)}
    }
}

struct MenuItemView: View{
    let menu: TabMenu
    var body: some View{
    
        ZStack{
            Image(systemName: menu.imageName)
                .frame(width: 80)
                .foregroundColor(menu.selected ? .blue : .gray)
                .font(.title)
        }
    }
}


struct TabMenu: Identifiable{
    let id: Int
    let imageName: String
    let color: Color
    var selected: Bool = false
}

struct MenuInfo{
    static let menus = [
        TabMenu(id: 0, imageName: "house", color: .white),
        TabMenu(id: 1, imageName: "star.lefthalf.fill", color: .purple),
        TabMenu(id: 2, imageName: "chart.bar", color: .black)
    ]
}

class TabMenuManager: ObservableObject {
    @Published var tabMenusInfo = MenuInfo.menus
    @Published var lastSelected = -1
        
        func selectMenu(index: Int){
            if index != lastSelected{
                tabMenusInfo[index].selected = true
                
                if lastSelected != -1 {
                    tabMenusInfo[lastSelected].selected = false}
                lastSelected = index
            }
        }
}


struct Colors {
    static let blueLight = Color(red: 170/255, green: 198/255, blue: 218/255)
    static let blueBright = Color(red: 0/255, green: 128/255, blue: 255/255)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
