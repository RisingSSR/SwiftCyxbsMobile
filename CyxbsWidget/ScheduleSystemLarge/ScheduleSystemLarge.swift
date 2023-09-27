//
//  ScheduleSystemLarge.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/9/27.
//  Copyright © 2023 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleSystemLarge: View {
    
    let mappy: ScheduleMaping
    
    let section: Int
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Text(sectionString(withSection: section))
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Color(.ry(light: "#112C54", dark: "#F0F0F2")))
                .padding(.trailing)
            
            Divider()
                .padding(.horizontal, 8)
                .padding(.bottom, 2)
            
            HStack {
                
                Text("a")
                
            }
            .frame(height: 55)
            
            HStack {
                
                VStack {
                    
                    Text("leading")
                }
                
                GeometryReader { context in
                    
                    
                    Text("a")
                }
            }
        }
    }
}
