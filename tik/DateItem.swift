//
//  DateItem.swift
//  tik
//
//  Created by Hakan Johansson on 2023-06-06.
//

import Foundation
import SwiftUI

struct dateItem: View {
    let date: Date
    let calendarVM: CalendarViewModel
    @State var selected = false
    
    var body: some View {
        ZStack {
            if selected {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.appYellow)
            }
            else {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.oWhite)
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 6, y: 6)
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: -2, y: -2)
            }
            Text(date.formatted(.dateTime.day().month()))
                .padding()//.horizontal)
        }
        .onTapGesture {
            calendarVM.toggleTask(date: date)
        }
        .onReceive(calendarVM.$dateList) { _ in
            if calendarVM.dateIsSelected(date: date) {
                selected = true
            }
            else {
                selected = false
            }
        }
    }
}
