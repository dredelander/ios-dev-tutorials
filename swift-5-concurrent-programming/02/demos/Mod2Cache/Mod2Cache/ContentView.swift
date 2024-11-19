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
        print("Start time: \(startTime)")
        
        var count = 0

// THIS IS USING THE MAIN QUEUE AND ALSO SERIAL TYPE THREADING
//        imageURLs.forEach { urlStr in
//            guard let url = URL(string: urlStr) else { return }
//            guard let data = url.fetchData() else { return }
//            let filename = data.cache() ?? "no name"
//            count += 1
//            print("\(count) of \(imageURLs.count) - \(Date.now) - \(filename)")
//            if count == imageURLs.count {
//                status = "Duration: \(-startTime.timeIntervalSinceNow)"
//            } else {
//                status = "Downloaded: \(count) of \(imageURLs.count)"
//            }
//            print(status)
//        }
//
        // THIS IS USING A CUSTOM THREAD/QUEUE AND SPECIFYING THAT IS ASYNC/CONCURRENT
        
        let myQ = DispatchQueue(label: "myQ", attributes: .concurrent)
        
        imageURLs.forEach { urlStr in
            myQ.async{
                guard let url = URL(string: urlStr) else { return }
                guard let data = url.fetchData() else { return }
                let filename = data.cache() ?? "no name"
                count += 1
                print("\(count) of \(imageURLs.count) - \(Date.now) - \(filename)")
                if count == imageURLs.count {
                    status = "Duration: \(-startTime.timeIntervalSinceNow)"
                } else {
                    status = "Downloaded: \(count) of \(imageURLs.count)"
                }
                print(status)
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
    func fetchData() -> Data? {
        try? Data(contentsOf: self)
    }
}
