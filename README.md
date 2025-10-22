# Architecture Kata — Q4 2025: AI-Enabled Architecture  

This repository contains the **ZAMB team’s solution** for the *Architectural Katas Q4 2025* challenge, themed **AI-Enabled Architecture**.  

Our goal was not only to design a robust, scalable system to meet the brief, but also to treat the kata as a **learning exercise** exploring how **AI-centric thinking** can influence architectural design decisions.

We approached the problem as an opportunity to deepen our understanding of:  

- How AI can serve as a *first-class architectural component*, not just an add-on feature.  
- How to document and reason about trade-offs when introducing AI into distributed systems.  
- How architectural reasoning and AI experimentation can reinforce one another in a structured, iterative way.  

By intentionally leaning into an **AI-heavy solution**, we challenged ourselves to consider issues such as data pipelines, model lifecycle management, feedback loops, explainability, and cost-to-value balance.

---

## Repository Structure  

### 1. `ADRs/` — *Architectural Decision Records*  
A series of documented decisions outlining the options we explored, the trade-offs we debated, and the rationale behind our choices

### 2. `c4/` — *C4 Model Diagrams*  
C4 diagrams representing the structure of our proposed solution, from system context to container and component levels.
The static-files directory contains the static images, while the workspace.dsl can be run with structurizr

### 3. `docs/` — *Supporting Documentation*  
This includes our **Product Requirements Document (PRD)**, and a high level mapping of component relationships and API Overview. The PRD was particularly useful in identifying key decisions that were later formalized in the ADRs.  

### 3. `flows/` — *Flow Diagrams*  
To support the diagrams, we also have some flow diagrams mapping to the ADRs - these are included in the ADRs, but stored here seperatley for reference.

---

## Approach  

We treated this kata as a collaborative exploration, paying particular attention to:

- **Architectural clarity:** using ADRs and C4 diagrams to reason about complex trade-offs.  
- **AI as an architectural driver:** designing with AI in mind from the outset, rather than bolting it on later.  
- **Learning by doing:** experimenting with design patterns, data flows, and governance concerns unique to AI-enabled systems.  

---

## Exploring AI-Specific Challenges  

As part of this kata, we deliberately explored the **unique challenges that AI introduces into architectural design**, including:  

- **Model costs and scalability:**  
  Evaluating how inference and training costs impact architectural choices, budgeting, and system elasticity, and how to mitigate them through caching, batching, and model selection strategies.  

- **Model lifecycle management:**  
  Considering how to handle *model versioning, updates, and deprecations*, especially given the rapid evolution and potential loss of support for third-party or proprietary models.  

- **Dependency and portability risks:**  
  Reflecting on the implications of vendor lock-in, API changes, and the need for fallback mechanisms if a model or provider becomes unavailable.  

- **Ethical and governance considerations:**  
  Discussing how explainability, data privacy, and bias management fit into the broader system design, and ensuring accountability within AI-driven components.  

- **Operational observability:**  
  Identifying how to monitor and trace AI components differently from traditional microservices e.g. tracking inference latency, token usage, accuracy drift, and feedback loops.  

In this kata and through our explorations, we developed a deeper appreciation for the **non-technical dimensions of AI architecture** where cost, governance, and lifecycle risks are as critical as performance or scalability.  

---

## Reflections

The time pressure was our biggest challenge, not only for completing the kata to a standard we were happy with, but also managing collaboration around a team with a wide range of other commitments. The scope of the application and the learning we tried to undertake were no small task.

The challenge itself was really engaging, and offered lots of seams where we could either lean into the AI opportunities, or pursue non-ai options. We tried to document all of these thoughts in our ADRs.