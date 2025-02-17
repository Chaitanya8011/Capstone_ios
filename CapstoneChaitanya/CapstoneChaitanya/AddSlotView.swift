import SwiftUI

struct AddSlotsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var date = Date()
    @State private var patientName = ""
    var appointment: Appointment?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add Slot")) {
                    DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    TextField("Patient Name", text: $patientName)
                }
            }
            .onAppear {
                // Populate fields if editing an existing appointment
                if let appointment = appointment {
                    patientName = appointment.pateinName ?? ""
                    date = appointment.date ?? Date()
                }
            }
            .navigationBarTitle(appointment == nil ? "Add Slot" : "Edit Slot", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button(appointment == nil ? "Save" : "Update") {
                    saveOrUpdateSlot()
                    dismiss()
                }
                .disabled(patientName.isEmpty)
            )
        }
    }
    
    private func saveOrUpdateSlot() {
        if let appointment = appointment {
            // Update existing appointment
            appointment.date = date
            appointment.pateinName = patientName
        } else {
            // Add new appointment
            let newAppointment = Appointment(context: viewContext)
            newAppointment.id = UUID()
            newAppointment.pateinName = patientName
            newAppointment.date = date
            newAppointment.status = "Pending"
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving slot: \(error)")
        }
    }
}

struct AddSlotsView_Previews: PreviewProvider {
    static var previews: some View {
        AddSlotsView()
    }
}
