module hospital::management {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer::{Self, transfer};
    use sui::package::{Self, Publisher};
    use sui::kiosk::{Self, KioskOwnerCap};

    use std::string::{Self, String};
    use std::vector::Vector;

    // Hospital Structure
    struct Hospital has key {
        id: UID,
        name: String,
        address: String,
        contact_info: String,
        hospital_type: String, // Public or Private
        capacity: u64, // Added capacity to manage hospital load
    }

    // Patient Structure
    struct Patient has key {
        id: UID,
        name: String,
        age: u64,
        gender: String,
        contact_info: String,
        emergency_contact: String,
        admission_reason: String,
        discharge_date: Option<u64>,
    }

    // AdminCap Structure to control access
    struct AdminCap has key {
        id: UID,
    }

    // Billing Structure
    struct Bill has key {
        id: UID,
        patient_id: UID,
        charges: Vector<u64>,
        payment_method: String,
        payment_date: Option<u64>,
    }

    // AdminCap Structure to control access
    struct AdminCap has key {
        id: UID,
    }

    // Initialize the module with admin capability
    fun init(ctx: &mut TxContext) {
        transfer::transfer(AdminCap { id: object::new(ctx) }, tx_context::sender(ctx));
    }

    // Create a new hospital
    public fun create_hospital(name: String, address: String, contact_info: String, hospital_type: String, capacity: u64, ctx: &mut TxContext): Hospital {
        // Basic data validation
        assert(!name.is_empty() && !address.is_empty() && !contact_info.is_empty(), 1000, "Invalid hospital details");
        Hospital {
            id: object::new(ctx),
            name,
            address,
            contact_info,
            hospital_type,
            capacity,
        }
    }

      // Admit a patient
    public fun admit_patient(hospital_id: UID, name: String, age: u64, gender: String, contact_info: String, emergency_contact: String, admission_reason: String, ctx: &mut TxContext): Patient {
        let hospital_ref = borrow_global_mut<Hospital>(hospital_id);
        assert(hospital_ref.capacity > 0, 1001, "Hospital is at full capacity");
        hospital_ref.capacity -= 1;

        Patient {
            id: object::new(ctx),
            name,
            age,
            gender,
            contact_info,
            emergency_contact,
            admission_reason,
            discharge_date: None,
        }
    }

    // Discharge a patient
    public fun discharge_patient(patient: &mut Patient, discharge_date: u64) {
        patient.discharge_date = Some(discharge_date);
    }

    // Generate a detailed bill for a patient
    public fun generate_bill(patient_id: UID, charges: Vector<u64>, payment_method: String, ctx: &mut TxContext): Bill {
        assert(!charges.is_empty(), 1004, "Charges cannot be empty");
        assert(!payment_method.is_empty(), 1005, "Payment method cannot be empty");
        Bill {
            id: object::new(ctx),
            patient_id,
            charges,
            payment_method,
            payment_date: None,
        }
    }

    // Pay a bill
    public fun pay_bill(bill: &mut Bill, payment_method: String, payment_date: u64) {
        assert(!payment_method.is_empty(), 1005, "Payment method cannot be empty");
        bill.payment_method = payment_method;
        bill.payment_date = Some(payment_date);
        log_operation("Bill Paid", bill.id); // Log the payment operation
    }


    // =================== Utility Functions ===================
    // Get hospital details
    public fun get_hospital(hospital: &Hospital): &Hospital {
        hospital
    }

    // Get all patients
    public fun get_patients(patients: &[Patient]): &[Patient] {
        patients
    }

    // Delete a hospital record
    public fun delete_hospital(admin_cap: &AdminCap, hospital_id: UID) {
        assert(has_admin_rights(admin_cap), 1002, "Unauthorized access");
        object::delete(hospital_id);
    }


    // Delete a patient record
    public fun delete_patient(patient: Patient) {
        object::delete(patient.id);
    }

    // Update patient information
    public fun update_patient(admin_cap: &AdminCap, patient: &mut Patient, new_name: String, new_contact_info: String) {
        assert(has_admin_rights(admin_cap), 1002, "Unauthorized access");
        patient.name = new_name;
        patient.contact_info = new_contact_info;
        log_operation("Patient Updated", patient.id); // Log the update operation
    }

    // Update hospital information
    public fun update_hospital(admin_cap: &AdminCap, hospital: &mut Hospital, new_address: String, new_contact_info: String) {
        assert(has_admin_rights(admin_cap), 1002, "Unauthorized access");
        hospital.address = new_address;
        hospital.contact_info = new_contact_info;
        log_operation("Hospital Updated", hospital.id); // Log the update operation
    }

    // Check admin rights
    fun has_admin_rights(admin_cap: &AdminCap): bool {
        admin_cap.id == tx_context::sender(ctx) // This checks if the admin capability matches the sender
    }
}
