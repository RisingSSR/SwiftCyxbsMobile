//
//  ScheduleCollectionView.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/9/27.
//  Copyright © 2023 Redrock. All rights reserved.
//

import SwiftUI

struct ScheduleCollectionView: View {
    
    let title: String
    
    let content: String
    
    let drawType: ScheduleDrawType.CurriculumType
    
    let showMuti: Bool
    
    let isTitleOnly: Bool
    
    var body: some View {
        
        ZStack {
            
            if (drawType == .custom) {
                
                Image("lineline")
                    .resizable(resizingMode: .tile)
            } else {
                
                Color(drawType.backgroundColor)
            }
            
            if isTitleOnly {
                
                Text(title)
                    .font(.system(size: 10))
                    .padding(.horizontal, 7)
                    .lineLimit(3)
                    .foregroundColor(Color(drawType.textColor))
            } else {
                
                VStack {
                    Text(title)
                        .font(.system(size: 10))
                        .padding(.horizontal, 7)
                        .lineLimit(3)
                        .foregroundColor(Color(drawType.textColor))
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    Text(content)
                        .font(.system(size: 10))
                        .padding(.horizontal, 7)
                        .lineLimit(3)
                        .foregroundColor(Color(drawType.textColor))
                        .padding(.bottom, 8)
                }
            }
            
            if showMuti {
                
                GeometryReader { entry in
                    
                    HStack {
                        
                        Spacer()
                        
                        Capsule(style: .continuous)
                            .foregroundColor(Color(drawType.textColor))
                            .frame(width: 8, height: 2)
                            .padding(.top, 4)
                            .padding(.trailing, 5)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
