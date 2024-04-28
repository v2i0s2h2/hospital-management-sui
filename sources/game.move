module hospital::management {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer::{Self, transfer};
    use sui::package::{Self, Publisher};
    use sui::kiosk::{Self, KioskOwnerCap};
    use sui::event::{Self, emit};

    use std::string::{Self, String};

    // Hospital Structure
    struct Hospital has key {
        id: UID,
        name: String,
        address: String,
        contact_info: String,
        hospital_type: String, // Public or Private
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

    // Billing Structure
    struct Bill has key {
        id: UID,
        patient_id: UID,
        charges: Vec<u64>,
        payment_method: String,
        payment_date: Option<u64>,
    }

    // AdminCap Structure to control access
    struct AdminCap has key {
        id: UID,
    }

    // DoctorCap Structure to control access
    struct DoctorCap has key {
        id: UID,
    }

    // NurseCap Structure to control access
    struct NurseCap has key {
        id: UID,
    }

    // Initialize the module with admin capability
    fun init(ctx: &mut TxContext) {
        transfer::transfer(AdminCap { id: object::new(ctx) }, tx_context::sender(ctx));
    }

    // Create a new hospital
    public fun create_hospital(name: String, address: String, contact_info: String, hospital_type: String, ctx: &mut TxContext): Hospital {
        Hospital {
            id: object::new(ctx),
            name,
            address,
            contact_info,
            hospital_type,
        }
    }

    // Admit a patient
    public fun admit_patient(name: String, age: u64, gender: String, contact_info: String, emergency_contact: String, admission_reason: String, ctx: &mut TxContext) -> Patient {
        let patient = Patient {
            id: object::new(ctx),
            name,
            age,
            gender,
            contact_info,
            emergency_contact,
            admission_reason,
            discharge_date: None,
        };

        // Emit admission event
        emit(AdmissionEvent(patient.id, admission_reason, ctx));

        patient
    }

    // Discharge a patient
    public fun discharge_patient(patient: &mut Patient, discharge_date: u64, ctx: &mut TxContext) {
        patient.discharge_date = Some(discharge_date);

        // Emit discharge event
        emit(DischargeEvent(patient.id, discharge_date, ctx));
    }

    // Generate a detailed bill for a patient
    public fun generate_bill(patient_id: UID, charges: Vec<u64>, ctx: &mut TxContext) -> Bill {
        let bill = Bill {
            id: object::new(ctx),
            patient_id,
            charges,
            payment_method: "".to_string(),
            payment_date: None,
        };

        // Emit billing event
        emit(BillingEvent(bill.id, patient_id, charges, ctx));

        bill
    }

    // Pay a bill
    public fun pay_bill(bill: &mut Bill, payment_method: String, payment_date: u64, ctx: &mut TxContext) {
        bill.payment_method = payment_method;
        bill.payment_date = Some(payment_date);

        // Emit payment event
        emit(PaymentEvent(bill.id, payment_method, payment_date, ctx));
    }

    // =================== Utility Functions ===================
    // Get hospital details
    public fun get_hospital(hospital: &Hospital) -> &Hospital {
        hospital
    }

    // Get all patients
    public fun get_patients(patients: &[Patient]) -> &[Patient] {
        patients
    }

    // Delete a hospital record
    public fun delete_hospital(hospital: Hospital, ctx: &mut TxContext) {
        if object::exists(hospital.id) {
            object::delete(hospital.id);
        } else {
            // Return error message if hospital doesn't exist
            return "Hospital not found".to_string();
        }
    }

    // Delete a patient record
    public fun delete_patient(patient: Patient, ctx: &mut TxContext) {
        if object::exists(patient.id) {
            object::delete(patient.id);
        } else {
            // Return error message if patient doesn't exist
            return "Patient not found".to_string();
        }
    }

    // Update patient information
    public fun update_patient(patient: &mut Patient, new_name: String, new_contact_info: String) {
        patient.name = new_name;
        patient.contact_info = new_contact_info;
    }

    // Update hospital information
    public fun update_hospital(hospital: &mut Hospital, new_address: String, new_contact_info: String) {
        hospital.address = new_address;
        hospital.contact_info = new_contact_info;
    }

    // Admission Event
    event AdmissionEvent(patient_id: UID, admission_reason: String, ctx: &TxContext) {}

    // Discharge Event
    event DischargeEvent(patient_id: UID, discharge_date: u64, ctx: &TxContext) {}

    // Billing Event
    event BillingEvent(bill_id: UID, patient_id: UID, charges: Vec<u64>, ctx: &TxContext) {}

    // Payment Event
    event PaymentEvent(bill_id: UID, payment_method: String, payment_date: u64, ctx: &TxContext) {}
}
