# MobilityCorp Product Requirements Document
*(EU-only shared e-bike, e-scooter, e-car & e-van platform)*

## 1. Product Overview

**Goal**  
Build an intelligent, reliable, GDPR-compliant e-mobility ecosystem that supports on-demand micro-mobility (bikes/scooters) and short-term scheduled vehicle rentals (cars/vans).

**Core Principle**  
Reliability + personalisation at scale.

**IoT Dependency**  
The IoT device layer (telematics hardware, firmware, communication stack, and OTA system) is **pre-existing** and considered an **external dependency**. We will integrate via provided APIs or data streams.

**Modules**
- **User App** – customer-facing for rentals, payments, routing, and concierge features.
- **Field Operative App** – for battery swaps, redistribution, and maintenance.
- **Back Office** – for fleet monitoring, prediction, routing optimisation, policy, and compliance.
- **Prediction & Routing** – ML and optimisation layer predicting demand and generating efficient field routes.

---

## 2. Scope

### In Scope
- All user, field, and back-office functions described above.
- GDPR-compliant data storage and consent mechanisms.
- EU-only deployment.
- Per-minute pricing with pre-authorisation.
- Concierge (personalised prediction) service — opt-in, GDPR-compliant, potential premium tier.

### Out of Scope
- Non-EU operations.
- Physical depot access systems.
- IoT implementation (already exists).
- Manual customer support systems (to integrate later).

---

## 3. Personas

| Persona | Description | Goals |
|---|---|---|
| **Rider (Sofia)** | Regular commuter or weekend traveller. | Fast access to reliable EVs, fair pricing, easy returns. |
| **Field Operative (Leo)** | Battery swapper / bike relocator. | Efficient routing, minimal idle time. |
| **Ops Manager (Ava)** | Oversees fleet & incidents. | Predict demand, assign tasks, monitor KPIs. |
| **Finance/Compliance (Marek)** | Oversees billing, fines, GDPR audits. | Accurate ledgers, auditability, low dispute rate. |

---

## 4. User App

### Core Features
- Registration, login, KYC.
- Licence and age verification (cars/vans).
- Payment setup with pre-authorisation.
- Per-minute billing; out-of-hub fines.
- NFC unlock; fallback QR.
- Destination-based ride planning (optional).
- Concierge/personalisation features (opt-in).
- GDPR consent management and data access/export.

### Decisions Made

| ID | Decision | Reasoning |
|---|---|---|
| D1 | Destination-based workflow optional | Allows users to plan to nearest hub; improves UX & prediction data. |
| D2 | Concierge/personalisation opt-in; potential premium tier | Differentiates brand, drives loyalty; opt-in satisfies GDPR Art. 22. |
| D3 | Google Maps API used for routing | Mature, cost-effective, avoids reinventing routing engine. |
| D4 | Pre-authorisation required for all rides | Reduces non-payment risk; aligns with industry standard. |
| D5 | Designated hubs mandatory for end-of-ride | Ensures fleet control; supports automatic fine logic. |

---

## 5. Field Operative App

### Core Features
- Login and shift management.
- Task inbox (battery swap, relocation, maintenance).
- Multi-vehicle route optimisation with time windows.
- Offline operation + sync.
- Proof of completion (photo/NFC hub tag).

### Decisions Made

| ID | Decision | Reasoning |
|---|---|---|
| D6 | Routing service to generate VRP-TW plans | Efficient coverage of swaps within time windows; lowers ops cost. |
| D7 | Offline-first approach | Field environments may lack connectivity; ensures continuity. |

---

## 6. Back Office

### Core Features
- Live telemetry map.
- Demand prediction model (city-level + user-level).
- Alerts (theft, breach, low battery).
- Routing optimisation.
- Policy management (pricing, fines, geofences).
- GDPR consent logs and DSR tools.
- Audit logging of operational and financial actions.

**Notes**
- Prediction model depends on telemetry feed quality; accuracy is bounded by external data latency and reliability.
- Routing service treats IoT feed as input data — not optimised at the device layer.

### Decisions Made

| ID | Decision | Reasoning |
|---|---|---|
| D8 | Prediction model uses external data (weather, strikes, events) | Richer forecasting; differentiates from competitors. |
| D9 | Multi-signal theft detection (motion, GPS, tilt) | Reduces false positives and operational cost. |
| D10 | Immutable audit logs (hash chain) | Ensures tamper-evident records for GDPR & financial audits. |
| D11 | Policy-as-data (configurable pricing, fines) | Enables safe experimentation and transparency. |

---

## 7. IoT & Telemetry

### Integration Features
- Integrate with existing OTA management system; no firmware modification.
- Consume telemetry at existing frequencies; downstream services must handle gaps or bursts.
- Command reliability depends on upstream IoT broker; commands must be idempotent at API boundary.

**Constraints**
- All IoT devices communicate through an existing telemetry platform via MQTT/HTTP APIs.
- MobilityCorp consumes normalized messages via Kafka bridge.
- Device protocols (NFC, lock firmware, telemetry cadence) are fixed and outside MobilityCorp’s control.

