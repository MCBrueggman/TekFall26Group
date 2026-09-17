//
//  HomeView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/17/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        VStack {
            Text("Home")
                .font(.largeTitle)
                .foregroundStyle(.blue)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 1))
        }
    }
}
