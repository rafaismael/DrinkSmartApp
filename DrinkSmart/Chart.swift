//
//  Chart.swift
//  DrinkSmart
//
//  Created by Rafael Oliveira on 2020-12-15.
//


import Foundation
import SwiftUI
import CoreData


struct ChartView: View {

  
@State private var dataPoints: [CGFloat] = [100,120,150,170,100,200,300,500,90,200,100,200]
    
@State private var reportType = 0
    
    //INIT STYLE PICKER MENU
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
    }
    // FORMAT DATE
    static let dateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, d MMM yyyy"
            return formatter
        }()
   
   
    let now = Date()
    @State private var findPrevDates = 0 //CALC PREVIOUS WEEK
    let arrayDrinks = ["Water", "Beer", "Red Wine"]
    
    var body: some View {
       
        
        VStack{
            Picker("", selection: $reportType) {
                Text("Week").tag(0)
                Text("Month").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
           
            HStack{
                
                Button(action: {
                        self.findPrevDates = findPrevDates + 7
                    }, label: {
                        Image(systemName: "arrow.left.circle.fill")
                    })
                   
                
                
                Text("\(dateIni(dateIni:startWeek(now)), formatter: ChartView.dateFormat)")
                
                Text(" - ")
                
                Text("\(dateEnd(dateEnd:endWeek(startWeek(now))), formatter: ChartView.dateFormat)")
                
                if dateIni(dateIni:startWeek(now)) < Date() && dateEnd(dateEnd:endWeek(startWeek(now))) >= Date()  {
                    
                    Image(systemName: "arrow.right.circle")
                    
                } else {
                    Button(action: {
                            self.findPrevDates = findPrevDates - 7
                        }, label: {
                            Image(systemName: "arrow.right.circle.fill")
                        })
                }
                
            }
            Spacer()
            switch reportType {
            case 0:
                HStack {
                    ForEach(0..<7, id: \.self) { i in
                                VStack{
                                    Spacer()
                                    FilterWeek(dateIni: dateIni(dateIni: datesWeek(now,i)), dateEnd: dateEnd(dateEnd: datesWeek(now,i)))
                                    
                                    Text("\(self.weekAbbreviationFromInt(i))")
                                        .font(.footnote)
                                        .frame(width: 30, height: 20, alignment: .center)
                                    
                                }
                    }
                
                }
            case 1:
                
                ZStack {
                    
                    Path { path in
                        path.move(to: CGPoint(x: 187, y: 287))
                        
                        path.addArc(center: .init(x: 187, y: 287), radius: 100, startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 90), clockwise: true)
                    }
                    .fill(Color(.systemYellow))
                    
                    
                    Path { path in
                        path.move(to: CGPoint(x: 187, y: 287))
                        path.addArc(center: .init(x: 187, y: 287), radius: 100, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 72), clockwise: true)
                    }
                    .fill(Color(.systemTeal))
                 
                    Path { path in
                        path.move(to: CGPoint(x: 187, y: 287))
                        path.addArc(center: .init(x: 187, y: 287), radius: 100, startAngle: Angle(degrees: 72), endAngle: Angle(degrees: 27), clockwise: true)
                    }
                    .fill(Color(.systemBlue))
                 
                    Path { path in
                        path.move(to: CGPoint(x: 187, y: 287))
                        path.addArc(center: .init(x: 187, y: 287), radius: 100, startAngle: Angle(degrees: 27), endAngle: Angle(degrees: 360), clockwise: true)
                    }
                    .fill(Color(.systemPurple))
                 
                }
                HStack{
                   
                   
                        VStack{
                            HStack{
                                ForEach(arrayDrinks, id: \.self) { drink in
                                
                                Text("\(drink)")
                                FilterChart(dateIni: dateIni(dateIni: Date()), dateEnd: dateEnd(dateEnd: endWeek(startWeek(now))), dName: drink)
                                
                                    
                                }.padding(.leading,2)
                               
                            }
                            HStack{
                                Image("beer")
                                FilterChart(dateIni: dateIni(dateIni: Date()), dateEnd: dateEnd(dateEnd: Date()), dName: "Beer")
                            }
                        }.padding(.all,60)
                
                        VStack{
                            HStack{
                                Image("coffee")
                                FilterChart(dateIni: dateIni(dateIni: Date()), dateEnd: dateEnd(dateEnd: Date()), dName: "Coffee")
                            }
                            
                            HStack{
                                Image("red wine")
                                FilterChart(dateIni: dateIni(dateIni: Date()), dateEnd: dateEnd(dateEnd: Date()), dName: "Red Wine")
                            }
                        }.padding(.all,60)
                }
                
            default:
                Text("Error")
            }
        }
}

    
    func weekAbbreviationFromInt(_ week: Int) -> String {
        let weeks = Calendar.current.shortWeekdaySymbols
      return weeks[week]
    }
    
    func startWeek(_ dataRef: Date) -> Date{
        let weekStart = Calendar.current.component(.weekday, from: dataRef)
        
        if weekStart > 0 {
            let dayStart = Calendar.current.date(byAdding: .day, value: -weekStart+1-findPrevDates, to: dataRef)!
            
            return dayStart
        } else {
            return Date()
        }
    }
    
    func endWeek(_ dataRef: Date) -> Date{
    
        let weekEnd = Calendar.current.component(.weekday, from: dataRef)
       
            let dayEnd = Calendar.current.date(byAdding: .day, value: weekEnd+5, to: dataRef)!
            
            return dayEnd
    }
    
    func datesWeek(_ dataRef: Date, _ datePlus: Int) -> Date{
        let weekStart = Calendar.current.component(.weekday, from: dataRef)
        
        if weekStart > 0 {
            let dayWeek = Calendar.current.date(byAdding: .day, value: -weekStart+1-findPrevDates+datePlus, to: dataRef)!
            
            return dayWeek
        } else {
            return Date()
        }
    }
    
}
struct FilterWeek: View {
    
