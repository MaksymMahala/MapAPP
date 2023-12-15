//
//  ViewModelEdit.swift
//  MapApp
//
//  Created by Maksym on 07.08.2023.
//

import Foundation
import SwiftUI

extension EditView{
    class ViewModelEdit: ObservableObject{
        enum LoadingState {
            case loading, loaded, failed
        }

        @Published var loadingState = LoadingState.loading
        @Published var pages = [Page]()
        @Environment(\.dismiss) var dismiss

    }
}
