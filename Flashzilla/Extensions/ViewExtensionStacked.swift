//
//  ShapeExtension.swift
//  Flashzilla
//
//  Created by Sergey Shcheglov on 04.03.2022.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}
