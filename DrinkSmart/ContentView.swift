//
//  ContentView.swift
//  DrinkSmart
//
//  Created by Rafael Oliveira on 2020-10-30.
//https://api.mocki.io/v1/6fb8160e acessar JSON

import Foundation
import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var tabManager = TabMenuManager()
    
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var globalString = GlobalString()
    
    @State var isActive: Bool  = false //criar retorno pro menu
    
    
    var body: some View {
        

        NavigationView{
        VStack{
            
            switch tabManager.lastSelected {
            case 0:
                DatePicker("Data", selection: $globalString.selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding(.leading, 10)
                
                HeaderHome(dateIni: dateIni(dateIni: globalString.selectedDate), dateEnd: dateEnd(dateEnd:globalString.selectedDate))
                    //HeaderHome(globalString: globalString)
                
                    //FilterList(dateIni: dateIni(dateIni: globalString.selectedDate), dateEnd: dateEnd(dateEnd:globalString.selectedDate))
                
                
               
                NavigationLink(
                    destination: DrinksType(globalString: globalString, rootIsActive: self.$isActive),isActive: self.$isActive
                ){
                        AddButton()
                           
                    }
                   
            case 1:
                Text("Star")
            case 2:
                ChartView()
            case 3:
                Config()

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
    @ObservedObject var globalString = GlobalString()
    @Environment(\.managedObjectContext) var context

    var drinkData : FetchRequest<Drink>
    var drinks : FetchedResults<Drink> { drinkData.wrappedValue }
    
    //@FetchRequest(entity: Drink.entity(), sortDescriptors: []) var drinkDeleter: FetchedResults<Drink>
    
    init(dateIni:Date, dateEnd: Date){
         
        drinkData = FetchRequest(entity: Drink.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Drink.dateAdded, ascending: false)], predicate: NSPredicate(format: "dateAdded >= %@ && dateAdded < %@", dateIni as CVarArg, dateEnd as CVarArg))}
    
  
    var sumMl: Int32 {
        drinkData.wrappedValue.reduce(0)
            { $0 + $1.drinkRealMl}
    }

    static let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
        }()
   
    
    var body: some View{
       
        ZStack{
            Image("wave")
                .resizable()
                .frame(width:.infinity, height: 220)
                .edgesIgnoringSafeArea(.horizontal)
            
        // WATER GOAL
            HStack{
                Text("\(sumMl)")
                    .font(.system(size:40))
        
                Text("OF")
                
                Text("\(globalString.selectedGoal,specifier: "%.0f")")
                    .font(.system(size:40))
                    .foregroundColor(.white)
                    
                Text("ML")
            }.offset(y:-5)
            
            
            
        // DROP GOAL
            
            let percentWater = Double(sumMl*100)/globalString.selectedGoal
            let movePerc =  CGFloat(round(percentWater) * 2.6) - 110
            
            let percentMax = percentWater <= 100 ? false : true
             
            
            
            
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 250, height: 5, alignment: .center)
                    .offset(y:70)
            HStack{
                Image("water drops")
                    .resizable()
                    .frame(width: 30, height: 45)
                    .offset(y:65)
                    
                Text("\(percentWater,specifier: "%.0f")%")
                    .foregroundColor(.white)
                    .padding(.all, 5)
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 3))
                            )
                    .offset(x:-10, y:45)
            }.offset(x: percentMax ? 150 : movePerc)
        }
    
        List {
            ForEach(drinkData.wrappedValue, id: \.self) { (drink:Drink) in
                HStack{
                        Image("\(drink.drinkName?.lowercased() ?? "water")")
                    VStack(alignment: .leading){
                            Text("\(drink.drinkName!)")
                        HStack{
                            Text("\(drink.drinkMl) mL")
                            
                            
                            Image(systemName: "timer")
                                .padding(.leading,8)
                            Text("\(drink.dateAdded!, formatter: HeaderHome.taskDateFormat)")
                        }
                    }.padding(.leading,15)
                    
                }
            }
            .onDelete(perform: deleteDrink)
        }
        .padding(.all, 0)
        .listStyle(PlainListStyle())
        
    }
    func deleteDrink(at offsets:IndexSet) {
        for index in offsets {
            let removeDrink = drinks[index]
            context.delete(removeDrink)
        }
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
        TabMenu(id: 2, imageName: "chart.bar", color: .black),
        TabMenu(id: 3, imageName: "info.circle", color: .blue)
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

class GlobalString: ObservableObject {
    @Published var selectedDate = Date()
    @Published var selectedGoal: Double = 3000.0
    
   
}

struct Colors {
    static let blueLight = Color(red: 170/255, green: 198/255, blue: 218/255)
    static let blueBright = Color(red: 0/255, green: 128/255, blue: 255/255)
}
    
func dateIni(dateIni:Date) -> Date {
        let calendar = Calendar.current
        let yearSelected = calendar.component(.year, from: dateIni)
        let monthSelected = calendar.component(.month, from: dateIni)
        let daySelected = calendar.component(.day, from: dateIni)
        
        
        var components = DateComponents()
        components.year = yearSelected
        components.month = monthSelected
        components.day = daySelected
        components.hour = 0
        components.minute = 0
        components.second = 0
       
        let dateIni = calendar.date(from: components) ?? Date()
        
        return dateIni
    
        }
    
func dateEnd(dateEnd:Date) -> Date {
    let calendar = Calendar.current
    let yearSelected = calendar.component(.year, from: dateEnd)
    let monthSelected = calendar.component(.month, from: dateEnd)
    let daySelected = calendar.component(.day, from: dateEnd)
    
    
    var components = DateComponents()
    components.year = yearSelected
    components.month = monthSelected
    components.day = daySelected
    components.hour = 23
    components.minute = 59
    components.second = 59
   
    let dateEnd = calendar.date(from: components) ?? Date()
    
    return dateEnd

    }


class UserSettings: ObservableObject {
   
    @Published var unit: Int{
        didSet {
            UserDefaults.standard.set(self.unit, forKey: "unit")
    }}
    
    @Published var age: Int = UserDefaults.standard.integer(forKey: "age") {
        didSet {
            UserDefaults.standard.set(self.age, forKey:"age")
        }
    }
    @Published var gender: Int = UserDefaults.standard.integer(forKey: "gender"){
            didSet {
                UserDefaults.standard.set(self.gender, forKey: "gender")
    }}
    @Published var weight: Int = UserDefaults.standard.integer(forKey: "weight"){
            didSet {
                UserDefaults.standard.set(self.weight, forKey: "weight")
    }}
    @Published var workout: Int = UserDefaults.standard.integer(forKey: "workout"){
            didSet {
                UserDefaults.standard.set(self.workout, forKey: "workout")
    }}
   
    init() {
    self.unit = UserDefaults.standard.object(forKey: "unit") as? Int ?? 0
    
    }
 
}

struct Config: View{
    //CALCULATIO4
    
    /*
     Take your weight (in pounds) and divide that by 2.2.
     
     Multiply that number depending on your age: If you're younger than 30, multiply by 40. If you're between 30-55, multiply by 35. If you're older than 55, multiply by 30.
     
     Divide that sum by 28.3.
     
     For every 45 to 60 minutes of exercise you do, you’ll need to drink a minimum of 40 ounces
     
     */
    static let gender = ["Male","Female"]
    static let workout = ["Sedentary", "Low Active", "Active", "Athlete"]
    static let unit = ["Metric", "Imperial"]
   
    
    @ObservedObject var userSettings = UserSettings()
    
    @State private var agePopUp = false
    @State private var weightPopUp = false
 
       var body: some View {
        
        let changeUnit = userSettings.unit
                
        ZStack{
            
           NavigationView {
            
               Form {
                
                Section(header: Text("Unit")) {
                    Picker("", selection: $userSettings.unit) {
                        ForEach(0 ..< Self.unit.count) {
                            Text("\(Self.unit[$0])")
                        }}}.pickerStyle(SegmentedPickerStyle())
                
                
             
                HStack{
                Text("Age")
                    Spacer()
                    Button(action: {
                            self.agePopUp = true
                        }, label: {
                            Text("\(userSettings.age)")
                        })
                        
                }
        
            

                    Section(header: Text("Gender")) {
                            Picker("", selection: $userSettings.gender) {
                                ForEach(0 ..< Self.gender.count) {
                                    Text("\(Self.gender[$0])")
                                }}
                        
                    }.pickerStyle(SegmentedPickerStyle())
                    
                
               //Section(header: Text("Weight in ") + Text((changeUnit == 0) ? "lb" : "kg")){
                HStack{
                Text("Weight in ") + Text((changeUnit == 0) ? "lb" : "kg")
                    Spacer()
                    Button(action: {
                            self.weightPopUp = true
                        }, label: {
                            Text("\(userSettings.weight)") + Text((changeUnit == 0) ? " LB" : " KG")
                        })
                        
                }
                
                    Section(header: Text("Activity Level")) {
                        Picker("", selection: $userSettings.workout) {
                            ForEach(0 ..< Self.workout.count) {
                                Text("\(Self.workout[$0])")
                            }}
                        
                    }.pickerStyle(SegmentedPickerStyle())
                
                }
               
               .navigationBarTitle("Settings")
          }
       
            if $weightPopUp.wrappedValue {
                
                ZStack{
                    Color.gray.opacity(0.9).edgesIgnoringSafeArea(.all)
                            
                        VStack{
                                Text("Weight") + Text((changeUnit == 0) ? " LB" : " KG").font(.system(size:20))
                                Picker("", selection: $userSettings.weight) {
                                    ForEach((20...320), id: \.self) {
                                        Text("\($0)")}
                                    
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 200)
                                
                                Button(action: {
                                    self.weightPopUp = false
                                }, label: {
                                    Text("OK")
                                })
                        }
                        .padding(.all,10)
                        .background(Color.white)
                        .cornerRadius(15)
                }
            }
            
            
        if $agePopUp.wrappedValue {
            
            ZStack{
                Color.gray.opacity(0.9).edgesIgnoringSafeArea(.all)
                        
                    VStack{
                            Text("Age").font(.system(size:20))
                            Picker("", selection: $userSettings.age) {
                                ForEach((4...120), id: \.self) {
                                    Text("\($0)")}
                                
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 200)
                            
                            Button(action: {
                                self.agePopUp = false
                            }, label: {
                                Text("OK")
                            })
                    }
                    .padding(.all,10)
                    .background(Color.white)
                    .cornerRadius(15)
            }
        }
            
    }
}}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(globalString: GlobalString())
    }
}
