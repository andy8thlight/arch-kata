workspace "MobilityCorp" "Description" {

    !identifiers hierarchical

    model {
        renter = person "Vehicle renter"
        operative = person "Field operative"
        back_office_user = person "Back office user"

        payment_provider = softwareSystem "Payment Providers"
        tfl_api = softwareSystem "Transport for London"
        google_maps = softwareSystem "Google Maps"

        mobility_corp = softwareSystem "Mobility Corp" {

            ua = container "User App" {
                tags "Mobile App"
            }

            ua -> google_maps "Shows map and gets routing information"

            sa = container "Operator App" {
                tags "Mobile App"
            }

            sa -> google_maps "Shows map and gets routing information"

            boat = container "Back Office Admin Tool" {
                tags "Web App"
            }

            boat -> google_maps "Shows fleet of vehicles on a map"

            booking_system = container "Booking system" {
                returns_service = component "Returns service"
                booking_service = component "Booking Service" 
                api_gateway = component "API Gateway" "Provides facade to other services and provides token based access control"

                api_gateway -> booking_service "Create bookings"
                api_gateway -> returns_service "Return vehicle / upload photos"

                vehicle_store = component "Vehicle store" {
                    tags "Database"
                }
                booking_store = component "Booking database" {
                    tags "Database"
                }
                photo_store = component "Photo store" "File system to keep photos of returned vehicles" {
                    tags "Database"
                }
        
                booking_service -> vehicle_store "Queries for available vehicles"
                booking_service -> booking_store "Stores/retrieves bookings"

                returns_service -> vehicle_store "Marks booking as completed"
                returns_service -> photo_store "Stores photo of completed booking"
        
                payment_service = component "Payment Service"
                booking_service -> payment_service "Makes payment/refunds for a booking"
                payment_service -> payment_provider "Authorises/declines payment requests and takes money from renters account"
            }

            ua -> booking_system "Create / update / delete booking"
            ua -> booking_system.api_gateway "Create / update / delete booking / Return vehicle / upload photo""

            admin_system = container "Admin system" {
                pua = component "Passenger usage analyser" "ML component that analyses past data to predict future usage patterns"
                pls = component "Popular location store" {
                    tags "Database"
                }
                pua -> tfl_api "Gets historic usage data of stations"
                pua -> pls "Persists popular locations"
            }


            boat -> booking_system "View / edit / cancel booking"
            boat -> admin_system.pua "Queries busy stations"
        }



        mobility_corp -> google_maps "Gets routing information"
       
        // User
        renter -> mobility_corp "Finds and books vehicles with"
        renter -> mobility_corp.ua "Uses"

        // Staff (field operative)
        operative -> mobility_corp.sa "Finds vehicles that need charging or moving"

        // Staff (back office)
        back_office_user -> mobility_corp "Manages the inventory of vehicles"
        back_office_user -> mobility_corp.boat "Uses"

    }

    views {
        systemContext mobility_corp "Context" {
            include *
            autolayout lr
        }

        container mobility_corp "Container" {
            include *
            autolayout lr
        }

        component mobility_corp.booking_system "BookingSystem" {
            include *
            autolayout lr
        }

        component mobility_corp.admin_system "AdminSystem" {
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
            element "Component" {
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
