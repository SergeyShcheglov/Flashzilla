//
//  ShapeExtension1.swift
//  Flashzilla
//
//  Created by Sergey Shcheglov on 04.03.2022.
//

import SwiftUI

extension Shape {
    func fill(using offset: CGSize) -> some View {
        if offset.width == 0 {
            return self.fill(.white)
        } else if offset.width > 0 {
            return self.fill(.green)
        } else {
            return self.fill(.red)
        }
    }
}
