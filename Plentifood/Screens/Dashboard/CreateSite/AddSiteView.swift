//
//  AddSiteView.swift
//  Plentifood
//
//  Created by Mami on 2/8/26.
//

import SwiftUI

struct AddSiteView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = CreateSiteViewModel()
    
    let onDone: () -> Void
    
    private var orgId: Int? { AdminSessionStore.loadOrganizationId() }

    @State private var name = ""
    @State private var address1 = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zip = ""
    @State private var phone = ""
    @State private var eligibility: Eligibility? = nil
    @State private var selectedServices: Set<SiteServiceType> = []
    @State private var openDays: Set<Weekday> = []
    @State private var hoursByDay: [Weekday: DayHours] =
       Dictionary(uniqueKeysWithValues: Weekday.allCases.map { ($0, DayHours()) })
    @State private var serviceNotes = ""


    
    private var isValid: Bool {
        !name.isEmpty &&
        !address1.isEmpty &&
        !city.isEmpty &&
        !state.isEmpty &&
        !zip.isEmpty &&
        !phone.isEmpty &&
        eligibility != nil &&
        !selectedServices.isEmpty &&
        hoursAreValid
    }
    
    
    private func bindingForTime(
       day: Weekday,
       keyPath: WritableKeyPath<DayHours, Date?>
    ) -> Binding<Date> {
       Binding<Date>(
          get: {
             // If nil, show "now" as a placeholder value in the picker
             hoursByDay[day]?[keyPath: keyPath] ?? Date()
          },
          set: { newValue in
             var current = hoursByDay[day] ?? DayHours()
             current[keyPath: keyPath] = newValue
             hoursByDay[day] = current
          }
       )
    }
    
    private var hoursAreValid: Bool {
       for day in Weekday.allCases {
          let h = hoursByDay[day] ?? DayHours()
          if h.isEmpty { continue }
          if !h.isComplete { return false }
          if let from = h.from, let to = h.to, from >= to { return false }
       }
       return true
    }
    

    private func timeString(_ date: Date) -> String {
       let formatter = DateFormatter()
       formatter.dateFormat = "HH:mm"
       return formatter.string(from: date)
    }
    
    
    private var hoursPayload: [String: [String: String]] {
       var result: [String: [String: String]] = [:]

       for day in Weekday.allCases {
          let key = day.rawValue   // "monday", etc.

          guard let h = hoursByDay[day], h.isComplete,
                let from = h.from, let to = h.to
          else {
             // Closed day → empty dict
             result[key] = [:]
             continue
          }

          result[key] = [
             "from": timeString(from),
             "to": timeString(to)
          ]
       }

       return result
    }

    private func defaultTime(hour: Int, minute: Int) -> Date {
       var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
       comps.hour = hour
       comps.minute = minute
       return Calendar.current.date(from: comps) ?? Date()
    }

    

    var body: some View {
          NavigationStack {
             Form {
                 if let msg = vm.errorMessage {
                    Section {
                       Text(msg)
                          .foregroundStyle(.red)
                    }
                 }

                Section("Site Info") {
                   TextField("Site name", text: $name)

                   TextField("Address line 1", text: $address1)

                   TextField("City", text: $city)

                   TextField("State", text: $state)
                      .textInputAutocapitalization(.characters)

                   TextField("ZIP code", text: $zip)
                      .keyboardType(.numbersAndPunctuation)

                   TextField("Phone", text: $phone)
                      .keyboardType(.phonePad)
                }
                Section {
                    Picker(
                       selection: Binding(
                          get: { eligibility ?? .generalPublic },
                          set: { eligibility = $0 }
                       ),
                       label: Text("Eligibility *")
                    ) {
                       ForEach(Eligibility.allCases) { item in
                          Text(item.displayName).tag(item)
                       }
                    }
                    .pickerStyle(.menu)
                 } header: {
                    Text("Eligibility *")
                 }


                 Section("Service Types *") {
                    ForEach(SiteServiceType.allCases) { service in
                       Button {
                          if selectedServices.contains(service) {
                             selectedServices.remove(service)
                          } else {
                             selectedServices.insert(service)
                          }
                       } label: {
                          HStack {
                             Text(service.displayName)
                             Spacer()
                             if selectedServices.contains(service) {
                                Image(systemName: "checkmark")
                                   .foregroundStyle(.orange)
                                   .font(.system(size: 20, weight: .bold))
                             }
                          }
                       }
                       .buttonStyle(.plain)
                    }
                 }
                 
                 Section("Operating hours") {
                     ForEach(Weekday.allCases) { day in
                         VStack(alignment: .leading, spacing: 8) {
                             HStack {
                                 Text(day.displayName)
                                     .font(.headline)
                                     .foregroundStyle(.secondary)
                                 
                                 Spacer()
                                 
                                 Toggle("Open", isOn: Binding(
                                    get: { openDays.contains(day) },
                                    set: { isOn in
                                        if isOn {
                                            openDays.insert(day)
                                            
                                            // Set sensible defaults so it doesn't show "current time"
                                            var h = hoursByDay[day] ?? DayHours()
                                            if h.from == nil { h.from = defaultTime(hour: 9, minute: 0) }
                                            if h.to == nil { h.to = defaultTime(hour: 17, minute: 0) }
                                            hoursByDay[day] = h
                                        } else {
                                            openDays.remove(day)
                                            hoursByDay[day] = DayHours()   // closed
                                        }
                                    }
                                 ))
                                 .labelsHidden()
//                                 .tint(.orange) // it looks like warning
                             }
                             
                             if openDays.contains(day) {
                                 HStack(spacing: 12) {
                                     DatePicker(
                                        "From",
                                        selection: bindingForTime(day: day, keyPath: \.from),
                                        displayedComponents: .hourAndMinute
                                     )
                                     .labelsHidden()
                                     
                                     Text("to").foregroundStyle(.secondary)
                                     
                                     DatePicker(
                                        "To",
                                        selection: bindingForTime(day: day, keyPath: \.to),
                                        displayedComponents: .hourAndMinute
                                     )
                                     .labelsHidden()
                                 }
                             } else {
                                 Text("Closed")
                                     .font(.footnote)
                                     .foregroundStyle(.secondary)
                             }
                         }
                         .padding(.vertical, 6)
                     }
                 }

                 
                 Section("Service notes (optional)") {
                    ZStack(alignment: .topLeading) {
                       TextEditor(text: $serviceNotes)
                          .frame(minHeight: 100)

                       if serviceNotes.isEmpty {
                          Text("Add any additional information about services")
                             .foregroundStyle(.secondary)
                             .padding(.top, 8)
                             .padding(.leading, 5)
                             .allowsHitTesting(false)
                       }
                    }
                 }


             }
             .disabled(vm.isSubmitting)
             .navigationTitle("Site Registration")
//             .navigationBarTitleDisplayMode(.large)
             .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                   Button("Cancel") {
                      dismiss()
                   }
                }

                 ToolbarItem(placement: .topBarTrailing) {
                    Button(vm.isSubmitting ? "Saving..." : "Save") {
//                        print("Save tapped. orgId:", orgId as Any)
                       guard let orgId else {
                          vm.errorMessage = "Missing organization ID. Please log in again."
                          return
                       }

                       Task {
                           print("Submitting...")
                           await vm.submit(
                             orgId: orgId,
                             name: name,
                             address1: address1,
                             address2: nil, // add address2 field later
                             city: city,
                             state: state,
                             zip: zip,
                             phone: phone,
                             eligibility: eligibility!, // safe because isValid requires it
                             selectedServices: selectedServices,
                             hoursByDay: hoursByDay,
                             serviceNotes: serviceNotes
                          )
                           print("didSucceed:", vm.didSucceed, "error:", vm.errorMessage as Any)

                          if vm.didSucceed {
                            onDone()
                            dismiss()
                          }
                       }
                    }
                    .disabled(!isValid || vm.isSubmitting || orgId == nil)
                    .tint(.orange)
                 }


             }
          }
       }
    }


//#Preview {
//    AddSiteView()
//}
