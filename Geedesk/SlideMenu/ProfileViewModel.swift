//
//  ProfileViewModel.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Stanislav Ostrovskiy on 4/25/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import Foundation
import UIKit

enum ProfileViewModelItemType {
    case nameAndPicture
    case about
    case email
    case friend
    case attribute
}

protocol ProfileViewModelItem {
    var type: ProfileViewModelItemType { get }
    var sectionTitle: String { get }
    var headerImage: String { get }
    var rowCount: Int { get }
    var isCollapsible: Bool { get }
    var isCollapsed: Bool { get set }
}

extension ProfileViewModelItem {
    var rowCount: Int {
        return 1
    }
    
    var isCollapsible: Bool {
        return true
    }
}

class ProfileViewModel: NSObject {
    var items = [ProfileViewModelItem]()
    
    var reloadSections: ((_ section: Int) -> Void)?
    
    override init() {
        super.init()
        guard let data = dataFromFile("ServerData"), let profile = Profile(data: data) else {
            return
        }
        
         let name = profile.home
         if !name.isEmpty{
            let nameAndPictureItem = ProfileViewModelNamePictureItem(friends: name)
            items.append(nameAndPictureItem)
        }
        
        
        
        let tickets = profile.tickets
        if !tickets.isEmpty{
            let aboutItem = ProfileViewModelAboutItem(friends: tickets)
            items.append(aboutItem)
        }
        
        
//        if let about = profile.about {
//            let aboutItem = ProfileViewModelAboutItem(about: about)
//            items.append(aboutItem)
//        }
        
//        if let email = profile.email {
//            let dobItem = ProfileViewModelEmailItem(email: email)
//            items.append(dobItem)
//        }
//
        
        
        let reports = profile.reports
        if !reports.isEmpty{
            let aboutItem = ProfileViewModelEmailItem(friends: reports)
            items.append(aboutItem)
        }
        
        
        
        
        let attributes = profile.profileAttributes
        if !attributes.isEmpty {
            let attributesItem = ProfileViewModeAttributeItem(attributes: attributes)
            items.append(attributesItem)
        }
        
        let friends = profile.friends
        if !profile.friends.isEmpty {
            let friendsItem = ProfileViewModeFriendsItem(friends: friends)
            items.append(friendsItem)
        }        
    }
}

extension ProfileViewModel: UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        guard item.isCollapsible else {
            return item.rowCount
        }

        if item.isCollapsed {
            return 0
        } else {
            return item.rowCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .nameAndPicture:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureCell.identifier, for: indexPath) as? NamePictureCell {
//                cell.item = item.Home[indexPath.row]
//                return cell
//            }



            if let item = item as? ProfileViewModelNamePictureItem, let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.identifier, for: indexPath) as? HomeCell {
                let friend = item.home[indexPath.row]
                cell.item = friend
                return cell
            }
        case .about:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier, for: indexPath) as? AboutCell {
//                cell.item = item
//                return cell
//            }


            if let item = item as? ProfileViewModelAboutItem, let cell = tableView.dequeueReusableCell(withIdentifier: TicketsCell.identifier, for: indexPath) as? TicketsCell {
                let friend = item.tickets[indexPath.row]
                cell.item = friend
                return cell
            }


        case .email:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: EmailCell.identifier, for: indexPath) as? EmailCell {
//                cell.item = item
//                return cell
//            }
//

            if let item = item as? ProfileViewModelEmailItem, let cell = tableView.dequeueReusableCell(withIdentifier: ReportsCell.identifier, for: indexPath) as? ReportsCell {
                let friend = item.reports[indexPath.row]
                cell.item = friend
                return cell
            }

        case .friend:
            if let item = item as? ProfileViewModeFriendsItem, let cell = tableView.dequeueReusableCell(withIdentifier: OtherCell.identifier, for: indexPath) as? OtherCell {
                let friend = item.friends[indexPath.row]
                cell.item = friend
                return cell
            }
        case .attribute:
            if let item = item as? ProfileViewModeAttributeItem, let cell = tableView.dequeueReusableCell(withIdentifier: AddOneCell.identifier, for: indexPath) as? AddOneCell {
                cell.item = item.attributes[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
           // self.slideMenuController()?.closeLeft()
            print(indexPath.row)
        }
    }

}

extension ProfileViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView {
            let item = items[section]
            
            headerView.item = item
            headerView.section = section
            headerView.delegate = self
            return headerView
        }
        return UIView()
    }
}

extension ProfileViewModel: HeaderViewDelegate {
    func toggleSection(header: HeaderView, section: Int) {
        var item = items[section]
        if item.isCollapsible {
            
            // Toggle collapse
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            header.setCollapsed(collapsed: collapsed)
            
            // Adjust the number of the rows inside the section
            reloadSections?(section)
        }
    }
}

class ProfileViewModelNamePictureItem: ProfileViewModelItem {
    var headerImage: String
    {
        return "HOME"
    }
    
    var type: ProfileViewModelItemType {
        return .nameAndPicture
    }
    
    var isCollapsible: Bool {
        return true
    }

    var sectionTitle: String {
        return "Home"
    }
    
//    var isCollapsed = true
//
//    var name: String
//    var pictureUrl: String
//
//    init(name: String, pictureUrl: String) {
//        self.name = name
//        self.pictureUrl = pictureUrl
//    }
//
    
    
    
    
    var rowCount: Int {
        return home.count
    }
    
    var isCollapsed = true
    
    var home: [Home]
    
    init(friends: [Home]) {
        self.home = friends
    }
}

class ProfileViewModelAboutItem: ProfileViewModelItem {
   
    var headerImage: String
    {
        return "TICKET"
    }

    var type: ProfileViewModelItemType {
        return .about
    }
    
    var sectionTitle: String {
        return "Tickets"
    }
    
    
    var rowCount: Int {
        return tickets.count
    }
    
    var isCollapsed = true
    
    var tickets: [Tickets]
    
    init(friends: [Tickets]) {
        self.tickets = friends
    }
    
    
    
    
//    var isCollapsed = true
//    var about: String
//
//    init(about: String) {
//        self.about = about
//    }
}

class ProfileViewModelEmailItem: ProfileViewModelItem {
    var headerImage: String
    {
        return "REPORT"
    }

    var type: ProfileViewModelItemType {
        return .email
    }
    
    var sectionTitle: String {
        return "Reports"
    }
    
    
    
    var rowCount: Int {
        return reports.count
    }
    
    var isCollapsed = true
    
    var reports: [Reports]
    
    init(friends: [Reports]) {
        self.reports = friends
    }
//    var isCollapsed = true
//
//    var email: String
//
//    init(email: String) {
//        self.email = email
//    }
}

class ProfileViewModeAttributeItem: ProfileViewModelItem {
    var headerImage: String
    {
        return "geedesk"
    }
    var type: ProfileViewModelItemType {
        return .attribute
    }
    
    var sectionTitle: String {
        return "Add one"
    }
    
    var rowCount: Int {
        return attributes.count
    }
    
    var isCollapsed = true
    
    var attributes: [Attribute]
    
    init(attributes: [Attribute]) {
        self.attributes = attributes
    }
}

class ProfileViewModeFriendsItem: ProfileViewModelItem {
    var headerImage: String
    {
        return "geedesk"
    }
    

    var type: ProfileViewModelItemType {
        return .friend
    }
    
    var sectionTitle: String {
        return "Other"
    }
    
    var rowCount: Int {
        return friends.count
    }
    
    var isCollapsed = true
    
    var friends: [Friend]

    init(friends: [Friend]) {
        self.friends = friends
    }
}
