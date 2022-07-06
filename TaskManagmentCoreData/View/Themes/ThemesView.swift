//
//  ThemesView.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 04.07.2022.
//

import SwiftUI

struct ThemesView: View {
    
    @StateObject var themesHelper: ThemesHelper = .shared
    
    @Environment(\.dismiss) var dismiss
    
    @State var isShowDefaults = true
    @State var isShowConfigurator = false
    
    @State var colorTitle: Color = .white
    @State var colorBackground: Color = .white
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                
                
                ScrollView {
                    HStack {
                        Text("Шаблоны")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(themesHelper.current.textColor)
                        Spacer()
                        Image(systemName: "arrow.down")
                            .foregroundColor(themesHelper.current.textColor)
                            .rotationEffect(isShowDefaults ? .degrees(180): .degrees(360))
                            .animation(.easeOut, value: 0.5)
                    }
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            isShowDefaults.toggle()
                        }
                    }
                    if isShowDefaults {
                        LazyVStack(pinnedViews: .sectionHeaders) {
                            Section {
                                ForEach(ThemesType.allCases, id: \.self) { themeType in
                                    Button {
                                        themesHelper.current = themeType
                                        dismiss()
                                    } label: {
                                        TaskCardView(task: .data, theme: .constant(themeType)) {}
                                            .frame(width: 300)
                                            .frame(height: 100)
                                            .padding()
                                            .disabled(true)
                                    }
                                    .background(
                                        themeType.backgroundColor
                                    )
                                    .cornerRadius(16)
                                    
                                    
                                }
                            }
                        }
                        
                    }
                    HStack {
                        Text("Конфигуратор")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(themesHelper.current.textColor)
                        Spacer()
                        Image(systemName: "arrow.down")
                            .foregroundColor(themesHelper.current.textColor)
                            .rotationEffect(isShowConfigurator ? .degrees(180): .degrees(360))
                            .animation(.easeOut, value: 0.5)
                    }
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            isShowConfigurator.toggle()
                        }
                    }
                    if isShowConfigurator {
                        HStack {
                            Text("Text")
                                .font(.callout)
                                .fontWeight(.heavy)
                                .foregroundColor(colorTitle)
                            ColorPicker("", selection: $colorTitle)
                        }
                        .padding()
                        HStack {
                            Text("Background")
                                .font(.callout)
                                .fontWeight(.heavy)
                                .foregroundColor(colorTitle)
                            ColorPicker("", selection: $colorBackground)
                        }
                        .padding()
                    }
                }
            }
            Spacer()
        }
        .background(
            colorBackground == .white ? themesHelper.current.backgroundColor
                .animation(.easeInOut(duration: 0.5))
                .ignoresSafeArea() : colorBackground.animation(.easeInOut(duration: 0.5))
                .ignoresSafeArea()
        )
    }
}

struct ThemesView_Previews: PreviewProvider {
    static var previews: some View {
        ThemesView()
    }
}
