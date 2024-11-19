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

struct DownloadCounter : Sendable {
    var count = 0
}

struct ContentView: View {
    @State private var status = ""
    @State private var dlCount = DownloadCounter() 
    
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
        Task {
            await withTaskGroup(of: String.self) { taskgroup in
                for _ in 0..<10 {
                    imageURLs.forEach { urlStr in
                        taskgroup.addTask {
                            dlCount.count += 1
                            return urlStr
                        }
                    }
                    for await filename in taskgroup {
                        print(filename)
                    }
                    print(dlCount.count)
                }
            }
        }
    }
}

class DataIterator : AsyncSequence, AsyncIteratorProtocol {
    typealias AsyncIterator = DataIterator
    typealias Element = Data
    
    var index = 0
    func next() async throws -> Data? {
        guard index < imageURLs.count else { return nil }
        let urlStr = imageURLs[index]
        index += 1
        
        guard let url = URL(string: urlStr) else { return nil }
        guard let data = await url.fetchData() else { return nil }
        return data
    }
    
    func makeAsyncIterator() -> DataIterator {
        self
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
    func fetchData(completion : @escaping (Data?)->Void) {
        URLSession.shared.dataTask(with: self) { data, resp, error in
            completion(data)
        }.resume()
    }
    func fetchData() async -> Data? {
        await withCheckedContinuation { continuation in
            self.fetchData { data in
                continuation.resume(returning: data)
            }
        }
    }
}
