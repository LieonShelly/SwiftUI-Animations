//
//  MockData.swift
//  SwiftUI-Animations
//
//  Created by Renjun Li on 2025/6/24.
//

import SwiftUI


func getTicketsInfo(for event: Event) -> [TicketsInfo] {
    var ticketsLeft = event.ticketsLeft
    var info: [TicketsInfo] = []
    
    (1...4).forEach {
        let random: Int = .random(in: 15...245)
        let left = random > ticketsLeft ? ticketsLeft : random
        ticketsLeft -= left
        
        info.append(TicketsInfo(type: "Category \($0)", price: .random(in: 250...350) / $0, left: left))
    }
    
    return info
}


func fetchMoreEvents(toAppend: [Event]) async -> [Event] {
    if !toAppend.isEmpty {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
    }
    let newEvents = teams.map { team in makeEvent(for: team) }
    
    return (toAppend + newEvents).lazy.sorted { $0.date < $1.date }
}

func makeEvent(for team: Team) -> Event {
    let ticketsLeft = Bool.random() ? Int.random(in: 0...1000) : 0
    return Event(team: team, location: venues.randomElement(), ticketsLeft: ticketsLeft)
}

extension Date {
    static func random() -> Date {
        let date = Date()
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        guard
            let days = calendar.range(of: .day, in: .month, for: date),
            let randomDay = days.randomElement()
        else {
            return date
        }
        dateComponents.setValue(randomDay, for: .day)
        return calendar.date(from: dateComponents) ?? date
    }
}

extension Int {
    static func randomId() -> Int {
        return Int.random(in: 0...1_000_000)
    }
}

let sportTypeImages = [
    "https://images.unsplash.com/photo-1508098682722-e99c43a406b2",
    "https://images.unsplash.com/photo-1577471488278-16eec37ffcc2",
    "https://images.unsplash.com/photo-1549956847-f77eb7058468"
]

let venues = [
    "Intrust Bank Arena",
    "BOK Center",
    "Intrust Bank Arena Parking Lots",
    "BOK Center Parking Lots"
]

let teams = [
    Team(name: "Arizona Coyotes", sport: .iceHockey, description: "The Arizona Coyotes are a professional ice hockey team based in the Phoenix metropolitan area. The Coyotes compete in the National Hockey League as a member of the Central Division in the Western Conference and currently play at the ASU Multi-Purpose Arena in Tempe."),
    Team(name: "Cincinnati Cyclones", sport: .iceHockey, description: "The Cincinnati Cyclones are a professional ice hockey team based in Cincinnati, Ohio. The team is a member of the ECHL. Originally established in 1990, the team first played their games in the Cincinnati Gardens and now play at Heritage Bank Center."),
    Team(name: "Dallas Mavericks", sport: .basketball, description: "The Dallas Mavericks are an American professional basketball team based in Dallas. The Mavericks compete in the National Basketball Association as a member of the Western Conference Southwest Division."),
    Team(name: "Kansas City Mavericks", sport: .iceHockey, description: "The Kansas City Mavericks are an ice hockey team in the ECHL. Founded in 2009 as the Missouri Mavericks of the CHL, the team plays in Independence, Missouri, a suburb of Kansas City, Missouri, at the Cable Dahmer Arena."),
    Team(name: "Oklahoma City Thunder", sport: .basketball, description: "The Oklahoma City Thunder are an American professional basketball team based in Oklahoma City. The Thunder compete in the National Basketball Association as a member of the league's Western Conference Northwest Division."),
    Team(name: "Cincinnati Bearcats", sport: .football, description: "The Cincinnati Bearcats football program represents the University of Cincinnati in college football, they compete at the NCAA Division I Football Bowl Subdivision level as members of the American Athletic Conference."),
    Team(name: "Tulsa Golden Hurricane", sport: .football, description: "The Tulsa Golden Hurricane football program represents the University of Tulsa in college football at the NCAA Division I Football Bowl Subdivision level. Tulsa has competed in the American Athletic Conference since the 2014 season and was previously a member of Conference USA.")
]


