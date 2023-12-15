//
//  FileManager.swift
//  MapApp
//
//  Created by Maksym on 06.08.2023.
//

import Foundation

extension FileManager{
    static var documentDirectory: URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
}
