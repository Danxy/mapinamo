//
//  LaunchView.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation
import SwiftUI

public struct LaunchView: View {
    
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
    }

    @ObservedObject private var viewModel: LaunchViewModel

    public var body: some View {
        Color(.systemCyan)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.onViewAppear()
            }
    }
}

struct StartView_Preview: PreviewProvider {
    static var previews: some View {
        LaunchAssembly.assemble(navigation: nil)
    }
}
