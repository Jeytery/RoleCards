//
//  DataCenter.swift
//  RoleCards
//
//  Created by Jeytery on 27.02.2022.
//

import Foundation

class DataStorage<ElementType: Codable> {
        
    private(set) var data = [ElementType]()
    
    private let userDefaults = UserDefaults.standard
    private let id: String
    
    init(id: String) {
        self.id = id
        self.data = getData() ?? []
    }
}

extension DataStorage {
    func getData() -> [ElementType]? {
        guard
            let jsonData = userDefaults.data(forKey: id),
            let encodedData = try? JSONDecoder()
                .decode([ElementType].self, from: jsonData)
        else {
            return nil
        }
        return encodedData
    }
    
    func saveData(_ data: [ElementType]) {
        guard let _data = try? JSONEncoder().encode(data) else { return }
        userDefaults.set(_data, forKey: id)
    }
    
    func removeElement(at index: Int) {
        data.remove(at: index)
        saveData(data)
    }
    
    func saveElement(_ element: ElementType) {
        data.append(element)
        saveData(data)
    }
    
    func updateElement(_ element: ElementType, at index: Int) {
        data.remove(at: index)
        data.insert(element, at: index)
        saveData(data)
    }
    
    func clear() {
        userDefaults.removePersistentDomain(forName: id)
        data.removeAll()
    }
}
