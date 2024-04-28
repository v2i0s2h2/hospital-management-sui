// #[test_only]
// module hospital::test_management {
//     use sui::test_scenario::{Self as ts, Scenario, next_tx};
//     use sui::transfer;
//     use sui::test_utils::{assert_eq};
//     use sui::coin::{mint_for_testing, Self};
//     use sui::object;
//     use sui::tx_context::{TxContext};
//     use sui::option::{Self, Option};
//     use std::vector::{Self};
//     use hospital::management::{Self, Hospital, Patient, Bill, AdminCap};

//     const TEST_ADDRESS1: address = @0xB;
//     const TEST_ADDRESS2: address = @0xC;

//     // Initialize the test scenario with admin capability
//     #[test]
//     public fun test_init_admin_cap() {
//         let mut scenario = ts::begin();
//         next_tx(&mut scenario, TEST_ADDRESS1);
        
//         hospital::management::init(ts::ctx(&mut scenario));
        
//         let admin_cap = ts::take_from_sender<AdminCap>(&mut scenario);
        
//         assert_eq(object::type_tag(&admin_cap), "hospital::management::AdminCap");
        
//         ts::return_to_sender(&mut scenario, admin_cap);
        
//         ts::end(&mut scenario);
//     }

//     // Test hospital creation
//     #[test]
//     public fun test_create_hospital() {
//         let mut scenario = ts::begin();
//         next_tx(&mut scenario, TEST_ADDRESS1);

//         let hospital = hospital::management::create_hospital(
//             "General Hospital".to_string(),
//             "123 Hospital Street".to_string(),
//             "123-456-7890".to_string(),
//             "Public".to_string(),
//             ts::ctx(&mut scenario)
//         );

//         assert_eq(hospital.name, "General Hospital".to_string());
//         assert_eq(hospital.address, "123 Hospital Street".to_string());
//         assert_eq(hospital.contact_info, "123-456-7890".to_string());
//         assert_eq(hospital.hospital_type, "Public".to_string());

//         transfer::public_transfer(hospital, TEST_ADDRESS1);

//         ts::end(&mut scenario);
//     }

//     // Test admitting a patient
//     #[test]
//     public fun test_admit_patient() {
//         let mut scenario = ts::begin();
//         next_tx(&mut scenario, TEST_ADDRESS1);

//         let patient = hospital::management::admit_patient(
//             "John Doe".to_string(),
//             30,
//             "Male".to_string(),
//             "123-456-7891".to_string(),
//             "Jane Doe".to_string(),
//             "Routine Checkup".to_string(),
//             ts::ctx(&mut scenario)
//         );

//         assert_eq(patient.name, "John Doe".to_string());
//         assert_eq(patient.age, 30);
//         assert_eq(patient.gender, "Male".to_string());
//         assert_eq(patient.contact_info, "123-456-7891".to_string());
//         assert_eq(patient.emergency_contact, "Jane Doe".to_string());

//         transfer::public_transfer(patient, TEST_ADDRESS1);

//         ts::end(&mut scenario);
//     }

//     // Test discharging a patient
//     #[test]
//     public fun test_discharge_patient() {
//         let mut scenario = ts::begin();
//         next_tx(&mut scenario, TEST_ADDRESS1);

//         let mut patient = hospital::management::admit_patient(
//             "John Doe".to_string(),
//             30,
//             "Male".to_string(),
//             "123-456-7891".to_string(),
//             "Jane Doe".to_string(),
//             "Routine Checkup".to_string(),
//             ts::ctx(&mut scenario)
//         );

//         hospital::management::discharge_patient(&mut patient, 1682000000); // timestamp for discharge

//         assert_eq(patient.discharge_date, Some(1682000000));

//         transfer::public_transfer(patient, TEST_ADDRESS1);

//         ts::end(&mut scenario);
//     }

//     // Test generating a bill
//     #[test]
//     public fun test_generate_bill() {
//         let mut scenario = ts::begin();
//         next_tx(&mut scenario, TEST_ADDRESS1);

//         let patient = hospital::management::admit_patient(
//             "John Doe".to_string(),
//             30,
//             "Male".to_string(),
//             "123-456-7891".to_string(),
//             "Jane Doe".to_string(),
//             "Routine Checkup".to_string(),
//             ts::ctx(&mut scenario)
//         );

//         let charges = vector::empty<u64>();
//         vector::push_back(&charges, 500);
//         vector::push_back(&charges, 200);

//         let bill = hospital::management::generate_bill(
//             patient.id,
//             charges,
//             ts::ctx(&mut scenario)
//         );

//         assert_eq(bill.patient_id, patient.id);
//         assert_eq(bill.charges.len(), 2);
//         assert_eq(bill.charges[0], 500);
//         assert_eq(bill.charges[1], 200);

//         transfer::public_transfer(bill, TEST_ADDRESS1);

//         ts::end(&mut scenario);
//     }

//     // Test bill payment
//     #[test]
//     public fun test_pay_bill() {
//         let mut scenario = ts::begin();
//         next_tx(&mut scenario, TEST_ADDRESS1);

//         let patient = hospital::management::admit_patient(
//             "John Doe".to_string(),
//             30,
//             "Male".to_string(),
//             "123-456-7891".to_string(),
//             "Jane Doe".to_string(),
//             "Routine Checkup".to_string(),
//             ts::ctx(&mut scenario)
//         );

//         let charges = vector::empty<u64>();
//         vector::push_back(&charges, 500);
//         vector::push_back(&charges, 200);

//         let mut bill = hospital::management::generate_bill(
//             patient.id,
//             charges,
//             ts::ctx(&mut scenario)
//         );

//         hospital::management::pay_bill(&mut bill, "Credit Card".to_string(), 1682000000); // timestamp for payment

//         assert_eq(bill.payment_method, "Credit Card".to_string());
//         assert_eq(bill.payment_date, Some(1682000000));

//         transfer::public_transfer(bill, TEST_ADDRESS1);

//         ts::end(&mut scenario);
//     }
// }
