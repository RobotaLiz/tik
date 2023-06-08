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
                    .fill(Color.offWhite)
            }
            else {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.oWhite)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 4, y: 4)
                    .shadow(color: Color.white.opacity(0.7), radius: 5, x: -2, y: -2)
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
