//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by Kailash Bora on 29/04/24.
//

import CoreData
import UIKit

enum DataBaseError: Error {
    case failedToSaveData
    case failedToDownload
    case failedToDelete
}

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        
        let item = NetflixCloneEntity(context: context)

        item.id = Int64(model.id)
        item.original_name = model.original_name ?? ""
        item.orignial_title = model.original_title ?? ""
        item.overview = model.overview ?? ""
        item.media_type = model.media_type ?? ""
        item.release_date = model.release_date ?? ""
        item.poster_path = model.poster_path ?? ""
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average

        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
            print("Error while saving to core data: \(error.localizedDescription)")
        }
    }

    func fetchingTitlesFromDatabase(completion: @escaping (Result<[NetflixCloneEntity], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<NetflixCloneEntity>
        
        request = NetflixCloneEntity.fetchRequest()
        
        do {
            let title = try context.fetch(request)
            completion(.success(title))
        } catch {
            completion(.failure(DataBaseError.failedToDownload))
            print("Fetch from data base failed: \(error.localizedDescription)")
        }
    }

    func deleteTitleWith(model: NetflixCloneEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDelete ))
            print("Error while deleting from database: \(error.localizedDescription)")
        }
    }
}
