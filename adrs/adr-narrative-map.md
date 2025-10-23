# MobilityCorp ADR Narrative Map

```mermaid
graph TD
    A[ADR-001: External Dependency SLA & Retry Handling]
    B[ADR-002: Pricing & Billing Microservice Architecture]
    C[ADR-003: Geofence & Fine Enforcement Logic]
    D[ADR-004: Demand Prediction Model]
    E[ADR-005: Routing Solver (VRP-TW)]
    F[ADR-006: Alerts & Theft Detection Logic]
    G[ADR-007: Data Platform Architecture]
    H[ADR-008: Mobile Offline Sync Strategy]

    A --> B
    A --> C
    A --> D
    A --> E
    A --> F
    A --> G
    A --> H
    B --> C
    B --> G
    C --> G
    D --> E
    D --> G
    E --> G
    F --> G
    G --> D
    G --> E
    G --> F
    G --> H
    H --> G
    F --> H

    subgraph Legend
      direction LR
      L1[Solid arrow: "builds on / depends on"]
    end
```

---

**How to read this map:**
- Each node is an ADR (001–008) with its title.
- Arrows indicate architectural dependency or narrative flow (e.g., "builds on", "depends on").
- The Data Platform (ADR-007) is central, supporting AI/ML, routing, alerting, and mobile sync.
- Reliability patterns (ADR-001) underpin all other ADRs.
- Mobile Offline Sync (ADR-008) and Alerts (ADR-006) both depend on the event-driven platform and reliability standards.

For a live/interactive version, paste the Mermaid code above into a Mermaid live editor (e.g., https://mermaid.live/).
