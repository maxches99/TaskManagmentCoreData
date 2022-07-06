////
////  GIFCollectionView.swift
////  TaskManagmentCoreData
////
////  Created by Максим Чесников on 27.06.2022.
////
//
//import SwiftUI
//
//struct GIFCollectionView: View {
//    
//    @State var textSearch = ""
//    
//    @State var gifs: [Datum] = []
//    @State var datas: [String: Data] = [:]
//    
//    var service = SearchGIFNetworkService()
//    
//    let columns = [
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible()),
////            GridItem(.flexible())
//        ]
//    
//    var TextFieldView: some View {
//        TextField("Search...", text: $textSearch)
//            .padding()
//            .background(.gray.opacity(0.1))
//            .border(.black)
//            .padding(.horizontal, 16)
//    }
//        
//        var body: some View {
//            VStack {
//                TextFieldView
//                ScrollView {
//                    LazyVGrid(columns: columns, spacing: 0) {
//                        ForEach(gifs.indices, id: \.self) { gif in
//    //                        GIFImage(data: datas[gif])
//    //                                  .frame(width: 300)
//                            if let data = datas[gifs[gif].id ?? ""] {
//                                    GIFImage(data: data)
////                                      .frame(width: 100)
//                                      .frame(height: 100)
//                                      .background(.black)
//                                      .border(.black)
//                                  } else {
//                                    Text("Loading...")
//                                          .frame(width: 100)
//                                          .frame(height: 100)
//                                          .onAppear {
//                                              loadData(datum: gifs[gif])
//                                          }
//                                  }
//                        }
//                    }
//                    .padding(.horizontal, 27)
//                    
//                }
//                .onAppear {
//                    service.loadGIFs(by: textSearch) { items, error in
//                        gifs = items?.data ?? []
//                        
//                    }
//            }
//            }
//        }
//    
//    private func loadData(datum: Datum) {
//        if let url = URL(string: datum.images?.previewGIF.url ?? "") {
//            DispatchQueue(label: "aa", qos: .background).async {
//                let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                    if let data {
//                        datas[datum.id ?? ""] = data
//                    }
//                }
//                task.resume()
//            }
//            
//        }
//    }
//}
//
//struct GIFCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        GIFCollectionView(textSearch: "Gif")
//    }
//}
