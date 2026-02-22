//
//  CreateSiteViewModel.swift
//  Plentifood
//
//  Created by Mami on 2/9/26.
//

import Foundation
import Combine


@MainActor
final class CreateSiteViewModel: ObservableObject {
    @Published var isSubmitting = false
    @Published var errorMessage: String? = nil
    @Published var didSucceed = false

    private let api: PlentiFoodAPI

    init(api: PlentiFoodAPI? = nil ){
        self.api = api ?? PlentiFoodAPI()
    }
    
    
    func clearError() {
        errorMessage = nil
    }

   // MARK: - Submit

   func submit(
      orgId: Int,
      name: String,
      address1: String,
      address2: String?,
      city: String,
      state: String,
      zip: String,
      phone: String,
      eligibility: Eligibility,
      selectedServices: Set<SiteServiceType>,
      hoursByDay: [Weekday: DayHours],
      serviceNotes: String,
//      baseURL: URL
      
   ) async -> Site? {
       
      isSubmitting = true
      errorMessage = nil
      didSucceed = false
      defer { isSubmitting = false }

       if let validation = validate(
             name: name,
             address1: address1,
             city: city,
             state: state,
             zip: zip,
             eligibility: eligibility,
             selectedServices: selectedServices,
             hoursByDay: hoursByDay
          ) {
             errorMessage = validation
             return nil
          }
       
       let body = CreateSiteRequestDTO(
             name: name,
             addressLine1: address1,
             addressLine2: address2,
             city: city,
             state: state,
             postalCode: zip,
             phone: phone,
             eligibility: eligibility.rawValue,
             hours: hoursPayload(from: hoursByDay),
             serviceNotes: serviceNotes,
             services: selectedServices.map(\.rawValue),
             latitude: nil,
             longitude: nil
          )

      // 3) POST
       do {
             let createdDTO = try await api.createSite(orgId: orgId, body: body)
             didSucceed = true
             return Site(dto: createdDTO)   // ✅ map DTO -> UI model
          } catch {
             errorMessage = "Failed to create site: \(error.localizedDescription)"
             return nil
          }


   }
}

// Helper
extension CreateSiteViewModel {

   func validate(
      name: String,
      address1: String,
      city: String,
      state: String,
      zip: String,
      eligibility: Eligibility,
      selectedServices: Set<SiteServiceType>,
      hoursByDay: [Weekday: DayHours]
   ) -> String? {

      if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Site name is required." }
      if address1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Address line 1 is required." }
      if city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "City is required." }
      if state.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "State is required." }
      if zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "ZIP code is required." }

      if selectedServices.isEmpty { return "Select at least one service type." }

      // Hours validation: each day must be empty OR complete, and from < to
      for day in Weekday.allCases {
         let h = hoursByDay[day] ?? DayHours()
         if h.isEmpty { continue }
         if !h.isComplete { return "For \(day.displayName), select both From and To (or clear the day)." }
         if let from = h.from, let to = h.to, from >= to { return "For \(day.displayName), From must be earlier than To." }
      }

      // eligibility is non-optional here, so no check needed
      _ = eligibility

      return nil
   }

   func makePayload(
      name: String,
      address1: String,
      address2: String?,
      city: String,
      state: String,
      zip: String,
      phone: String,
      eligibility: Eligibility,
      selectedServices: Set<SiteServiceType>,
      hoursByDay: [Weekday: DayHours],
      serviceNotes: String
   ) -> [String: Any] {

      var payload: [String: Any] = [
         "name": name,
         "address_line1": address1,
         "city": city,
         "state": state,
         "postal_code": zip,
         "phone": phone,
         "eligibility": eligibility.rawValue,
         "services": selectedServices.map(\.rawValue),
         "hours": hoursPayload(from: hoursByDay),
         "service_notes": serviceNotes
      ]

      if let address2, !address2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
         payload["address_line2"] = address2
      }

      return payload
   }

   func hoursPayload(from hoursByDay: [Weekday: DayHours]) -> [String: [String: String]] {
      // Backend requires ALL 7 keys.
      var result: [String: [String: String]] = [:]
      for day in Weekday.allCases {
         let key = day.rawValue // "monday" etc
         let h = hoursByDay[day] ?? DayHours()

         if h.isComplete, let from = h.from, let to = h.to {
            result[key] = [
               "from": timeString(from),
               "to": timeString(to)
            ]
         } else {
            result[key] = [:] // closed day
         }
      }
      return result
   }

   func timeString(_ date: Date) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "HH:mm"
      return formatter.string(from: date)
   }

   func parseFlaskError(data: Data) -> String? {
      // Flask errors in your routes look like: {"details": "..."}
      guard
         let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
         let details = obj["details"] as? String
      else { return nil }
      return details
   }
}

