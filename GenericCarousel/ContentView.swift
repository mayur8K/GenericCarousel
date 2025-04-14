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
        CarouselView(imagesArray: ["1", "2", "3", "4", "5", "6", "7"],
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
    let imagesArray: [String]
    let content: Content
    
    init(imagesArray: [String], width: CGFloat, height: CGFloat, @ViewBuilder content: () -> Content) {
        self.pageWidth = width
        self.pageHeight = height
        self.imagesArray = imagesArray
        self.content = content()
    }
    
    var body: some View {
        let dynamicWidth = UIScreen.main.bounds.width - pageWidth
        VStack {
            ScrollView(.horizontal) {
                HStack {
                        ForEach(0..<imagesArray.count, id: \.self) { index in
                            Image(imagesArray[index])
                                   .resizable()
                                   .aspectRatio(contentMode: .fill)
                                   .frame(width: pageWidth, height: pageHeight)
                                   .cornerRadius(20)
                                   .scrollTransition{ content, phase in
                                       content
                                           .opacity(phase.isIdentity ? 1 : 0.7) // Apply opacity animation
                                           .scaleEffect(y: phase.isIdentity ? 1 : 0.8)
                                   }
                    }
                }
                .scrollTargetLayout()
            }
            .frame(height: pageHeight)
            .contentMargins(dynamicWidth/2, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .scrollIndicators(.hidden)
            .onChange(of: scrollPosition) {
                guard let scrollPosition = scrollPosition else {return}
                print(scrollPosition)
            }

            HStack {
                ForEach(0..<imagesArray.count, id: \.self) { index in
                    Circle()
                        .fill(Color.gray.opacity(
                            (index == (scrollPosition ?? 0) % imagesArray.count) ? 0.8 : 0.3
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
