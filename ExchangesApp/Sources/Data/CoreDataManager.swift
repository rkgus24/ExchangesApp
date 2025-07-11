//
//  CoreDataManager.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/11/25.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func isFavorite(code: String) -> Bool {
        let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "code == %@", code)
        return (try? context.count(for: request)) ?? 0 > 0
    }

    func addFavorite(code: String) {
        let favorite = FavoriteCurrency(context: context)
        favorite.code = code
        try? context.save()
    }

    func removeFavorite(code: String) {
        let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "code == %@", code)
        if let result = try? context.fetch(request).first {
            context.delete(result)
            try? context.save()
        }
    }

    func getAllFavorites() -> [String] {
        let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
        let result = (try? context.fetch(request)) ?? []
        return result.compactMap { $0.code }
    }
}
