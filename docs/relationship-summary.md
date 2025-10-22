# MobilityCorp Architecture — Relationship Summary

| **From**               | **To**              | **Interaction / Purpose**                  | **Direction** |
| ---------------------- | ------------------- | ------------------------------------------ | ------------- |
| **End User**           | Customer App        | Books and manages rentals                  | →             |
| **Field Operative**    | Field-Ops App       | Performs swaps, returns, maintenance tasks | →             |
| **Operations Manager** | Back Office Tool    | Oversees fleet operations and KPIs         | →             |
| **Finance Officer**    | Billing Service     | Reviews invoices and adjustments           | →             |
| **Finance Officer**    | Governance Platform | Reviews spend and compliance reports       | →             |

---

## Operational and Mobility Layer

| **From**                                | **To**                     | **Purpose**                               |
| --------------------------------------- | -------------------------- | ----------------------------------------- |
| Customer App                            | Booking System API Gateway | Create / update / cancel booking          |
| Field-Ops App                           | Booking Returns Service    | Upload return evidence (photos, notes)    |
| Returns Service                         | Back Office Tool           | Notify for verification / human approval  |
| Back Office Tool                        | Vehicle Store              | Mark vehicle available after verification |
| Booking Payment Service                 | Billing Service            | Request invoice / payment settlement      |
| Billing Service                         | Payment Gateway            | Execute charge or refund                  |
| Back Office Tool (Monitoring Dashboard) | Observability Stack        | Display telemetry / SLA metrics           |

---

## AI & Analytics Flow

| **From**                     | **To**                       | **Purpose**                           |
| ---------------------------- | ---------------------------- | ------------------------------------- |
| Booking Service              | AI Task API Gateway          | Send booking context & demand signals |
| AI Forecast Publisher        | Booking Service              | Return predicted availability         |
| AI Forecast Publisher        | Operations Analytics Service | Provide demand forecasts for planning |
| Operations Analytics Service | Back Office Tool             | Display hub planning recommendations  |
| AI Platform                  | Observability Stack          | Emit telemetry & traces               |
| AI Platform                  | Model Hosting Platform       | Publish / retrieve trained models     |
| Model Hosting Platform       | AI Platform                  | Return inference results              |

---

## Governance, Policy and Billing

| **From**                          | **To**                      | **Purpose**                          |
| --------------------------------- | --------------------------- | ------------------------------------ |
| AI Task API Gateway               | Governance Usage Normalizer | Emit model-usage telemetry           |
| Governance Billing Reconciler     | Billing Store               | Validate invoices vs. usage data     |
| Governance Subscription Directory | Billing Service             | Reconcile subscription billing       |
| Billing Service                   | Payment Gateway             | Execute charges / refunds            |
| Governance Platform               | Observability Stack         | Publish compliance & audit telemetry |

---

## Data Foundation and AI Training

| **From**           | **To**                       | **Purpose**                                |
| ------------------ | ---------------------------- | ------------------------------------------ |
| Transport Adapter  | Regional Transport Providers | Pull real-time mobility feeds              |
| Weather Collector  | Weather Provider             | Retrieve environmental data                |
| Event Feeds        | Transport Adapter            | Inject external events (strikes, holidays) |
| Stream Processor   | Silver Zone                  | Write conformed datasets                   |
| Transformation Job | Feature Stores               | Build batch and streaming features         |
| Feature Registry   | Governance Ledger Writer     | Record data lineage provenance             |

---

## Audit, Explainability and Compliance

| **From**               | **To**                 | **Purpose**                              |
| ---------------------- | ---------------------- | ---------------------------------------- |
| Governance API Gateway | Access Controller      | Authorise explainability / audit request |
| Access Controller      | Consent Registry       | Validate user consent / rights           |
| Explainability API     | Explainability Store   | Retrieve model rationale                 |
| Ledger Writer          | Immutable Ledger Store | Append audit entries                     |
| Hash-Chain Validator   | Ledger Store           | Verify chain integrity                   |
| Audit Dispatcher       | Observability Stack    | Publish compliance metrics               |


---

## Observability and Telemetry

| **From**                  | **To**                           | **Purpose**                      |
| ------------------------- | -------------------------------- | -------------------------------- |
| All *ObsAgent components* | Observability Stack              | Send metrics, traces, and alerts |
| Observability Stack       | Back Office Monitoring Dashboard | Display performance indicators   |
| Governance & Billing      | Observability Stack              | Emit spend and policy telemetry  |

---

## High Level Domain Boundaries

| **Domain**               | **Owns**                                    | **Consumes From**                                      |
| ------------------------ | ------------------------------------------- | ------------------------------------------------------ |
| **Mobility / Core Ops**  | Booking System, Field-Ops App, Customer App | AI Platform (forecasts), Billing Service               |
| **Operations Analytics** | Planning Data Store                         | AI Forecast Publisher, Observability Stack             |
| **AI Platform**          | Models, Pipelines, Feature Store            | Transport / Weather APIs, Governance Platform          |
| **Governance Platform**  | Audit, Explainability, Policy, Cost Control | AI Platform (usage), Billing Service                   |
| **Billing Service**      | Pricing, Invoicing, Taxation                | Booking System (payments), Governance (reconciliation) |
| **Observability Stack**  | Logs, Metrics, Dashboards                   | All platform containers                                |

---

## API Overview

| **API Name**     | **Consumer**           | **Purpose**                         | **Protocol**   |
| ---------------- | ---------------------- | ----------------------------------- | -------------- |
| Booking API      | User App / Back Office | Create, modify, cancel bookings     | REST / JSON    |
| Routing API      | Field Ops App          | Retrieve optimised swap routes      | REST / JSON    |
| Forecast API     | Back Office, Analytics | Request demand predictions          | REST / JSON    |
| Policy API       | Governance / Admin     | Retrieve or update pricing policies | REST / GraphQL |
| Billing API      | Booking System         | Request charge/refund operations    | REST / JSON    |
| Telemetry Ingest | IoT Platform           | Stream GPS/battery events           | Kafka / MQTT   |




