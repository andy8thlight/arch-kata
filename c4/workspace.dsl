workspace "MobilityCorp" "Description" {

    !identifiers hierarchical

    model {
        renter = person "Vehicle renter"
        operative = person "Field operative"
        back_office_user = person "Back office user"

        mobility_corp = softwareSystem "Mobility Corp" {
            ua = container "User App" {
                tags "Mobile App"
            }
            sa = container "Operator App" {
                tags "Mobile App"
            }
            boat = container "Back Office Admin Tool" {
                tags "Web App"
            }
            booking_service = container "Booking service"
            payment_service = container "Payment service"
            pua = container "Passenger usage analyser"

            pls = container "Popular location store" {
                tags "Database"
            }
            vehicle_store = container "Vehicle store" {
                tags "Database"
            }
        }

        tfl_api = softwareSystem "Transport for London"
        payment_provider = softwareSystem "Payment Providers"
        google_maps = softwareSystem "Google Maps"


        mobility_corp -> google_maps "Gets routing information"
       
        // User
        renter -> mobility_corp "Finds and books vehicles with"
        renter -> mobility_corp.ua "Uses"
        mobility_corp.ua -> mobility_corp.booking_service "Create / update / delete booking"
        mobility_corp.booking_service -> mobility_corp.vehicle_store "Queries for available vehicles"
        mobility_corp.booking_service -> mobility_corp.payment_service "Makes payment/refunds for a booking"
        mobility_corp.payment_service -> payment_provider "Authorises/declines payment requests and takes money from renters account"

        // Staff (field operative)
        operative -> mobility_corp.sa "Finds vehicles that need charging or moving"

        // Staff (back office)
        back_office_user -> mobility_corp "Manages the inventory of vehicles"
        back_office_user -> mobility_corp.boat "Uses"
        mobility_corp.boat -> mobility_corp.pua "Queries busy stations"
        mobility_corp.boat -> mobility_corp.booking_service "View / edit / cancel booking"
        mobility_corp.pua -> tfl_api "Gets historic usage data of stations"
        mobility_corp.pua -> mobility_corp.pls "Persists popular locations"

    }

    views {
        systemContext mobility_corp "Diagram1" {
            include *
            autolayout lr
        }

        container mobility_corp "Diagram2" {
            include *
            autolayout lr
        }

        styles {
            element "Element" {
                color #ffffff
            }
            element "Person" {
                background #048c04
                shape person
            }
            element "Mobile App" {
                shape MobileDevicePortrait
                background #55aa55
                color #ffffff
            }
            element "Web App" {
                shape WebBrowser
                background #55aa55
                color #ffffff
            }
            element "Software System" {
                background #047804
            }
            element "Container" {
                background #55aa55
            }
            element "Database" {
                shape cylinder
            }
        }
    }

    configuration {
        scope softwaresystem
    }

}
