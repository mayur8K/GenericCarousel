//
//  ContentView.swift
//  GenericCarousel
//
//  Created by Mayur Kamthe on 12/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            loginViewCarousel
        }
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
    private let itemDimension = UIScreen.main.bounds.width
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
               // GeometryReader { proxy in
                HStack {
                    ForEach(0..<list.count, id: \.self) { index in
                        Image(list[index])
                            .resizable()
                            .aspectRatio(40/40, contentMode: .fill)
                            .cornerRadius(10)
                            .scrollTransition{ content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.7) // Apply opacity animation
                                    .scaleEffect(y: phase.isIdentity ? 1 : 0.8)
                            }
                            .offset(x: (pageWidth/2 - itemDimension)/2 - (itemSpacing * CGFloat(list.count - 1)/2))

                    }
                }
                .scrollTargetLayout()
                //}
            }
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
}

#Preview {
    ContentView()
}
