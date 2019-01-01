//
//  ModelClass.swift
//  Geedesk
//
//  Created by Ashok Reddy G on 20/12/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import Foundation
import UIKit

class SharedData {
    
    static let data = SharedData()
    var image: UIImage?
    var allRooms:[AllRooms]?
    var allCategories:[AllCategories]?
    var myTickets:[newtickets]?
    var homeAllTickets:[HomeAllTickets]?
    var vipAlert:[VipAlert]?
    var userProfile:[UserProfile]?
    var ticketDetails:[TicketDetials]?
    var ticketCommentDetails:[TicketCommentsDetials]?
    var timeLine:[TimeLine]?
    
}

struct AllRooms:Codable
{
    var id: String?
    var dept_name: String?
    var category_id: Int?
    var company_id: String?
    var dept_creation_date: String?
}

struct AllCategories:Codable
{
    var id: String?
    var name: String?
    var dept_name: String?
}

struct HomeAllTickets : Codable
{
    let ticket_status:String?
    var new_tickets:[newtickets]?
    var open_tickets:[opentickets]?
    var onhold_tickets:[onholdtickets]?
    
}



struct newtickets :Codable
{
    var id: String?
    var priority: String?
    var ticket_heading: String?
    var ticket_body: String?
    var ticket_status: String?
    var ticket_created_on: String?
    var queue_id: String?
    var ticket_is_incident: String?
    var company_id: String?
    var ticket_sla_violated: String?
    var ticket_created_by: String?
    var guest_ticket: String?
    var queue_name: String?
    var dept_name:String?
    
}

struct TimeLine :Codable

{
    
    var id: String?
    var ticket_id: String?
    var old_value: String?
    var changed_value: String?
    var changes_type: String?
    var created_on: String?
    var created_by:String?
    var company_id: String?
    var send_tracked_ticket_update:String?
    var phone_number: String?
    var user_name:String?
    var user_fname: String?
    var user_lname: String?
    var user_profilepic: String?
    var gender:String?
    var message:Message?
    var status: String?
    
}
struct Message : Codable
{
        var title: String?
        var message: String?
        var  symbol: String?
    
}


struct UserProfile : Codable {
    var id: String?
    var user_id: String?
    var company_id: String?
    var access_token: String?
    var token_gen_datetime: String?
    var device_IMEI_MEID_ESN: String?
    var user_fname: String?
    var user_lname:String?
    var user_role: String?
    var status: String?
    var user_name: String?
    var phone_number: String?
    var additional_phone_number: String?
    var gender: String?
    var user_password: String?
    var user_profilepic: String?
    var profilepic_type: String?
    var setup_required: String?
    var signature: String?
    var user_created_date: String?
    var date_format_company: String?
    var hotel_name: String?
}


struct VipAlert : Codable {
    
    var id: String?
    var company_id: String?
    var dept_name: String?
    var user_fname: String?
    var user_lname: String?
    var phone_number: String?
    var send_alert: String?
    var alert_raised_on: String?
    var alert_comment: String?
    
}

struct opentickets :Codable
{
    var id: String?
    var priority: String?
    var ticket_heading: String?
    var ticket_body: String?
    var ticket_status: String?
    var ticket_created_on: String?
    var queue_id: String?
    var ticket_is_incident: String?
    var company_id: String?
    var ticket_sla_violated: String?
    var ticket_created_by: String?
    var guest_ticket: String?
    var queue_name: String?
    var dept_name:String?
}

struct TicketDetials: Codable {
    var ticket_heading: String?
     var id: String?
     var priority: String?
    var ticket_status: String?
    var ticket_created_on: String?
    var ticket_taken_on: String?
    var ticket_body: String?
    var scheduled_on: String?
    var guest_call: String?
    var room_name: String?
    var department_name: String?
    var owner_fname: String?
    var owner_lname:String?
    var user_fname: String?
    var user_lname: String?
}


struct  TicketCommentsDetials :Codable {
    var comment_created_on : String?
    var commentby_fname : String?
    var commentby_lname : String?
    var ticket_comment : String?
}
struct onholdtickets :Codable
{
    var id: String?
    var priority: String?
    var ticket_heading: String?
    var ticket_body: String?
    var ticket_status: String?
    var ticket_created_on: String?
    var queue_id: String?
    var ticket_is_incident: String?
    var company_id: String?
    var ticket_sla_violated: String?
    var ticket_created_by: String?
    var guest_ticket: String?
    var queue_name: String?
    var dept_name:String?
}


