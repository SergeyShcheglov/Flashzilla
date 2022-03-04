//
//  FileManager-DocumentsDirectory.swift
//  Flashzilla
//
//  Created by Sergey Shcheglov on 04.03.2022.
//

import Foundation

extension FileManager {
    static var getDocumentDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
