# 💼 counteroffer

**Decentralized recruiter engagement & sovereign opportunity negotiation platform.**

`counteroffer` is a Datagotchi Labs career primitive designed to return structural power to candidates during the hiring process. Built as a sovereign, candidate-owned interface, it bypasses corporate ATS (Applicant Tracking System) gatekeeping, standardizes compensation and role queries, and provides an auditable, candidate-driven medium for negotiating job opportunities.

---

## 🎯 The Friction & The Solution

The traditional recruitment ecosystem is built on **asymmetric information** and **data enclosure**:
* **Corporate ATS Gatekeeping:** Resume parsers strip nuance, extract candidate data, and trap applicants in one-sided HR algorithms.
* **Opaque Negotiations:** Recruiters hold market comp data while forcing candidates into arbitrary salary expectations first.
* **Fragmented Deal Tracking:** Job seekers manage offers across disjointed email threads, LinkedIn messages, and recruiter spreadsheets.

**`counteroffer` solves this by:**
1. Establishing a **candidate-first interaction model** where recruiters engage with structured candidate portfolios on equal terms.
2. Standardizing negotiation primitives (compensation ranges, stack alignment, remote flexibility, title expectations).
3. Keeping candidate historical data and active deal flows completely **sovereign and local-first**.

---

## 🏗️ System Architecture

```mermaid
graph LR
    A[Recruiter Outreach / Inquiry] --> B{counteroffer Platform Engine}
    C[Candidate Portfolio & Comp Ranges] --> B
    
    B -->|Structured Negotiation Thread| D[Direct Candidate-Recruiter Messaging]
    B -->|Track Deal State| E[(Sovereign Local Store)]
    
    style B fill:#2b2b2b,stroke:#00ffcc,color:#fff
    style E fill:#1f1f1f,stroke:#ff0055,color:#fff
