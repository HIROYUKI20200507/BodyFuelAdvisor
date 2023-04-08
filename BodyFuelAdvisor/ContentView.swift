//
//  ContentView.swift
//  BodyFuelAdvisor
//
//  Created by 秋本 裕之 on 2023/04/07.
//
import SwiftUI

struct ContentView: View {
    @State private var weight: String = ""
    
    var body: some View {
        VStack {
            Text("体重を入力してください")
                .font(.title)
                .padding(.bottom, 20)
            
            TextField("体重 (kg)", text: $weight)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
        }
        .padding(.top, 50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
