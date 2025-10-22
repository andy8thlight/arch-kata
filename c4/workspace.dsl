workspace "MobilityCorp Architecture" "AI-enabled mobility platform overview" {

    !identifiers hierarchical

    model {
        // === People ===
        user = person "End User" "Rents vehicles, checks availability, and receives personalised recommendations."
        fieldOps = person "Field Operative" "Uses the Field-Ops App for battery swaps, collections, and hub maintenance."
        opsMgr = person "Operations Manager" "Oversees daily operations, fleet balancing, and KPI performance."
        finance = person "Finance & Compliance Officer" "Monitors costs, billing, and GDPR/AI compliance obligations."

        // === External Systems ===
        transportAPI = softwareSystem "Regional Transport Providers" {
            description "RATP, BVG, ATAC, GTFS-RT feeds for live status data."
            tags "External"
        }
        weatherAPI = softwareSystem "Weather Provider" {
            description "OpenWeatherMap / MeteoGroup for weather and forecast data."
            tags "External"
        }
        paymentGateway = softwareSystem "Payment Gateway" {
            description "Adyen / Stripe integration for payment transactions."
            tags "External"
        }
        googleMaps = softwareSystem "Google Maps" {
            description "Mapping and routing services for mobility applications."
            tags "External"
        }
        modelHost = softwareSystem "Model Hosting Platform" {
            description "AWS SageMaker EU region hosting ML models (ADR-015)."
            tags "External"
        }
        eventFeeds = softwareSystem "External Event Sources" {
            description "Public events, strikes, holidays, and disruption alerts."
            tags "External"
        }

        // === MobilityCorp Platform ===
        mobilityCorp = softwareSystem "MobilityCorp Platform" {
            description "Smart mobility ecosystem enabling bookings, optimisation, and compliant AI usage."

            // Customer and field applications
            customerApp = container "Customer App" "React Native / Web" {
                description "End-user application for reservations, payments, and concierge experiences."
                tags "Mobile App"
            }
            fieldOpsApp = container "Field-Ops App" "Flutter / Kotlin" {
                description "Offline-capable app for field teams to execute routing tasks and returns (ADR-008)."
                tags "Mobile App"
            }
            backOfficeTool = container "Back Office Admin Tool" "React / Web" {
                description "Internal tool for booking overrides, fleet monitoring, and KPI dashboards."
                tags "Web App"
                monitoringDashboard = component "Monitoring Dashboard" "Web Module" {
                    description "Displays live telemetry, cost, and SLA KPIs from the observability stack."
                }
            }

            // Booking lifecycle services
            bookingSystem = container "Booking System" "Java / Spring" {
                description "Core booking lifecycle for rentals, extensions, and returns."
                apiGateway = component "API Gateway" "Gateway" {
                    description "Provides authenticated façade for booking API consumers."
                }
                bookingService = component "Booking Service" "Service" {
                    description "Creates, amends, and queries bookings; coordinates availability."
                }
                returnsService = component "Returns Service" "Service" {
                    description "Handles vehicle returns, condition capture, and photo uploads."
                }
                paymentService = component "Payment Service" "Service" {
                    description "Initiates payment and refund operations via the Billing Service and Gateway."
                }
                vehicleStore = component "Vehicle Store" "Database" {
                    description "Stores vehicle inventory, status, and allocation state."
                    tags "Database"
                }
                bookingStore = component "Booking Store" "Database" {
                    description "Persists booking records, history, and entitlements."
                    tags "Database"
                }
                photoStore = component "Photo Store" "Object Store" {
                    description "Stores return inspection photos and evidence."
                    tags "Database"
                }
            }

            // Billing & pricing service
            billingService = container "Billing Service" "Node.js / FastAPI" {
                description "Implements ADR-002: pricing, invoice generation, adjustments, and reconciliation."
                pricingEngine = component "Pricing Engine" "Service" {
                    description "Calculates dynamic/regional pricing using policy and demand signals."
                }
                invoiceManager = component "Invoice Manager" "Service" {
                    description "Issues invoices, applies adjustments, and tracks settlement status."
                }
                taxCalculator = component "Tax Calculator" "Module" {
                    description "Applies VAT and regional taxes to invoices."
                }
                billingStore = component "Billing Store" "Database" {
                    description "Stores invoice, transaction, and adjustment records."
                    tags "Database"
                }
            }

            // Operations analytics
            operationsAnalytics = container "Operations Analytics" "Python / Analytics" {
                description "Back-office analytics for station planning and demand optimisation."
                stationPlanner = component "Station Planner" "Analytics Job" {
                    description "Combines forecasts and usage to optimise hub staffing and capacity."
                }
                planningDataStore = component "Planning Data Store" "Database" {
                    description "Historical usage, forecast, and planning scenarios."
                    tags "Database"
                }
            }

            // Observability stack
            observabilityStack = container "Observability & Telemetry" "Grafana / OTel" {
                description "Central telemetry, cost dashboards, and SLO tracking (ADR-013)."
            }

            // AI platform (encapsulated detail)
            aiPlatform = container "AI Platform" "Python / Databricks / FastAPI" {
                description "AI orchestration, optimisation, forecasting, concierge, and data foundation."

                group "Interchange & Orchestration" {
                    taskApiGateway = component "Task API Gateway" "FastAPI Router" {
                        description "Receives AI task requests; validates schema, identity, and locale."
                    }
                    policyGate = component "Policy & Consent Gate" "Middleware" {
                        description "Enforces consent, redaction, and entitlement rules."
                    }
                    featureConnector = component "Feature Connector" "Service Module" {
                        description "Retrieves contextual features for AI tasks."
                    }
                    providerRouter = component "Provider Router" "Core Logic" {
                        description "Selects internal service or external model endpoint based on capability/latency/cost."
                    }
                    responseLocaliser = component "Response Localiser" "Utility" {
                        description "Adapts AI responses to locale, language, and unit preferences."
                    }
                    interchangeObsAgent = component "Interchange Observability Agent" "OTel SDK" {
                        description "Publishes traces and metrics for AI tasks."
                    }
                }

                group "Routing Optimisation" {
                    routingApi = component "Routing API" "FastAPI Router" {
                        description "Entry point for routing optimisation requests."
                    }
                    routingDataAdapter = component "Routing Data Adapter" "Module" {
                        description "Fetches hub, vehicle, and task data from the AI data pipeline."
                    }
                    routingConstraintBuilder = component "Constraint Builder" "Core Logic" {
                        description "Translates operational rules into solver constraints."
                    }
                    routingSolver = component "Solver Engine" "OR-Tools / Python" {
                        description "Runs VRP-TW optimisation with regional weights and weather modifiers."
                    }
                    routingPostProcessor = component "Result Post-Processor" "Utility" {
                        description "Calculates ETA, energy use, and risk factors per route."
                    }
                    routingPublisher = component "Result Publisher" "Module" {
                        description "Publishes optimised routes to Kafka and field apps."
                    }
                    routingObsAgent = component "Routing Observability Agent" "OTel SDK" {
                        description "Emits solver latency and success metrics."
                    }
                }

                group "Demand Forecasting" {
                    trainingScheduler = component "Training Scheduler" "Databricks Jobs" {
                        description "Triggers regional demand model training."
                    }
                    featureLoader = component "Feature Loader" "ETL Module" {
                        description "Loads feature sets from the feature store and data pipeline."
                    }
                    modelTrainer = component "Model Trainer" "ML Component" {
                        description "Trains regional demand models using contextual features."
                    }
                    modelRegistryClient = component "Model Registry Client" "Utility" {
                        description "Registers trained models and metadata in model hosting."
                    }
                    inferenceService = component "Inference Service" "Service" {
                        description "Serves demand forecasts for downstream services."
                    }
                    forecastPublisher = component "Forecast Publisher" "Module" {
                        description "Distributes forecasts to routing and concierge services."
                    }
                    predictionObsAgent = component "Prediction Observability Agent" "OTel SDK" {
                        description "Publishes training and inference metrics."
                    }
                }

                group "Concierge Personalisation" {
                    conciergeApi = component "Concierge API" "FastAPI Router" {
                        description "Handles personalised recommendation requests."
                    }
                    contextAssembler = component "Context Assembler" "Service Module" {
                        description "Combines demand, weather, transport, and profile data."
                    }
                    recommenderEngine = component "Recommender Engine" "ML Component" {
                        description "Scores hubs/routes for each user."
                    }
                    conciergePolicyEvaluator = component "Policy Evaluator" "Utility" {
                        description "Applies pricing and entitlement policies."
                    }
                    tierValidator = component "Tier Validator" "Middleware" {
                        description "Validates subscription tiers and entitlements."
                    }
                    conciergeExplainer = component "Explainability Exporter" "Module" {
                        description "Captures rationale and feature importances for concierge decisions."
                    }
                    conciergeObsAgent = component "Concierge Observability Agent" "OTel SDK" {
                        description "Emits latency and success-rate telemetry."
                    }
                }

                group "Data Pipeline" {
                    transportAdapter = component "Transport Adapter" "Connectors" {
                        description "Normalises regional transport APIs to standard events."
                    }
                    weatherCollector = component "Weather Collector" "Ingestion Job" {
                        description "Pulls weather and forecast data from providers."
                    }
                    telemetryIngest = component "Telemetry Ingest" "Gateway" {
                        description "Receives device and application telemetry events."
                    }
                    kafkaIngress = component "Kafka Ingress" "Kafka Topics" {
                        description "Entry topics for transport.status, weather.conditions, telemetry.events."
                    }
                    schemaRegistry = component "Schema Registry" "Registry" {
                        description "Manages topic contracts and compatibility."
                    }
                    streamProcessor = component "Structured Streaming Processor" "Spark Streaming" {
                        description "Cleans, joins, and enriches events into curated tables."
                    }
                    batchProcessor = component "Batch Processor" "Spark / Delta" {
                        description "Runs backfills, compaction, and heavy transforms."
                    }
                    bronzeZone = component "Bronze Zone" "Delta Lake" {
                        description "Raw append-only event storage."
                        tags "Database"
                    }
                    silverZone = component "Silver Zone" "Delta Lake" {
                        description "Cleaned and conformed datasets."
                        tags "Database"
                    }
                    goldZone = component "Gold Zone" "Delta Lake" {
                        description "Analytics-ready facts and aggregates."
                        tags "Database"
                    }
                    exportApi = component "Data Export API" "Service" {
                        description "Controlled read access for downstream services."
                    }
                    dqMonitor = component "Data Quality Monitor" "Service" {
                        description "Tracks freshness, null rates, and schema drift."
                    }
                    metadataCatalog = component "Metadata Catalog" "Service" {
                        description "Registers datasets, lineage, and ownership."
                    }
                    dataObsAgent = component "Data Observability Agent" "OTel SDK" {
                        description "Publishes pipeline metrics and alerts."
                    }
                }

                group "Feature Store" {
                    featureRegistry = component "Feature Registry" "Service" {
                        description "Registers feature schemas, versions, and owners."
                    }
                    transformationJob = component "Transformation Job" "Spark / Delta" {
                        description "Writes batch and streaming feature sets."
                    }
                    onlineStore = component "Online Feature Store" "Redis / Delta" {
                        description "Low-latency feature access for inference."
                        tags "Database"
                    }
                    offlineStore = component "Offline Feature Store" "Delta Lake" {
                        description "Historical feature sets for model training."
                        tags "Database"
                    }
                    qualityMonitor = component "Feature Quality Monitor" "Job" {
                        description "Validates feature completeness and drift."
                    }
                    lineageTracker = component "Lineage Tracker" "Service" {
                        description "Captures feature lineage and provenance."
                    }
                    featureObsAgent = component "Feature Observability Agent" "OTel SDK" {
                        description "Publishes feature pipeline metrics."
                    }
                }
            }

            // Governance platform covering audit, explainability, cost, policy
            governancePlatform = container "Governance Platform" "Python / Delta / LedgerDB" {
                description "Centralised AI governance, explainability, policy, subscription, and cost control."

                group "Explainability & Audit" {
                    governanceApiGateway = component "Governance API Gateway" "FastAPI Router" {
                        description "Receives explainability and audit queries from users, regulators, and tools."
                    }
                    accessController = component "Access Controller" "Middleware" {
                        description "Validates requester identity, role, and legal basis for data access."
                    }
                    consentRegistry = component "Consent Registry" "Database" {
                        description "Maintains user consent and revocation records (GDPR Art.6 & 22)."
                        tags "Database"
                    }
                    ledgerWriter = component "Ledger Writer" "Service Module" {
                        description "Appends immutable audit entries and enforces hash-chain integrity."
                    }
                    ledgerStore = component "Immutable Ledger Store" "Delta / LedgerDB" {
                        description "Append-only store of audit records with cryptographic hashes."
                        tags "Database"
                    }
                    hashChainValidator = component "Hash-Chain Validator" "Job" {
                        description "Periodically verifies audit chain integrity and signatures."
                    }
                    explainabilityStore = component "Explainability Store" "Delta Table / DB" {
                        description "Stores model input/output summaries, SHAP/feature importances, and rationale data."
                        tags "Database"
                    }
                    explainabilityApi = component "Explainability API" "REST / GraphQL" {
                        description "Serves model-specific rationales to authorised users (ADR-017)."
                    }
                    auditDispatcher = component "Audit Dispatcher" "Kafka Producer" {
                        description "Publishes audit confirmations or alerts to dashboards."
                    }
                }

                group "Cost, Policy & Subscription" {
                    usageNormalizer = component "Usage Normalizer" "Processor" {
                        description "Normalises provider usage (tokens/runtime/model) to a unified schema."
                    }
                    budgetRegistry = component "Budget Registry" "DB / Table" {
                        description "Stores budgets and quotas per team/model/region/environment."
                        tags "Database"
                    }
                    budgetPolicyEvaluator = component "Budget Policy Evaluator" "Rules Engine" {
                        description "Evaluates requests against budgets, throttles, and grace policies."
                    }
                    realtimeEnforcer = component "Realtime Enforcer" "Gateway" {
                        description "Returns allow/throttle/deny decisions with guidance to callers."
                    }
                    eventPublisher = component "Event Publisher" "Kafka Producer" {
                        description "Emits cost and enforcement events to telemetry."
                    }
                    billingReconciler = component "Billing Reconciler" "Job" {
                        description "Nightly reconciliation with provider/billing data; corrects drift."
                    }
                    reportGenerator = component "Report Generator" "Job" {
                        description "Aggregates spend trends and publishes dashboards for Finance."
                    }
                    policyDataService = component "Policy-as-Data Service" "Service" {
                        description "Stores pricing, fines, and entitlement policies (ADR-019)."
                    }
                    subscriptionDirectory = component "Subscription Directory" "Service" {
                        description "Maintains premium tiers and entitlements (ADR-012)."
                    }
                    costAuditLogger = component "Cost Audit Logger" "Utility" {
                        description "Writes enforcement outcomes to the immutable ledger."
                    }
                }

                governanceObsAgent = component "Governance Observability Agent" "OTel SDK" {
                    description "Emits validation, latency, and access-audit metrics."
                }
                costObsAgent = component "Cost Observability Agent" "OTel SDK" {
                    description "Emits governance latency, hit rate, and spend metrics."
                }
            }
        }

        // === Relationships ===
        // People to systems
        user -> mobilityCorp.customerApp "Books and manages rentals"
        fieldOps -> mobilityCorp.fieldOpsApp "Executes field tasks"
        opsMgr -> mobilityCorp.backOfficeTool "Manages operations"
        opsMgr -> mobilityCorp.observabilityStack "Monitors KPIs"
        finance -> mobilityCorp.governancePlatform.ledgerStore "Reviews audit records"
        finance -> mobilityCorp.governancePlatform.reportGenerator "Receives spend reports"

        // Booking and admin flows
        mobilityCorp.customerApp -> mobilityCorp.bookingSystem.apiGateway "Create/update/cancel booking"
        mobilityCorp.customerApp -> mobilityCorp.bookingSystem.bookingService "View booking status"
        mobilityCorp.fieldOpsApp -> mobilityCorp.bookingSystem.returnsService "Complete returns & upload photos"
        mobilityCorp.backOfficeTool -> mobilityCorp.bookingSystem.apiGateway "Manage bookings & exceptions"
        mobilityCorp.backOfficeTool -> mobilityCorp.bookingSystem.bookingService "Operate booking lifecycle"
        mobilityCorp.backOfficeTool -> mobilityCorp.operationsAnalytics.stationPlanner "Query station demand"

        // Booking internals
        mobilityCorp.bookingSystem.apiGateway -> mobilityCorp.bookingSystem.bookingService "Route booking requests"
        mobilityCorp.bookingSystem.apiGateway -> mobilityCorp.bookingSystem.returnsService "Route return requests"
        mobilityCorp.bookingSystem.bookingService -> mobilityCorp.bookingSystem.vehicleStore "Update availability"
        mobilityCorp.bookingSystem.bookingService -> mobilityCorp.bookingSystem.bookingStore "Persist booking"
        mobilityCorp.bookingSystem.returnsService -> mobilityCorp.bookingSystem.vehicleStore "Mark vehicle returned"
        mobilityCorp.bookingSystem.returnsService -> mobilityCorp.bookingSystem.photoStore "Store inspection photos"
        mobilityCorp.bookingSystem.bookingService -> mobilityCorp.billingService.pricingEngine "Request pricing"
        mobilityCorp.billingService.pricingEngine -> mobilityCorp.billingService.billingStore "Persist adjustments"
        mobilityCorp.billingService.invoiceManager -> paymentGateway "Charge / refund"
        mobilityCorp.billingService.invoiceManager -> mobilityCorp.billingService.billingStore "Store invoice"

        // Mapping integrations
        mobilityCorp.customerApp -> googleMaps "Display maps and routing"
        mobilityCorp.fieldOpsApp -> googleMaps "Show routes and fleet overlays"
        mobilityCorp.backOfficeTool -> googleMaps "Visualise fleet status"

        // AI platform interactions
        mobilityCorp.bookingSystem.bookingService -> mobilityCorp.aiPlatform.taskApiGateway "Request availability forecasts"
        mobilityCorp.bookingSystem.apiGateway -> mobilityCorp.aiPlatform.taskApiGateway "Forward AI tasks"
        mobilityCorp.operationsAnalytics.stationPlanner -> mobilityCorp.aiPlatform.taskApiGateway "Request demand forecasts"
        mobilityCorp.fieldOpsApp -> mobilityCorp.aiPlatform.taskApiGateway "Request routing assistance"
        mobilityCorp.customerApp -> mobilityCorp.aiPlatform.conciergeApi "Request concierge recommendations"
        mobilityCorp.aiPlatform.responseLocaliser -> mobilityCorp.customerApp "Deliver personalised guidance"

        // AI data + governance exchange
        mobilityCorp.aiPlatform.taskApiGateway -> mobilityCorp.governancePlatform.usageNormalizer "Emit usage telemetry"
        mobilityCorp.aiPlatform.policyGate -> mobilityCorp.governancePlatform.policyDataService "Fetch policy data"
        mobilityCorp.aiPlatform.policyGate -> mobilityCorp.governancePlatform.subscriptionDirectory "Validate entitlement"
        mobilityCorp.governancePlatform.realtimeEnforcer -> mobilityCorp.aiPlatform.taskApiGateway "Return budget decision"
        mobilityCorp.aiPlatform.conciergeExplainer -> mobilityCorp.governancePlatform.explainabilityStore "Store recommendation rationale"
        mobilityCorp.aiPlatform.routingPublisher -> mobilityCorp.governancePlatform.ledgerWriter "Log routing decision"
        mobilityCorp.aiPlatform.forecastPublisher -> mobilityCorp.governancePlatform.ledgerWriter "Log forecast metadata"
        mobilityCorp.aiPlatform.taskApiGateway -> mobilityCorp.governancePlatform.auditDispatcher "Notify governance event"
        mobilityCorp.aiPlatform.exportApi -> mobilityCorp.fieldOpsApp "Push optimised tasks"
        mobilityCorp.aiPlatform.exportApi -> mobilityCorp.bookingSystem.returnsService "Deliver operational tasks"

        // Data ingestion & sourcing
        transportAPI -> mobilityCorp.aiPlatform.transportAdapter "Stream GTFS telemetry"
        mobilityCorp.aiPlatform.transportAdapter -> transportAPI "Pull transport feeds"
        weatherAPI -> mobilityCorp.aiPlatform.weatherCollector "Push weather updates"
        mobilityCorp.aiPlatform.weatherCollector -> weatherAPI "Fetch weather data"
        eventFeeds -> mobilityCorp.aiPlatform.transportAdapter "Send disruption events"
        mobilityCorp.fieldOpsApp -> mobilityCorp.aiPlatform.telemetryIngest "Send field telemetry"
        mobilityCorp.customerApp -> mobilityCorp.aiPlatform.telemetryIngest "Send app telemetry"
        mobilityCorp.bookingSystem.bookingService -> mobilityCorp.aiPlatform.telemetryIngest "Emit booking events"

        // Governance integrations with externals
        mobilityCorp.governancePlatform.billingReconciler -> modelHost "Pull provider usage summaries"
        mobilityCorp.governancePlatform.subscriptionDirectory -> paymentGateway "Reconcile subscription billing"

        // Observability and traceability
        mobilityCorp.aiPlatform.interchangeObsAgent -> mobilityCorp.observabilityStack "Publish interchange telemetry"
        mobilityCorp.aiPlatform.routingObsAgent -> mobilityCorp.observabilityStack "Publish routing metrics"
        mobilityCorp.aiPlatform.predictionObsAgent -> mobilityCorp.observabilityStack "Publish training/inference metrics"
        mobilityCorp.aiPlatform.conciergeObsAgent -> mobilityCorp.observabilityStack "Publish concierge metrics"
        mobilityCorp.aiPlatform.dataObsAgent -> mobilityCorp.observabilityStack "Publish pipeline metrics"
        mobilityCorp.aiPlatform.featureObsAgent -> mobilityCorp.observabilityStack "Publish feature metrics"
        mobilityCorp.governancePlatform.governanceObsAgent -> mobilityCorp.observabilityStack "Publish audit telemetry"
        mobilityCorp.governancePlatform.costObsAgent -> mobilityCorp.observabilityStack "Publish cost governance metrics"
        mobilityCorp.backOfficeTool.monitoringDashboard -> mobilityCorp.observabilityStack "Query dashboards & traces"
    }

    views {
        systemContext mobilityCorp "SystemContext" {
            include *
            autolayout lr 500 400 200
            title "MobilityCorp – System Context Diagram (Level 1)"
        }

        container mobilityCorp "Container" {
            include *
            autolayout lr 600 450 250
            title "MobilityCorp – Container Diagram (Level 2)"
        }

        component mobilityCorp.bookingSystem "BookingSystem" {
            include *
            include paymentGateway
            include mobilityCorp.customerApp
            include mobilityCorp.fieldOpsApp
            include mobilityCorp.backOfficeTool
            autolayout lr
            title "Booking System – Component Diagram (Level 3)"
        }

        component mobilityCorp.operationsAnalytics "OperationsAnalytics" {
            include *
            include mobilityCorp.backOfficeTool
            include mobilityCorp.aiPlatform.taskApiGateway
            include transportAPI
            autolayout lr
            title "Operations Analytics – Component Diagram (Level 3)"
        }

        component mobilityCorp.aiPlatform "AIPlatformDataFoundation" {
            include mobilityCorp.aiPlatform.transportAdapter
            include mobilityCorp.aiPlatform.weatherCollector
            include mobilityCorp.aiPlatform.telemetryIngest
            include mobilityCorp.aiPlatform.kafkaIngress
            include mobilityCorp.aiPlatform.schemaRegistry
            include mobilityCorp.aiPlatform.streamProcessor
            include mobilityCorp.aiPlatform.batchProcessor
            include mobilityCorp.aiPlatform.bronzeZone
            include mobilityCorp.aiPlatform.silverZone
            include mobilityCorp.aiPlatform.goldZone
            include mobilityCorp.aiPlatform.exportApi
            include mobilityCorp.aiPlatform.dqMonitor
            include mobilityCorp.aiPlatform.metadataCatalog
            include mobilityCorp.aiPlatform.dataObsAgent
            include mobilityCorp.aiPlatform.featureRegistry
            include mobilityCorp.aiPlatform.transformationJob
            include mobilityCorp.aiPlatform.onlineStore
            include mobilityCorp.aiPlatform.offlineStore
            include mobilityCorp.aiPlatform.qualityMonitor
            include mobilityCorp.aiPlatform.lineageTracker
            include mobilityCorp.aiPlatform.featureObsAgent
            include mobilityCorp.aiPlatform.featureLoader
            include mobilityCorp.aiPlatform.trainingScheduler
            include mobilityCorp.aiPlatform.inferenceService
            include mobilityCorp.aiPlatform.forecastPublisher
            include mobilityCorp.aiPlatform.routingDataAdapter
            include mobilityCorp.aiPlatform.contextAssembler
            include mobilityCorp.aiPlatform.featureConnector
            include mobilityCorp.aiPlatform.conciergePolicyEvaluator
            include mobilityCorp.aiPlatform.tierValidator
            include transportAPI
            include weatherAPI
            include eventFeeds
            include mobilityCorp.observabilityStack
            autolayout lr 550 420 220
            title "AI Platform – Data Foundation"
        }

        component mobilityCorp.aiPlatform "AIPlatformModelLifecycle" {
            include mobilityCorp.aiPlatform.trainingScheduler
            include mobilityCorp.aiPlatform.featureLoader
            include mobilityCorp.aiPlatform.modelTrainer
            include mobilityCorp.aiPlatform.modelRegistryClient
            include mobilityCorp.aiPlatform.inferenceService
            include mobilityCorp.aiPlatform.forecastPublisher
            include mobilityCorp.aiPlatform.featureRegistry
            include mobilityCorp.aiPlatform.transformationJob
            include mobilityCorp.aiPlatform.offlineStore
            include mobilityCorp.aiPlatform.onlineStore
            include mobilityCorp.aiPlatform.qualityMonitor
            include mobilityCorp.aiPlatform.lineageTracker
            include mobilityCorp.aiPlatform.bronzeZone
            include mobilityCorp.aiPlatform.silverZone
            include mobilityCorp.aiPlatform.goldZone
            include mobilityCorp.aiPlatform.routingDataAdapter
            include mobilityCorp.aiPlatform.contextAssembler
            include mobilityCorp.aiPlatform.featureConnector
            include mobilityCorp.aiPlatform.conciergePolicyEvaluator
            include mobilityCorp.aiPlatform.tierValidator
            include mobilityCorp.aiPlatform.providerRouter
            include mobilityCorp.aiPlatform.taskApiGateway
            include mobilityCorp.aiPlatform.routingApi
            include mobilityCorp.aiPlatform.conciergeApi
            include mobilityCorp.bookingSystem.bookingService
            include mobilityCorp.fieldOpsApp
            include mobilityCorp.operationsAnalytics.stationPlanner
            include modelHost
            autolayout lr 550 420 220
            title "AI Platform – Model Lifecycle"
        }

        component mobilityCorp.aiPlatform "AIPlatformOperationalIntelligence" {
            include mobilityCorp.aiPlatform.taskApiGateway
            include mobilityCorp.aiPlatform.policyGate
            include mobilityCorp.aiPlatform.featureConnector
            include mobilityCorp.aiPlatform.providerRouter
            include mobilityCorp.aiPlatform.responseLocaliser
            include mobilityCorp.aiPlatform.routingApi
            include mobilityCorp.aiPlatform.routingDataAdapter
            include mobilityCorp.aiPlatform.routingConstraintBuilder
            include mobilityCorp.aiPlatform.routingSolver
            include mobilityCorp.aiPlatform.routingPostProcessor
            include mobilityCorp.aiPlatform.routingPublisher
            include mobilityCorp.aiPlatform.routingObsAgent
            include mobilityCorp.aiPlatform.inferenceService
            include mobilityCorp.aiPlatform.forecastPublisher
            include mobilityCorp.aiPlatform.conciergeApi
            include mobilityCorp.aiPlatform.contextAssembler
            include mobilityCorp.aiPlatform.recommenderEngine
            include mobilityCorp.aiPlatform.conciergePolicyEvaluator
            include mobilityCorp.aiPlatform.tierValidator
            include mobilityCorp.aiPlatform.conciergeExplainer
            include mobilityCorp.aiPlatform.conciergeObsAgent
            include mobilityCorp.aiPlatform.trainingScheduler
            include mobilityCorp.aiPlatform.featureLoader
            include mobilityCorp.aiPlatform.onlineStore
            include mobilityCorp.aiPlatform.offlineStore
            include mobilityCorp.bookingSystem.apiGateway
            include mobilityCorp.bookingSystem.bookingService
            include mobilityCorp.bookingSystem.returnsService
            include mobilityCorp.fieldOpsApp
            include mobilityCorp.customerApp
            include mobilityCorp.operationsAnalytics.stationPlanner
            include mobilityCorp.billingService.pricingEngine
            include mobilityCorp.billingService.invoiceManager
            autolayout lr 550 420 220
            title "AI Platform – Operational Intelligence"
        }

        component mobilityCorp.aiPlatform "AIPlatformConcierge" {
            include mobilityCorp.aiPlatform.taskApiGateway
            include mobilityCorp.aiPlatform.policyGate
            include mobilityCorp.aiPlatform.featureConnector
            include mobilityCorp.aiPlatform.providerRouter
            include mobilityCorp.aiPlatform.responseLocaliser
            include mobilityCorp.aiPlatform.conciergeApi
            include mobilityCorp.aiPlatform.contextAssembler
            include mobilityCorp.aiPlatform.recommenderEngine
            include mobilityCorp.aiPlatform.conciergePolicyEvaluator
            include mobilityCorp.aiPlatform.tierValidator
            include mobilityCorp.aiPlatform.conciergeExplainer
            include mobilityCorp.aiPlatform.conciergeObsAgent
            include mobilityCorp.aiPlatform.inferenceService
            include mobilityCorp.aiPlatform.forecastPublisher
            include mobilityCorp.aiPlatform.onlineStore
            include mobilityCorp.aiPlatform.offlineStore
            include mobilityCorp.bookingSystem.bookingService
            include mobilityCorp.customerApp
            include mobilityCorp.governancePlatform.policyDataService
            include mobilityCorp.governancePlatform.subscriptionDirectory
            autolayout lr 550 420 220
            title "AI Platform – Concierge Intelligence"
        }

        component mobilityCorp.aiPlatform "AIPlatformObservabilityLink" {
            include mobilityCorp.aiPlatform.interchangeObsAgent
            include mobilityCorp.aiPlatform.routingObsAgent
            include mobilityCorp.aiPlatform.predictionObsAgent
            include mobilityCorp.aiPlatform.conciergeObsAgent
            include mobilityCorp.aiPlatform.dataObsAgent
            include mobilityCorp.aiPlatform.featureObsAgent
            include mobilityCorp.governancePlatform.governanceObsAgent
            include mobilityCorp.governancePlatform.costObsAgent
            include mobilityCorp.backOfficeTool.monitoringDashboard
            include mobilityCorp.observabilityStack
            autolayout lr 550 420 220
            title "AI Platform – Observability Link"
        }

        component mobilityCorp.governancePlatform "GovernancePlatformAuditExplainability" {
            include mobilityCorp.governancePlatform.governanceApiGateway
            include mobilityCorp.governancePlatform.accessController
            include mobilityCorp.governancePlatform.consentRegistry
            include mobilityCorp.governancePlatform.ledgerWriter
            include mobilityCorp.governancePlatform.ledgerStore
            include mobilityCorp.governancePlatform.hashChainValidator
            include mobilityCorp.governancePlatform.explainabilityStore
            include mobilityCorp.governancePlatform.explainabilityApi
            include mobilityCorp.governancePlatform.auditDispatcher
            include mobilityCorp.governancePlatform.governanceObsAgent
            include mobilityCorp.aiPlatform.taskApiGateway
            include mobilityCorp.aiPlatform.conciergeExplainer
            include mobilityCorp.aiPlatform.routingPublisher
            include mobilityCorp.aiPlatform.forecastPublisher
            include mobilityCorp.bookingSystem.bookingService
            include mobilityCorp.observabilityStack
            include finance
            autolayout lr 550 420 220
            title "Governance Platform – Audit & Explainability"
        }

        component mobilityCorp.governancePlatform "GovernancePlatformCostPolicyBilling" {
            include mobilityCorp.governancePlatform.usageNormalizer
            include mobilityCorp.governancePlatform.budgetRegistry
            include mobilityCorp.governancePlatform.budgetPolicyEvaluator
            include mobilityCorp.governancePlatform.realtimeEnforcer
            include mobilityCorp.governancePlatform.eventPublisher
            include mobilityCorp.governancePlatform.billingReconciler
            include mobilityCorp.governancePlatform.reportGenerator
            include mobilityCorp.governancePlatform.policyDataService
            include mobilityCorp.governancePlatform.subscriptionDirectory
            include mobilityCorp.governancePlatform.costAuditLogger
            include mobilityCorp.governancePlatform.costObsAgent
            include mobilityCorp.aiPlatform.taskApiGateway
            include mobilityCorp.billingService.invoiceManager
            include mobilityCorp.bookingSystem.bookingService
            include paymentGateway
            include modelHost
            include mobilityCorp.observabilityStack
            autolayout lr 550 420 220
            title "Governance Platform – Cost, Policy & Billing"
        }

        styles {
            element "Person" {
                background #048c04
                color #ffffff
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
                color #ffffff
            }
            element "Container" {
                background #2f7d32
                color #ffffff
            }
            element "Component" {
                background #3d9970
                color #ffffff
            }
            element "Database" {
                shape cylinder
            }
            element "External" {
                background #555555
                color #ffffff
                opacity 75
            }
        }
    }
}