### Core Features
- Real-time telemetry (GPS, battery, lock).
- Configurable reporting frequency (adaptive sampling).
- Secure OTA firmware updates.
- Cryptographically signed commands for lock/unlock.

### Decisions Made

| ID | Decision | Reasoning |
|---|---|---|
| D12 | Command reliability via outbox/idempotency | Eliminates duplicate unlocks and stranded vehicles. |

---

## 8. Pricing, Billing & Policy

### Features
- Per-minute pricing for all vehicles.
- Fines per minute out-of-hub (configurable grace).
- Pre-authorisation + capture on completion.
- Insurance bundled for cars/vans.
- Refunds/disputes via back-office workflow.

### Decisions Made

| ID | Decision | Reasoning |
|---|---|---|
| D13 | Centralised billing service | Ensures ledger accuracy, refunds, and dispute resolution. |
| D14 | Fine logic per-minute after grace | Encourages compliance; easy to understand. |

---

## 9. Compliance & GDPR

### Principles
- EU data residency only.
- Explicit consent for personalization (GDPR Art. 22).
- DSR portal for access/export/delete.
- Retention limits (raw telemetry < 30 days).
- Immutable audit logs.
- DPIA conducted for profiling and IoT tracking.

### Decisions Made

| ID | Decision | Reasoning |
|---|---|---|
| D15 | Consent registry service | Provides traceability for personal data processing. |
| D16 | Profiling requires opt-in (premium concierge) | Avoids automatic decision-making without consent. |

---

## 10. Business Model

### Base Model
- Per-minute rental + fines + insurance costs.

### Premium Tier (optional future)
**“MobilityCorp Concierge” subscription (€X/month):**
- Personalised ride & hub suggestions.
- Route pre-booking and guaranteed availability.
- Loyalty discounts or perks.

### Decisions Made

| ID | Decision | Reasoning |
|---|---|---|
| D17 | Concierge as optional subscription | Creates differentiation & recurring revenue. |
| D18 | Profiling data isolated from operational telemetry | Limits GDPR risk; supports scalable architecture. |

---

## 11. Risks & Mitigations

| Risk | Type | Likelihood | Impact | Mitigation / Control |
|---|---|---|---|---|
| False theft or anomaly alerts | Technical (AI) | Med | High | Multi-signal validation (motion + GPS + lock state); human-in-loop review. |
| Data privacy or consent breach | Human / Technical / AI | Low | High | EU-only hosting; strict consent registry; pseudonymisation; automated PII scanning; explainability audits. |
| High solver / AI inference costs | Financial | Med | High | Cost guardrails (ADR-020); monitor usage; fallback heuristics. |
| AI model degradation / drift | Technical (AI) | Med | Med | Continuous monitoring; retraining; drift alerts. |
| AI vendor dependency | Strategic / External | Low–Med | High | AI Interchange Layer; multi-provider fallback; SLAs. |
| AI provider bankruptcy or API shutdown | Strategic / Financial | Low | High | Mirror key models; exportable weights; fallback plan. |
| AI hallucination / incorrect recommendation | Technical (AI UX) | Med | Med | Restrict LLM usage; require explainability output; manual review for flags. |
| AI bias or unfair personalisation | Ethical / Reputational | Low | High | Fairness audits; diverse data; clear opt-in; explanation portal. |
| Personalisation backlash | Human / Reputational | Low | Med | Clear opt-in/out; anonymised context; privacy transparency. |
| Unexpected surge in AI compute demand | Financial / Ops | Med | High | Auto-scaling ceilings; utilisation alerts; pre-approved budget. |
| Incorrect or delayed AI forecast | Technical (AI) | Med | Med | Ensemble + baseline heuristics; error bounding. |
| Hub saturation / empty hub | Operational | Med | Med | Routing feedback loop; manual dispatch override. |
| IoT feed latency or outages | External dependency | Med | High | Queue/retry; reconciliation; stale telemetry alerts. |
| Malformed telemetry schema | Data Quality | Med | Med | Schema validation; enrichment; version contracts. |
| Lock/unlock command failures | Integration | Low | High | Idempotent IDs; ACK monitoring; compensating transactions. |
| Payment or billing discrepancy | Financial / Technical | Low | High | Immutable logs; reconciliation; policy version tracking. |
| Unauthorized data access | Human / Security | Low | High | RBAC; immutable logs; quarterly privilege reviews. |
| External regulatory change | Legal / Compliance | Med | High | Compliance mapping; DPA updates; periodic legal review. |
| IoT vendor OTA or firmware failure | External (Upstream) | Low | High | Out of scope; monitor telemetry; contingency in contract. |
| API rate-limit or dependency SLA breach | External | Med | Med | Circuit breaker; SLA dashboards; secondary providers. |

---

## 12. Open Questions

- How do we handle theft tracking/prevention? (e.g., escalation process, automated vs human-verified, police data sharing?)
