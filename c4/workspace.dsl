workspace "MobilityCorp" "Description" {

    !identifiers hierarchical

    model {
        u = person "User"
        s = person "Staff user"
        bo = person "Back office user"

        ss = softwareSystem "Software System" {
            ua = container "User App"
            sa = container "Staff App"
            boat = container "Back Office Admin Tool"
            bs = container "Booking service"
            pua = container "Passenger usage analyser"
            tfl = container "TfL API"

            pls = container "Popular location store" {
                tags "Database"
            }
            db = container "Vehicle store" {
                tags "Database"
            }
        }

        // User
        u -> ss.ua "Uses"
        ss.ua -> ss.bs "Create / update / delete booking"

        // Staff (field operative)
        s -> ss.sa "Uses"

        // Staff (back office)
        bo -> ss.boat "Uses"
        ss.boat -> ss.pua "Queries busy stations"
        ss.pua -> ss.tfl "Fetches passenger data"
        ss.pua -> ss.pls "Persists popular locations"

    }

    views {
        systemContext ss "Diagram1" {
            include *
            autolayout lr
        }

        container ss "Diagram2" {
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
