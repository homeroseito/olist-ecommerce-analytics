# End-to-End E-Commerce Analytics: Customer Retention & Logistics SLA Optimization

## 📌 Project Overview
This project delivers a comprehensive, data-driven analysis of the Olist e-commerce marketplace ecosystem. By processing and engineering features across large relational datasets, the analysis uncovers critical operational bottlenecks in delivery Service Level Agreements (SLAs) and directly correlates logistics performance with a staggering customer retention challenge. 

The ultimate goal is to provide corporate stakeholders with actionable insights to transform one-time buyers into loyal, repeat customers by optimizing supply chain predictability.

---

## 📊 Key Business Insights Discovered
*   **The Retention Crisis:** Descriptive analytics revealed a severe customer attrition rate, where **97.00% of the active customer base are "Single Buyers"** (one-and-done shoppers). Only **2.76%** return for a second purchase, indicating an urgent need for post-purchase engagement and retention strategies.
*   **SLA & Delivery Friction:** Logistics analysis indicated a strong geographical variance in delivery efficiency. States located far from the primary economic hubs experience highly volatile delivery timelines and prolonged SLA deltas, directly impacting customer satisfaction scores.

---

## 🛠️ Tech Stack & Architecture
*   **Database & SQL Layer (PostgreSQL / DBeaver):** Structured complex multi-level CTEs, explicit type casting, date arithmetic, and advanced window functions (`DENSE_RANK`) to aggregate data cleanly at the source.
*   **Data Science & EDA Layer (Python / Pandas / Seaborn):** Statistical analysis, correlation matrices, and distribution tracking to validate the impact of delivery delays on review scores.
*   **Business Intelligence (Power BI):** Interactive executive dashboards mapping high-level financial health and supply chain operational efficiency.

---

## 📂 Repository Structure
```text
olist-ecommerce-analytics/
├── 01_database_sql/
│   ├── 01_executive_sales_performance.sql
│   ├── 02_top_categories_by_state_dense_rank.sql
│   ├── 03_payment_type_installment_analysis.sql
│   ├── 04_delivery_sla_lead_time_analysis.sql
│   └── 05_customer_retention_frequency_analysis.sql
├── 02_python_eda/
│   ├── notebooks/
│   │   └── 01_exploratory_data_analysis.ipynb
│   ├── requirements.txt
│   └── README.md
├── 03_powerbi_dashboard/
│   ├── Olist_Ecommerce_Web_Analytics.pbix
│   └── theme.json
├── .gitignore
└── README.md
