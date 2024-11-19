//
//  ContentView.swift
//  Mod2Cache
//
//  Created by Bear on 5/31/24.
//

import SwiftUI

let imageURLs = ["https://apod.nasa.gov/apod/image/2405/NebulousRealmofWR134_2048.png",
                 "https://apod.nasa.gov/apod/image/2405/EiffelCorona_Binotto_2000.jpg",
                 "https://apod.nasa.gov/apod/image/2405/StairwayToMilkyway_Marcin_6000.jpg",
                 "https://apod.nasa.gov/apod/image/2405/Cederblad111-110.jpg",
                 "https://apod.nasa.gov/apod/image/2405/filament_sdo_1080.jpg",
                 "https://apod.nasa.gov/apod/image/2405/iss059e019043.jpg",
                 "https://apod.nasa.gov/apod/image/2405/M78_Euclid_5532.jpg",
                 "https://apod.nasa.gov/apod/image/2405/N3169N3166Final.jpg"
]

struct ContentView: View {
    @State private var status = ""
    var body: some View {
        VStack {
            Text(status)
            Button(action: {
                status = "Downloading..."
                cacheImages()
            }, label: {
                Text("Cache Images")
            })
        }
        .padding()
    }
    
    func cacheImages() {
        let startTime = Date.now
        
        imageURLs.forEach { urlStr in
            Task{
                guard let url = URL(string: urlStr) else { return }
                guard let data = await url.fetchData() else { return }
                let filename = data.cache() ?? "no name"
                print("Duration: \(-startTime.timeIntervalSinceNow)")
            }
        }
    }
}

#Preview {
    ContentView()
}

extension Data {
    func cache() -> String? {
        let fileName = UUID().uuidString
        let urlStr = NSTemporaryDirectory() + fileName
        let url = URL(fileURLWithPath: urlStr)
        do {
            try self.write(to: url)
            return fileName
        } catch {
            return nil
        }
    }
}

extension URL {
    func fetchData() async -> Data? {
//        try? Data(contentsOf: self)
        try? await URLSession.shared.data(from: self).0
    }
}
