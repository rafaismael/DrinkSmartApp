//
//  BeerView.swift
//  DrinkSmart
//
//  Created by Rafael Oliveira on 2020-11-09.
//

import SwiftUI

struct BeerView: View {
    
    var colorDataBase: [String: Color] = ["yellow": .yellow, "blue": .blue, "red": .purple, "brown": Color(red: 255/255, green: 100/255, blue: 140/255)]
    
    @State var knobPosition: CGFloat = 0.0
    @State var progress: CGFloat = 0.5
    let height: CGFloat = 450
    @State private var waterMl = 0.0
    
    

   
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Drink.entity(), sortDescriptors: []) var drinkData: FetchedResults<Drink>

    var item: MenuItem
    
    
    var body: some View {
        
        
        VStack{
            Text("\(item.name.capitalizingFirstLetter())")
                .font(.title)
                .foregroundColor(self.colorDataBase[item.color, default: .black])
                .padding(.bottom, 20)
                
            
                
            
            HStack{
                        VStack(alignment: .center, spacing: 22) {
                            ForEach(Array(stride(from: 1000, through: 0, by:-100)), id: \.self) { i in
                                Text("\(i)")
                                    .bold()
                                    .padding(.leading,30)
                                    .frame(width:80)
                               
                            }
                        }
                    
                    VStack(alignment: .trailing, spacing: 6.5){
                        ForEach(Array(stride(from: 100, through: 0, by:-2)), id: \.self) { i in
                            Rectangle()
                                .fill(i % 10 == 0 ? Color(red: 102/255, green: 145/255, blue: 245/255): Color(red: 170/255, green: 198/255, blue: 218/255))
                                .frame(width: i%10 == 0 ? 20 : 10, height: 2)
                        }
                    }
                    
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                            .frame(width: 100, height:450)
                            .shadow(color: Color.black.opacity(0.1),radius:20, x:10.0, y:20.0)
                        
            
                    FillSlider(progress: progress)
                        .fill(self.colorDataBase[item.color, default: .black])
                            .frame(width: 100, height: height)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            //.offset(x:-108)
                
            
                    SliderKnob(color: Color.black)
                            .offset(x:50, y: knobPosition)
                            .frame(width: 30, height: 30, alignment: .trailing)
                            .gesture(DragGesture(minimumDistance: 15)
                                        .onChanged({ value in
                                            calcProgress(yLocation: value.location.y)
                                        }))
                                        .onAppear {
                                            calcInitialPosition()
                                            }
                    }
                    
                VStack{
                    Image(item.photo)
                        .resizable()
                        .frame(width: 50, height: 70)
                    
                    Text("\(progress * 1000,specifier: "%.0f") \r\n Ml")
                        .foregroundColor(self.colorDataBase[item.color, default: .black])
                        .font(.title)
                        .frame(width: 80, height: 70)
                    
                   
                
                    Spacer()
                    ZStack{
                         Circle()
                            .fill(self.colorDataBase[item.color, default: .black])
                             .frame(width: 50, height: 50)
                            .padding()
                            
                        Button(action:
                                {
                                    self.addDrink()
                                }){
                            Image(systemName: "checkmark.circle")
                                 .font(.largeTitle)
                                 .foregroundColor(.white)
                        }
                    }
                   
                }.padding(.leading, 50)
                
            }
            
        }
       
    
}

    private func calcInitialPosition(){
        let progressFromMiddle = 0.5 - progress
        knobPosition = progressFromMiddle * height
    }

    private func calcProgress(yLocation: CGFloat){
        let tempProgress = 0.5 - (round(yLocation - 12))/height
        if tempProgress >= 0 && tempProgress <= 1 {
            progress = tempProgress
            let progressFromMiddle = 0.5 - progress
            knobPosition = progressFromMiddle * height
        }
    }


    func addDrink() {
        let newDrink = Drink(context:context)
        newDrink.id = UUID()
        newDrink.drinkName = item.name
        newDrink.drinkMl = Int32(progress * 1000)
        newDrink.dateAdded = Date()
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

struct FillSlider: Shape {
    var progress: CGFloat
    func path(in rect:CGRect) -> Path {
       var path = Path()
        
        let width = rect.width
        let height = rect.height
        let progressHeight = height * (1-progress)
        
        
        path.move(to: CGPoint(x:0, y: progressHeight + 0)) // add +30 curve
        path.addQuadCurve(to: CGPoint(x:30, y:progressHeight), control: CGPoint(x: 0, y: progressHeight))
        
        path.addLine(to: CGPoint(x: width, y: progressHeight))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: progressHeight))
        return path
        
    }
}
struct SliderKnob: View{

    let color: Color
    var body: some View{
        ZStack {
  
            Circle()
                .fill(Color.white)
                .frame(width: 30, height: 30)
                .shadow(color: .black, radius: 3, x: 0, y: 0)
           
            Circle()
                .fill(Color.gray)
                .frame(width: 16, height:16)
            
            Circle()
                .fill(Color(red: 102/255, green: 145/255, blue: 245/255))
                .frame(width: 14, height:14)
        
         
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

//Slider(value: $waterMl, in: 20...1500, step: 10)

#if DEBUG

struct BeerView_Previews: PreviewProvider {
    var item: MenuItem
    static var previews: some View {
        NavigationView{
            BeerView(item: MenuItem.example)
        }
    }
}
#endif

