//
//  LoadingView.swift
//  AirQuality
//
//  Created by Uros on 1. 10. 2022..
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle.init(tint: .gray))
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
