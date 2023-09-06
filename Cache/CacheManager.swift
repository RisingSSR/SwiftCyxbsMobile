//
//  CacheManager.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CacheManager {
    
    static let shared = CacheManager()
    
    static let cleanInNextVersion: Bool = true
    
    private init() {
        if let version = UserDefualtsManager.shared.systemVersion {
            if version != Constants.systemVersion {
                delete(path: FilePath(rootPath: .document, file: ""))
            }
        } else {
            delete(path: FilePath(rootPath: .document, file: ""))
        }
    }
}

extension CacheManager {
    
    @discardableResult
    func create(rootPath: RootPath, file: String) -> FilePath {
        FilePath(rootPath: rootPath, file: file)
    }
    
    private func create(path: String) {
        if FileManager.default.fileExists(atPath: path) { return }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
        } catch {
            print("Failed to create dicrectory at path: \(error)")
        }
    }
    
    func delete(path: FilePath) {
        let path = path.rawValue
        try? FileManager.default.contentsOfDirectory(atPath: path).forEach { perPath in
            try? FileManager.default.removeItem(atPath: perPath)
        }
        UserDefualtsManager.shared.systemVersion = Constants.systemVersion
    }
}

extension CacheManager {
    
    func cache(json: JSON, in path: FilePath) {
        let fullPath = path.rawValue
        do {
            let data = try json.rawData(options: .sortedKeys)
            do {
                try data.write(to: URL(fileURLWithPath: fullPath))
            } catch {
                print("Failed to write Data to File: \(error)")
            }
        } catch {
            print("Failed to convert JSON to Data: \(error)")
        }
    }
    
    func getJOSN(in path: FilePath) -> JSON? {
        let fullPath = path.rawValue
        if let url = URL(string: fullPath) {
            do {
                let data = try Data(contentsOf: url)
                do {
                    return try JSON(data: data)
                } catch {
                    print("Failed to convert Data to JSON: \(error)")
                }
            } catch {
                print("Failed to get Data from URL: \(error)")
            }
        }
        return nil
    }
}

extension CacheManager {
    
    struct FilePath {
        
        let rawValue: String

        init(rootPath: RootPath, file: String, create: Bool = true) {
            var file = file
            if file.prefix(1) != "/" {
                file = "/" + file
            }
            rawValue = rootPath.rawValue + file
            
            if !create { return }
            if FileManager.default.fileExists(atPath: rawValue) { return }
            let ary = rawValue.components(separatedBy: "/")
            let root = ary[0..<ary.count - 1].joined(separator: "/")
            CacheManager.shared.create(path: root)
        }
    }
    
    struct RootPath {
        
        var rawValue: String
        
        init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension CacheManager.RootPath {
    
    static let document: Self = .init(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")
}
