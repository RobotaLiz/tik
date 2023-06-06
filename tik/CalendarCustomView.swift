//
//  CalendarCustomView.swift
//  tik
//
//  Created by Hakan Johansson on 2023-05-30.
//

import Foundation
import SwiftUI

struct CalendarCustomView: View {
    
    let days = ["  ", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let cvHelper = CalendarViewHelper()
    @State var calendarArray: [[Date]] = []
    @State var toggle = true
    @StateObject var calendarVM : CalendarViewModel
    @EnvironmentObject var firestoreManagerVM : FirestoreManagerVM
    
    var body: some View {
        VStack {
            if toggle {
                VStack {
                    //Text(calendarVM.currentMonth.formatted(.dateTime.year()))
                    ScrollViewReader { value in
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(calendarVM.getAllDates(), id: \.self) { date in
                                    dateItem(date: date, calendarVM: calendarVM)
                                        .id(date)
                                }
                            }
                            .padding(.bottom)
                        }
                        .onAppear {
                            //Scroll to closet date in the future
                            if let date = calendarVM.getClosestDate() {
                                value.scrollTo(date, anchor: .center)
                            }
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            else {
                Text(calendarVM.currentMonth.formatted(.dateTime.month()))
                VStack {
                    HStack {
                        ForEach(days, id: \.self) {day in
                            Spacer()
                            Text("\(day)")
                            Spacer()
                        }
                    }
                    Divider()
                    ForEach(calendarArray, id: \.self) { row in
                        HStack {
                            Spacer()
                            Text("   ")
                            Spacer()
                            ForEach(row, id: \.self) {element in
                                Spacer()
                                CalendarDateItem(date: element, calendarVM: calendarVM)
                                Spacer()
                            }
                        }
                    }
                }
            }
            Button() {
                withAnimation {
                    toggle.toggle()
                }
            } label: {
                Image(systemName: toggle ? "arrow.down.square" : "arrow.up.square")
            }
            List {
                ForEach(calendarVM.tasks) { task in
                    TaskListRowView(task: task)
                }
            }
            .onAppear {
                calendarArray = cvHelper.createMonth(month: calendarVM.currentMonth)
            }
            
        }
        .onReceive(calendarVM.$currentMonth) { month in
            calendarArray = cvHelper.createMonth(month: month)
        }
    }
}
