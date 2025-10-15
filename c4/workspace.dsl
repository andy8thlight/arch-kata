workspace "MobilityCorp" "Description" {

    !identifiers hierarchical

    model {
        u = person "User"
        s = person "Staff User"
        bo = person "Back office"

        ss = softwareSystem "Software System" {
            ua = container "User App"
            sa = container "Staff App"
            bs = container "Booking service"
            pua = container "Passenger usage analyser"
            tfl = container "TfL API"

            db = container "Vehicle store" {
                tags "Database"
            }
        }

        u -> ss.ua "Uses"
        ss.ua -> ss.bs "Create / update / delete booking"
        s -> ss.sa "Uses"

        bo -> ss.pua "Uses"
        ss.pua -> ss.tfl "Fetches passenger data"

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
