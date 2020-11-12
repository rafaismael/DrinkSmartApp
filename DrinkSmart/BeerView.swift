//
//  BeerView.swift
//  DrinkSmart
//
//  Created by Rafael Oliveira on 2020-11-09.
//

import SwiftUI

struct BeerView: View {
    
    @State var knobPosition: CGFloat = 0.0
    @State var progress: CGFloat = 0.5
    let height: CGFloat = 450
    @State private var waterMl = 0.0

    
    var body: some View {
        
        VStack{
            Text("Add Water").font(.title).foregroundColor(.blue).padding(.bottom, 80)
            
                
            
        HStack{
                VStack(alignment: .center, spacing: 22) {
                    ForEach(Array(stride(from: 1000, through: 0, by:-100)), id: \.self) { i in
                        Text("\(i)")
                            .bold()
                            .padding(.leading)
                       
                    }
                }
                VStack(alignment: .trailing, spacing: 6.5){
                    ForEach(Array(stride(from: 100, through: 0, by:-2)), id: \.self) { i in
                        Rectangle()
                            .fill(i % 10 == 0 ? Color(red: 102/255, green: 145/255, blue: 245/255): Color(red: 170/255, green: 198/255, blue: 218/255))
                            .frame(width: i%10 == 0 ? 20 : 10, height: 2)
                    }
                }
                
                RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 100, height:450)
                        .shadow(color: Color.black.opacity(0.1),radius:20, x:10.0, y:20.0)
                        
            
                FillSlider(progress: progress)
                        .fill(Color.blue)
                        .frame(width: 100, height: height)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .offset(x:-110)
                
            
                SliderKnob(color: Color.black)
                        .offset(x:-130, y: knobPosition)
                        .gesture(DragGesture(minimumDistance: 15)
                                    .onChanged({ value in
                                        calcProgress(yLocation: value.location.y)
                                    }))
                                    .onAppear {
                                        calcInitialPosition()
                                        }
           
                VStack{
                    Text("\(progress * 1000,specifier: "%.0f") \r\n Ml")
                        .font(.title2)
                        .offset(x:-100)
                        .frame(width: 60, height: 70)
                }
           
            
        }
        Spacer()
    }
        
    
}

    private func calcInitialPosition(){
        let progressFromMiddle = 0.5 - progress
        knobPosition = progressFromMiddle * height
    }

    private func calcProgress(yLocation: CGFloat){
        let tempProgress = 0.5 - (yLocation - 20)/height
        if tempProgress > 0 && tempProgress < 1.00 {
            progress = tempProgress
            let progressFromMiddle = 0.5 - progress
            knobPosition = progressFromMiddle * height
            
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
        ZStack{
  
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

//Slider(value: $waterMl, in: 20...1500, step: 10)

struct BeerView_Previews: PreviewProvider {
    static var previews: some View {
        BeerView()
    }
}
