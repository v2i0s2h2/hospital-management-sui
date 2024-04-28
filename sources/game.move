module health_monitor::management {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext, sender};
    use sui::transfer::{Self, transfer};
    use sui::clock::{Clock, timestamp_ms};
    use sui::balance::{Self, Balance};
    use sui::sui::{SUI};
    use sui::coin::{Self, Coin};
    use sui::table::{Self, Table};
    
    use std::string::{Self, String};

    const MALE: u8 = 0;
    const FAMALE: u8 = 1;

    const ERROR_INVALID_GENDER: u64 = 0;
    const ERROR_INVALID_ACCESS: u64 = 1;

    // Hospital Structure
    struct Hospital has key {
        id: UID,
        name: String,
        location: String,
        contact_info: String,
        hospital_type: String,
        bills: Table<address, Bill>
    }

    struct HospitalCap has key, store {
        id: UID,
        hospital: ID,
        balance: Balance<SUI>
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
    struct Bill has store {
        patient_id: ID,
        charges: u64,
        payment_date: u64,
    }

    // Create a new hospital
    public fun create_hospital(name: String, location: String, contact_info: String, hospital_type: String, ctx: &mut TxContext): (Hospital, HospitalCap) {
        let id_ = object::new(ctx);
        let inner_ = object::uid_to_inner(&id_);
        let hospital = Hospital {
            id: id_,
            name,
            location,
            contact_info,
            hospital_type,
            bills: table::new(ctx)
        };
        let cap = HospitalCap {
            id: object::new(ctx),
            hospital: inner_,
            balance: balance::zero()
        };
        (hospital, cap)
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

    // Generate a detailed bill for a patient
    public fun generate_bill(cap: &HospitalCap, hospital: &mut Hospital, patient_id: ID, charges: u64, date: u64, c: &Clock, ctx: &mut TxContext) {
        assert!(cap.hospital == object::id(hospital), ERROR_INVALID_ACCESS);
        let bill = Bill {
            patient_id,
            charges,
            payment_date: timestamp_ms(c) + date,
        };
        table::add(&mut hospital.bills, sender(ctx), bill);
    }

    // // Pay a bill
    // public fun pay_bill(bill: &mut Bill, coin: Coin<SUI>, c: &Clock) {
 
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
