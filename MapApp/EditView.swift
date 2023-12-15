//
//  EditView.swift
//  MapApp
//
//  Created by Maksym on 05.08.2023.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    @State private var name: String
    @State private var description: String
   
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    @StateObject private var vme = ViewModelEdit()
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Place name", text: $name)
                    TextField("Place name", text: $description)
                }
                Section("Nearby…") {
                    switch vme.loadingState {
                    case .loaded:
                        ForEach(vme.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading…")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    vme.dismiss()
                }
            }
            .task {
                await urlSession()
            }
        }
    }
    func urlSession() async{
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.region.latitude)%7C\(location.region.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {
            print("bad url: \(urlString)")
            return
        }
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            vme.pages = items.query.pages.values.sorted()
            vme.loadingState = .loaded
        }catch{
            vme.loadingState = .failed
        }
    }

 
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example){ newLocation in}
    }
}
