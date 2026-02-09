//
//  SiteDetailSheet.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import SwiftUI
import MapKit

struct SiteDetailSheet: View {
    let site: Site
    @Environment(\.dismiss) private var dismiss
    
    @State private var camera: MapCameraPosition
    
    init(site: Site) {
        self.site = site
        _camera = State(initialValue: .region(
            MKCoordinateRegion(
                center: site.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    
//                    Divider()
//                    servicesSection
                    
                    Divider()
                    infoSection
                    
                    Divider()
                    eligibilitySection
                    
                    Divider()
                    hoursSection
                    
                    Divider()
                    notesSection
                    
                }
                .padding(.horizontal, 30)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    // MARK: components for each section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(site.name)
                .font(.title2)
                .bold()
            
//            Text(site.shortAddress)
//                .font(.subheadline)
//                .foregroundStyle(.secondary)
            
            let serviceLabels = site.services.map { $0.name.displayLabel }
                  if !serviceLabels.isEmpty {
                     WrapChips(items: serviceLabels)
                        .padding(.top, 4)
                  }
        }
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            InfoRow(icon: "mappin.and.ellipse", title: "Address", value: site.shortAddress)
            
            if let phone = site.phone, !phone.isEmpty {
                InfoRow(icon: "phone", title: "Phone", value: phone)
            }
            
            if let status = site.status, !status.isEmpty {
                InfoRow(icon: "clock", title: "Status", value: status.capitalized)
            }
        }
    }
    
//    private var servicesSection: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            SectionTitle(icon: "gearshape", "Services")
//        
//            // Simple wrap (good enough to start):
//            // It will line-break naturally if you use LazyVGrid later.
//            WrapChips(items: site.services.map { $0.name.displayLabel })
//        }
//    }

    private var eligibilitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(icon: "person.crop.circle", "Eligibility")
            
            if let eligibility = site.eligibility, !eligibility.isEmpty {
                TagChip(text: eligibility.displayLabel)
            } else {
                Text("Not specified")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private let weekdayOrder = [
       "monday", "tuesday", "wednesday",
       "thursday", "friday", "saturday", "sunday"
    ]

    
    private var hoursSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(icon: "clock", "Hours")
            
            ForEach(weekdayOrder, id: \.self) { day in
                HStack(alignment: .firstTextBaseline) {
                    TagChip(text: day.uppercased())
                    Spacer()
                    
                    let hoursText = site.hoursForDay(day)
                    Text(hoursText)
                        .font(.subheadline)
                        .foregroundStyle(hoursText == "Closed" ? .secondary : .primary)
                }
                
            }
        }
        
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle(icon:"note", "Notes")
            
            if let notes = site.service_notes, !notes.isEmpty {
                Text(notes)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                Text("No notes.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    
    
    
//    #Preview {
//       SiteDetailSheet(
//          site: Site(
//             id: 1,
//             name: "ACRS Food Bank and Meals",
//             latitude: 47.5923,
//             longitude: -122.3294,
//             address_line1: "800 S Weller St",
//             city: "Seattle",
//             state: "WA",
//             postal_code: "98004",
//             phone: "(253)-351-0450",
//             organization_name: "Asian Counseling and Referral Service",
//             organization_type: "food_bank",
//             organization_website_url: "https://acrs.org/",
//             eligibility: "general_public",
//             services: [
//                Service(id: 1, name: "food_bank")
//             ],
//             service_notes: "Numbers are given out at 10:00 AM. Please arrive early.",
//             hours: [
//                "monday": [HoursEntry(open: "10:00", close: "14:00")],
//                "tuesday": [HoursEntry(open: "10:00", close: "14:00")],
//                "wednesday": [],
//                "thursday": [],
//                "friday": [],
//                "saturday": [],
//                "sunday": []
//             ],
//             status: "open"
//          )
//       )
//    }
}
//#Preview {
//    SiteDetailSheet(site: Site)
//}
