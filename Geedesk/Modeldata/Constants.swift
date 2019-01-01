//
//  Constants.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 15/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import Foundation
struct GeedeskConstants
{
    
     static let BaseUrl = "https://app.geedesk.com"
     static let login = BaseUrl + "/api/v1/auth/login"
     static let logout = BaseUrl + "/api/v1/auth/logout"

     static let token = UserDefaults.standard.string(forKey: "access_token")
    
     static let category = BaseUrl + "/api/v1/category_api/ticket_type/access_token/" + token! + "/format/json"
     static let allrooms = BaseUrl + "/api/v1/rooms_api/all_rooms/access_token/" + token! + "/format/json"
     static let new_create_ticket_department = BaseUrl + "/api/v1/tickets_api/new_create_ticket_department"
     static let homePageTickets = BaseUrl + "/api/v1/tickets_api/app_main_page_tickets?access_token="
    
    
    //https://app.geedesk.com/api/v1/tickets_api/all_tickets/format/json?access_token=624ab3f9c2c4f6599bfbc5cccc7ee40b&counter=1
    
    static let alltickets = BaseUrl + "/api/v1/tickets_api/all_tickets/format/json?access_token="  + token! + "&counter=1"
    
   // /api/v1/tickets_api/timeline/format/json
    
     static let mytickets = BaseUrl + "/api/v1/tickets_api/my_tickets/format/json?access_token="  + token!
    //https://app.geedesk.com//api/v1/tickets_api/timeline/format/json?access_token=624ab3f9c2c4f6599bfbc5cccc7ee40b&counter=1
      static let timeline = BaseUrl + "/api/v1/tickets_api/timeline/format/json?access_token=" +
    token! + "&counter=1"
    
    
    //https://app.geedesk.com//api/v1/tickets_api/my_team_tickets/format/json?access_token=624ab3f9c2c4f6599bfbc5cccc7ee40b
    
    
    static let myteamtickets = BaseUrl + "/api/v1/tickets_api/my_team_tickets/format/json?access_token=" + token!
     static let all_new_tickets = BaseUrl + "/api/v1/tickets_api/all_new_tickets/format/json?access_token=" + token!
     static let all_open_tickets = BaseUrl + "/api/v1/tickets_api/all_open_tickets/format/json?access_token=" + token!
     static let sla_violated_tickets = BaseUrl + "/api/v1/tickets_api/sla_violated_tickets/format/json?access_token=" + token!
     static let onHoldTickets = BaseUrl + "/api/v1/tickets_api/all_onhold_tickets/format/json?access_token=" + token!
     static let resolvedTickets = BaseUrl + "/api/v1/tickets_api/all_resolved_tickets/format/json?access_token=" + token!
     static let DeletedTickets = BaseUrl + "/api/v1/tickets_api/all_deleted_tickets/format/json?access_token=" + token!
     static let schduledTickets = BaseUrl + "/api/v1/tickets_api/all_scheduled_tickets/format/json?access_token=" + token!
     static let vipAlerts = BaseUrl + "/api/v1/tickets_api/all_vip_alerts/format/json?access_token=" + token!
     static let user_details = BaseUrl + "/api/v1/users_api/user_details?access_token=" + token!
     static let ticketDetails = BaseUrl + "/api/v1/tickets_api/ticket_details_department/ticket_id/"
     static let updateprofilepic = BaseUrl + "/api/v1/users/update/profile-pic/format/json"
     static let updateticketstatus = BaseUrl + "/api/v1/tickets_api/update_ticket_status/format/json"
     static let updateticketpriority = BaseUrl + "/api/v1/tickets_api/update_ticket_priority/format/json"
     static let addticketcomment = BaseUrl + "/api/v1/tickets_api/add_ticket_comment/format/json"
     static let ticketComment = BaseUrl + "/api/v1/tickets_api/ticket_comments/ticket_id/"
     static let taketicket = BaseUrl + "/api/v1/tickets_api/take_ticket/format/json"
    
    
   
   
}
