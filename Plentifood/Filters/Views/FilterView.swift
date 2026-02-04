//
//  FilterView.swift
//  Plentifood
//
//  Created by Mami on 2/3/26.
//

import SwiftUI

struct FilterView: View {
   @Environment(\.dismiss) private var dismiss

   @Binding var filters: SearchFilters

   @State private var draft: SearchFilters
   @State private var radiusText: String = ""

   init(filters: Binding<SearchFilters>) {
      _filters = filters
      _draft = State(initialValue: filters.wrappedValue)
   }

   var body: some View {
      NavigationStack {
         ScrollView {
            VStack(alignment: .leading, spacing: 20) {

               sectionTitle("Day of Service")
               ChipGrid(items: DayOfWeek.allCases,
                        selected: $draft.days,
                        label: { $0.chipLabel })

               sectionTitle("Organization Type")
               ChipGrid(items: OrgType.allCases,
                        selected: $draft.orgTypes,
                        label: { $0.chipLabel })

               sectionTitle("Service Type")
               ChipGrid(items: ServiceType.allCases,
                        selected: $draft.serviceTypes,
                        label: { $0.chipLabel })

               sectionTitle("Radius")
               HStack(spacing: 12) {
                  Text("Within")
                  TextField("", text: $radiusText)
                     .keyboardType(.decimalPad)
                     .textFieldStyle(.roundedBorder)
                     .frame(width: 110)
                  Text("miles")
                  Spacer()
               }

               Button {
                  apply()
               } label: {
                  Text("Apply Filters")
                     .frame(maxWidth: .infinity)
                     .padding(.vertical, 12)
               }
               .buttonStyle(.borderedProminent)
               .tint(.orange)
               .padding(.top, 8)
            }
            .padding()
         }
         .navigationTitle("Filters")
         .navigationBarTitleDisplayMode(.inline)
         .toolbar {
            ToolbarItem(placement: .topBarLeading) {
               Button {
                  dismiss()
               } label: {
                  Image(systemName: "chevron.left")
               }
            }

            ToolbarItem(placement: .topBarTrailing) {
               Button("Reset") {
                  reset()
               }
            }
         }
         .onAppear {
            // 既存フィルターがあれば TextField に反映
            if let r = draft.radiusMiles {
               radiusText = String(r)
            } else {
               radiusText = ""
            }
         }
      }
   }

   private func sectionTitle(_ text: String) -> some View {
      Text(text)
         .font(.headline)
   }

   private func reset() {
      draft = .default
      radiusText = ""
   }

   private func apply() {
      // radiusText -> Double?
      let trimmed = radiusText.trimmingCharacters(in: .whitespacesAndNewlines)
      if trimmed.isEmpty {
         draft.radiusMiles = nil
      } else {
         draft.radiusMiles = Double(trimmed)
      }

      filters = draft
      dismiss()
   }
}

//#Preview {
//    FilterView()
//}
