//
//  RegionTileCollectionViewCell.swift
//  PIA VPN
//
//  Created by Jose Antonio Blaya Garcia on 11/01/2019.
//  Copyright © 2019 London Trust Media. All rights reserved.
//

import UIKit
import PIALibrary

class RegionTileCollectionViewCell: UICollectionViewCell, TileableCell {
    
    var tileType: AvailableTiles = .region

    typealias Entity = RegionTile
    @IBOutlet private weak var tile: Entity!
    @IBOutlet private weak var accessoryImageRight: UIImageView!
    @IBOutlet private weak var accessoryButtonLeft: UIButton!
    @IBOutlet weak var tileLeftConstraint: NSLayoutConstraint!
    
    private var currentTileStatus: TileStatus?

    func hasDetailView() -> Bool {
        return tile.hasDetailView()
    }
    
    func segueIdentifier() -> String? {
        return tile.detailSegueIdentifier
    }
    
    func setupCellForStatus(_ status: TileStatus) {
        Theme.current.applyPrincipalBackground(self)
        Theme.current.applyPrincipalBackground(self.contentView)
        tile.status = status
        let animationDuration = currentTileStatus != nil ? AppConfiguration.Animations.duration : 0
        UIView.animate(withDuration: animationDuration, animations: {
            switch status {
            case .normal:
                self.accessoryImageRight.image = Asset.Piax.Tiles.openTileDetails.image
                self.tileLeftConstraint.constant = 0
            case .edit:
                self.accessoryImageRight.image = Theme.current.dragDropImage()
                self.tileLeftConstraint.constant = self.leftConstraintValue
                self.setupVisibilityButton()
            }
            self.layoutIfNeeded()
            self.currentTileStatus = status
        })
    }
    
    
    func highlightCell() {
        accessoryButtonLeft.alpha = 0
        accessoryImageRight.alpha = 0
        Theme.current.applySecondaryBackground(tile)
        Theme.current.applySecondaryBackground(self)
        Theme.current.applySecondaryBackground(self.contentView)
    }
    
    func unhighlightCell() {
        accessoryButtonLeft.alpha = 1
        accessoryImageRight.alpha = 1
        Theme.current.applyPrincipalBackground(tile)
        Theme.current.applyPrincipalBackground(self)
        Theme.current.applyPrincipalBackground(self.contentView)
    }
    
    private func setupVisibilityButton() {
        if Client.providers.tileProvider.visibleTiles.contains(tileType) {
            accessoryButtonLeft.setImage(Theme.current.activeEyeImage(), for: .normal)
            accessoryButtonLeft.setImage(Theme.current.inactiveEyeImage(), for: .highlighted)
        } else {
            accessoryButtonLeft.setImage(Theme.current.inactiveEyeImage(), for: .normal)
            accessoryButtonLeft.setImage(Theme.current.activeEyeImage(), for: .highlighted)
        }
    }

    @IBAction private func changeTileVisibility() {
        var visibleTiles = Client.providers.tileProvider.visibleTiles
        if Client.providers.tileProvider.visibleTiles.contains(tileType) {
            let tiles = visibleTiles.filter { $0 != tileType }
            Client.providers.tileProvider.visibleTiles = tiles
        } else {
            visibleTiles.append(tileType)
            Client.providers.tileProvider.visibleTiles = visibleTiles
        }
        Macros.postNotification(.PIATilesDidChange)
    }
    
}
