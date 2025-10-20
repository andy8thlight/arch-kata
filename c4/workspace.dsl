workspace "MobilityCorp" "Description" {

    !identifiers hierarchical

    model {
        renter = person "Vehicle renter"
        operative = person "Field operative"
        back_office_user = person "Back office user"

        payment_provider = softwareSystem "Payment Providers"

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

            booking_system = container "Booking system" {
                booking_service = component "Booking Service" 
                vehicle_store = component "Vehicle store" {
                    tags "Database"
                }
        
                booking_service -> vehicle_store "Queries for available vehicles"
        
                payment_service = component "Payment Service"
                booking_service -> payment_service "Makes payment/refunds for a booking"
                payment_service -> payment_provider "Authorises/declines payment requests and takes money from renters account"
            }

            pua = container "Passenger usage analyser"

            pls = container "Popular location store" {
                tags "Database"
            }
        }

        tfl_api = softwareSystem "Transport for London"
        google_maps = softwareSystem "Google Maps"


        mobility_corp -> google_maps "Gets routing information"
       
        // User
        renter -> mobility_corp "Finds and books vehicles with"
        renter -> mobility_corp.ua "Uses"
        mobility_corp.ua -> mobility_corp.booking_system "Create / update / delete booking"
        # mobility_corp.booking_service -> mobility_corp.vehicle_store "Queries for available vehicles"


        // Staff (field operative)
        operative -> mobility_corp.sa "Finds vehicles that need charging or moving"

        // Staff (back office)
        back_office_user -> mobility_corp "Manages the inventory of vehicles"
        back_office_user -> mobility_corp.boat "Uses"
        mobility_corp.boat -> mobility_corp.pua "Queries busy stations"
        mobility_corp.boat -> mobility_corp.booking_system "View / edit / cancel booking"
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

        component mobility_corp.booking_system "Diagram3" {
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
