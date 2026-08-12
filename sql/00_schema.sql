PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS agents;

CREATE TABLE agents (
    agent_id INTEGER PRIMARY KEY,
    agent_name TEXT NOT NULL,
    team TEXT NOT NULL,
    hire_date TEXT NOT NULL
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_type TEXT NOT NULL,
    country TEXT NOT NULL,
    loyalty_tier TEXT NOT NULL,
    signup_date TEXT NOT NULL
);

CREATE TABLE tickets (
    ticket_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    agent_id INTEGER,
    created_at TEXT NOT NULL,
    first_response_at TEXT,
    resolved_at TEXT,
    channel TEXT NOT NULL,
    category TEXT NOT NULL,
    priority TEXT NOT NULL,
    ai_assisted INTEGER NOT NULL CHECK (ai_assisted IN (0, 1)),
    escalated INTEGER NOT NULL CHECK (escalated IN (0, 1)),
    status TEXT NOT NULL,
    csat_score INTEGER CHECK (csat_score BETWEEN 1 AND 5),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

CREATE INDEX idx_tickets_category ON tickets(category);
CREATE INDEX idx_tickets_created_at ON tickets(created_at);
CREATE INDEX idx_tickets_customer_id ON tickets(customer_id);
CREATE INDEX idx_tickets_agent_id ON tickets(agent_id);

