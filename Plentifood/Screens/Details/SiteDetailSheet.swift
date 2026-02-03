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
                // Map header
//                Map(position: $camera) {
//                    Annotation(site.name, coordinate: site.coordinate) {
//                        Image(systemName: "mappin.circle.fill")
//                            .font(.title)
//                    }
//                }
//                .frame(height: 220)
//                .clipShape(RoundedRectangle(cornerRadius: 16))
//                .padding(.horizontal)
//                .padding(.top, 8)
//                .allowsHitTesting(false)
                
                // Content Panel
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    
                    Divider()
                    
                    infoSection
                    
                    // Later sections (stub for now)
                    // Divider(); servicesSection
                    // Divider(); hoursSection
                    // Divider(); notesSection
                }
                .padding()
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
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(site.name)
                .font(.title2)
                .bold()
            
            Text(site.shortAddress)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let org = site.organization_name, !org.isEmpty {
                Text("Organization: \(org)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
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
    

    
    
    #Preview {
       SiteDetailSheet(
          site: Site(
             id: 1,
             name: "ACRS Food Bank and Meals",
             latitude: 47.5923,
             longitude: -122.3294,
             address_line1: "800 S Weller St",
             city: "Seattle",
             state: "WA",
             postal_code: "98004",
             phone: "(253)-351-0450",
             organization_name: "Asian Counseling and Referral Service",
             organization_type: "food_bank",
             organization_website_url: "https://acrs.org/",
             eligibility: "general_public",
             services: [
                Service(id: 1, name: "food_bank")
             ],
             service_notes: "Numbers are given out at 10:00 AM. Please arrive early.",
             hours: [
                "monday": [HoursEntry(open: "10:00", close: "14:00")],
                "tuesday": [HoursEntry(open: "10:00", close: "14:00")],
                "wednesday": [],
                "thursday": [],
                "friday": [],
                "saturday": [],
                "sunday": []
             ],
             status: "open"
          )
       )
    }
}
//#Preview {
//    SiteDetailSheet(site: Site)
//}
