//
//  ContentView.swift
//  GenericCarousel
//
//  Created by Mayur Kamthe on 12/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        loginViewCarousel
    }
    
    @ViewBuilder
    internal var loginViewCarousel: some View {
        //here we have sent data to carousel, in future we can send model class data to the carousel.
        let imagesArray = ["1", "2", "3", "4", "5", "6", "7"]
        CarouselView(list: imagesArray,
                     width: 250,
                     height: 250) {
            
        }
    }
}


//we need to make this view generic so that we can pass any view to this
struct CarouselView<Content: View>: View {
    
    var pageWidth: CGFloat
    var pageHeight: CGFloat
    @State private var scrollPosition: Int?
    private let animation: Animation = .default
    let content: Content
    let list: [String]
    private let itemDimension = UIScreen.main.bounds.width * 0.5
    private let itemSpacing = CGFloat(16)
    private let scrollViewHorizontalInset = CGFloat(8)
    
    
    init(list: [String], width: CGFloat, height: CGFloat, @ViewBuilder content: () -> Content) {
        self.pageWidth = width
        self.pageHeight = height
        self.list = list
        self.content = content()
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<list.count, id: \.self) { index in
                        Image(list[index])
                            .resizable()
                            .aspectRatio(3/3, contentMode: .fit)
                            .scaledToFit()
                            .clipped()
                            .cornerRadius(12)
                            .scaleEffect(10/9.7)
                            .scrollTransition{ content, phase in
                                content
                                    .opacity(phase.isIdentity ? 0.9 : 0.7)
                                    .scaleEffect(y: phase.isIdentity ? 0.9 : 0.6)
                            }
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, (pageWidth - itemDimension/2) / 2)
            }
            .scrollPosition(id: $scrollPosition)
            .frame(height: pageHeight)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .scrollIndicators(.hidden)
            .onChange(of: scrollPosition) {
                guard let scrollPosition = scrollPosition else {return}
                print(scrollPosition)
                
            }
            
            HStack {
                ForEach(0..<list.count, id: \.self) { index in
                    Circle()
                        .fill(Color.gray.opacity(
                            (index == (scrollPosition ?? 0) % list.count) ? 0.8 : 0.3
                        ))
                        .frame(width: 9)
                }
            }
        }
    }
    
    func calculateScale(geo: GeometryProxy, screenWidth: CGFloat, itemWidth: CGFloat) -> CGFloat {
        let centerX = screenWidth/2
        let itemCenterX = geo.frame(in: .global).midX
        let distance = abs(centerX - itemCenterX)
        let maxDistance = screenWidth/2
        let scale = max(1-(distance/maxDistance), 0.8)//scale between 0.8 to 1
        return scale
    }
}

#Preview {
    ContentView()
}

