#[test_only]
module health_monitor::test_management {
    use sui::test_scenario::{Self as ts, Scenario, next_tx, ctx};
    use sui::transfer;
    use sui::test_utils::{assert_eq};
    use sui::coin::{mint_for_testing, Self};
    use sui::object;
    use sui::tx_context::{TxContext};
    use std::string::{Self, String};

    use health_monitor::management::{Self, Hospital, Patient, Bill};
    use health_monitor::helpers::{init_test_helper};

    const ADMIN: address = @0xA;
    const TEST_ADDRESS1: address = @0xB;
    const TEST_ADDRESS2: address = @0xC;

    // Initialize the test scenario with admin capability
    #[test]
    public fun test() {

        let scenario_test = init_test_helper();
        let scenario = &mut scenario_test;

        next_tx(scenario, ADMIN);
        {

            let name = string::utf8(b"asd");
            let location = string::utf8(b"asd");
            let contact = string::utf8(b"asd");
            let type = string::utf8(b"asd");

            let (hospital, cap) =  management::create_hospital(name, location, contact, type, ctx(scenario));

            transfer::public_share_object(hospital);
            transfer::public_transfer(cap, ADMIN);
        };
        ts::end(scenario_test);      
    }


}
