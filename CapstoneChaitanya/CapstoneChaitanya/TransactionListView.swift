//
//  TransactionListView.swift
//  CapstoneChaitanya
//
//  Created by admin on 15/02/25.
//

import SwiftUI

struct TransactionListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Appointment.entity(), sortDescriptors: [])
    private var appointments: FetchedResults<Appointment>
    @State private var showAddSlot = false
    @State private var selectedAppointment: Appointment?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(appointments) { appointment in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(appointment.pateinName ?? "No Name")
                                    .font(.headline)

                                if let date = appointment.date {
                                    Text(date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Text(appointment.status ?? "No Status")
                                    .font(.subheadline)
                                    .foregroundColor(appointment.status == "Pending" ? .orange : (appointment.status == "Accepted" ? .green : .red))
                            }
                            Spacer()
                            
                            Button("Edit") {
                                selectedAppointment = appointment
                                showAddSlot = true
                            }
                            .buttonStyle(.bordered)

                            if appointment.status == "Pending" {
                                Button("Accept") {
                                    updateAppointmentStatus(appointment, status: "Accepted")
                                }
                                .tint(.green)
                                .buttonStyle(.bordered)

                                Button("Reject") {
                                    updateAppointmentStatus(appointment, status: "Rejected")
                                }
                                .tint(.red)
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    .onDelete(perform: deleteAppointment)
                }
            }
            .navigationTitle("Appointments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedAppointment = nil
                        showAddSlot = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSlot) {
                AddSlotsView(appointment: selectedAppointment)
            }
        }
    }

    private func updateAppointmentStatus(_ appointment: Appointment, status: String) {
        appointment.status = status
        saveContext()
    }

    private func deleteAppointment(at offsets: IndexSet) {
        for index in offsets {
            let appointment = appointments[index]
            viewContext.delete(appointment)
        }
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
}
