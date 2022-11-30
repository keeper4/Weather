//
//  SheetAction.swift
//  Manzanita
//
//  Created by Oleksandr Chyzh on 12.11.2021.
//  Copyright © 2021 Manzanita. All rights reserved.
//

import Foundation
import UIKit

enum PhotoActionSheetAction {
    case gallery
    case camera
    case removePhoto
    case cancel
    
    var title: String {
        switch self {
        case .gallery: return NSLocalizedString("EditProfile.ActionSheet.Gallery")
        case .camera: return NSLocalizedString("EditProfile.ActionSheet.TakePhoto")
        case .removePhoto: return NSLocalizedString("EditProfile.ActionSheet.RemovePhoto")
        case .cancel: return NSLocalizedString("EditProfile.ActionSheet.Cancel")
        }
    }
    
    var color: UIColor {
        return .white
    }
    
    var style: SelectSheetParameters.Style {
        switch self {
        case .gallery: return .default
        case .camera: return .default
        case .removePhoto: return .default
        case .cancel: return .cancel
        }
    }
    
    var position: SelectSheetParameters.Position {
        return .center
    }
    
    var action: SelectSheetParameters.Action {
        return SelectSheetParameters.Action(isSelected: false, title: self.title, color: self.color, style: self.style, position: self.position, action: {self})
    }
    
    static var allActions: [SelectSheetParameters.Action] {
        return [self.gallery, self.camera, self.removePhoto, self.cancel].map { $0.action }
    }
    
    static var allActionsWithOurRemove: [SelectSheetParameters.Action] {
        return [self.gallery, self.camera, self.cancel].map { $0.action }
    }
}

enum ItemSheetActions {
    case addToCollections
    case transactionHistory
    case addItems
    case edit
    case delete
    case cancel
    
    var title: String {
        switch self {
        case .addToCollections: return NSLocalizedString("ItemSheetActions.addToCollections")
        case .transactionHistory: return NSLocalizedString("ItemSheetActions.transactionHistory")
        case .addItems: return NSLocalizedString("ItemSheetActions.addItems")
        case .edit: return NSLocalizedString("ItemSheetActions.edit")
        case .delete: return NSLocalizedString("ItemSheetActions.delete")
        case .cancel: return NSLocalizedString("ItemSheetActions.cancel")
        }
    }
    
    var color: UIColor {
        switch self {
        case .addToCollections: return .white
        case .transactionHistory: return .white
        case .cancel: return .blue_link
        case .addItems:  return .white
        case .edit:  return .white
        case .delete:  return .white
        }
    }
    
    var style: SelectSheetParameters.Style {
        switch self {
        case .addToCollections: return .default
        case .transactionHistory: return .default
        case .addItems: return .default
        case .edit: return .default
        case .delete: return .default
        case .cancel: return .cancel
        }
    }
    
    var position: SelectSheetParameters.Position {
        return .center
    }
    
    var action: SelectSheetParameters.Action {
        return SelectSheetParameters.Action(isSelected: false, title: self.title, color: self.color, style: self.style, position: self.position, action: {self})
    }
    
    static var allActions: [SelectSheetParameters.Action] {
        return [self.addToCollections, self.transactionHistory, self.cancel].map { $0.action }
    }
    
    static var collection: [SelectSheetParameters.Action] {
        return [self.addItems, self.edit, self.delete, self.cancel].map { $0.action }
    }
}
