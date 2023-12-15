//
//  ContentView.swift
//  MapApp
//
//  Created by Maksym on 04.08.2023.
//
import SwiftUI
import MapKit

struct ContentView: View{
    @StateObject var vm = ViewModel()
    var body: some View {
        if vm.unlock == false{
            Button("Unlock"){
                vm.aunthenfication()
            }
        }else{
            ZStack{
                Map(coordinateRegion: $vm.mapRegion, annotationItems: vm.locations){ location in
                    MapAnnotation(coordinate: location.region){
                        VStack{
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 20, height: 20)
                                .background(.white)
                                .clipShape(Circle())
                            Text(location.name)
                        }
                        .onTapGesture {
                            vm.selectedPlace = location
                        }
                    }
                }
                Button{
                    vm.addlocation()
                }label: {
                    Circle()
                        .fill(.blue)
                        .opacity(0.6)
                        .frame(width: 15, height: 15)
                }
               
//             
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Button {
//                            vm.addlocation()
//                        } label: {
//                            Image(systemName: "plus")
//                        }
//                        .padding()
//                        .background(.black.opacity(0.75))
//                        .foregroundColor(.white)
//                        .font(.title)
//                        .clipShape(Circle())
//                        .padding(.trailing)
//                    }
//                }
            }
            .padding()
            .sheet(item: $vm.selectedPlace){ place in
                EditView(location: place){
                    vm.update(location: $0)
                }
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