    var drinksData : FetchRequest<Drink>
    
    init(dateIni: Date, dateEnd: Date){
            drinksData = FetchRequest(entity: Drink.entity(), sortDescriptors: [],predicate: NSPredicate(format: "dateAdded >= %@ && dateAdded < %@", dateIni as CVarArg, dateEnd as CVarArg))
    }
      
    var weekMl: Int32 {
        drinksData.wrappedValue.reduce(0)
            {$0 + $1.drinkRealMl}
    }
    
    
    var body: some View {
    
    let barMax = weekMl <= 5000 ? false : true
        
        if weekMl > 400 {
            Text("\(weekMl)")
                .foregroundColor(.white)
                .rotationEffect(.degrees(-90))
                .font(.footnote)
                .offset(y: 50)
                .frame(height: 30)
                .zIndex(1)
        } else if weekMl == 0 {
            Text("")
        } else {
            Text("\(weekMl)")
                .foregroundColor(.black)
                .rotationEffect(.degrees(-90))
                .font(.footnote)
                .frame(height: 20)
                .offset(y: 0)
                
        }
        
        RoundedRectangle(cornerRadius: 15)
            .frame(width: 25, height: barMax ? 500 : CGFloat(weekMl)/10, alignment: .center)
            .foregroundColor(.blue)
        
    }}

struct FilterChart: View {
    
    var drinksData : FetchRequest<Drink>
    
    init(dateIni: Date, dateEnd: Date, dName: String){
        drinksData = FetchRequest(entity: Drink.entity(), sortDescriptors: [],predicate: NSPredicate(format: "dateAdded >= %@ && dateAdded < %@ && drinkName == %@", dateIni as CVarArg, dateEnd as CVarArg, dName as String))
    }
      
    var drinkTotal: Int32 {
        drinksData.wrappedValue.reduce(0)
            {$0 + $1.drinkMl}
    }
    
    var body: some View {
        VStack{
            Text("\(drinkTotal)")
           
        }
}
}

struct FilterChartAux: View {
    
    @State private var dName = "Water"
    @State private var dateI = Date()
    @State private var dateEnd = Date()
   
    @FetchRequest(entity: Drink.entity(), sortDescriptors: [],predicate: NSPredicate(format: "dateAdded >= %@ && dateAdded < %@ && drinkName == %@", Date() as CVarArg,Date() as CVarArg,"Water")) var drinkData: FetchedResults<Drink>
   
  
      
    var drinkTotal: Int32 {
        _drinkData.wrappedValue.reduce(0)
            {$0 + $1.drinkMl}
    }
    
    var body: some View {
        VStack{
            Text("\(drinkTotal)")
           
        }
}
}
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
