module health_monitor::management {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer::{Self, transfer};
    use sui::clock::{Clock, timestamp_ms};
    
    use std::string::{Self, String};

    const MALE: u8 = 0;
    const FAMALE: u8 = 1;

    const ERROR_INVALID_GENDER: u64 = 0;

    // Hospital Structure
    struct Hospital has key {
        id: UID,
        name: String,
        location: String,
        contact_info: String,
        hospital_type: String, // Public or Private
    }

    // Patient Structure
    struct Patient has key {
        id: UID,
        hospital: ID,
        name: String,
        age: u64,
        gender: u8,
        contact_info: String,
        emergency_contact: String,
        admission_reason: String,
        discharge_date: u64,
    }

    // Billing Structure
    struct Bill has key {
        id: UID,
        patient_id: UID,
        charges: u64,
        payment_method: String,
        payment_date: u64,
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
    public fun create_hospital(name: String, location: String, contact_info: String, hospital_type: String, ctx: &mut TxContext): Hospital {
        Hospital {
            id: object::new(ctx),
            name,
            location,
            contact_info,
            hospital_type,
        }
    }

    // // Admit a patient
    public fun admit_patient(hospital: ID, name: String, age: u64, gender: u8, contact_info: String, emergency_contact: String, admission_reason: String, date: u64, c: &Clock, ctx: &mut TxContext): Patient {
        assert!(gender == 0 || gender == 1, ERROR_INVALID_GENDER);
        Patient {
            id: object::new(ctx),
            hospital,
            name,
            age,
            gender,
            contact_info,
            emergency_contact,
            admission_reason,
            discharge_date: timestamp_ms(c) + date,
        }
    }

    // // Discharge a patient
    // public fun discharge_patient(patient: &mut Patient, discharge_date: u64) {
    //     patient.discharge_date = Some(discharge_date);
    // }

    // // Generate a detailed bill for a patient
    // public fun generate_bill(patient_id: UID, charges: Vec<u64>, ctx: &mut TxContext): Bill {
    //     Bill {
    //         id: object::new(ctx),
    //         patient_id,
    //         charges,
    //         payment_method: "".to_string(),
    //         payment_date: None,
    //     }
    // }

    // // Pay a bill
    // public fun pay_bill(bill: &mut Bill, payment_method: String, payment_date: u64) {
    //     bill.payment_method = payment_method;
    //     bill.payment_date = Some(payment_date);
    // }

    // // =================== Utility Functions ===================
    // // Get hospital details
    // public fun get_hospital(hospital: &Hospital): &Hospital {
    //     hospital
    // }

    // // Get all patients
    // public fun get_patients(patients: &[Patient]): &[Patient] {
    //     patients
    // }

    // // Delete a hospital record
    // public fun delete_hospital(hospital: Hospital) {
    //     object::delete(hospital.id);
    // }

    // // Delete a patient record
    // public fun delete_patient(patient: Patient) {
    //     object::delete(patient.id);
    // }

    // // Update patient information
    // public fun update_patient(patient: &mut Patient, new_name: String, new_contact_info: String) {
    //     patient.name = new_name;
    //     patient.contact_info = new_contact_info;
    // }

    // // Update hospital information
    // public fun update_hospital(hospital: &mut Hospital, new_address: String, new_contact_info: String) {
    //     hospital.address = new_address;
    //     hospital.contact_info = new_contact_info;
    // }
}
