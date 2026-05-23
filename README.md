# Online Retail Analytics — End-to-End Data Pipeline with Machine Learning

> A complete data analytics and machine learning project analysing **1M+ UK retail transactions** (2009–2011) using Python, SQL Server, scikit-learn, XGBoost, and Power BI.

<img width="1169" height="659" alt="image" src="https://github.com/user-attachments/assets/8525b533-d735-4ed9-b974-9d457ca5573a" />

---

## 📊 Project Overview

This project demonstrates an end-to-end **data analytics and ML workflow** on the [Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii) dataset from the UCI Machine Learning Repository.

The pipeline covers data ingestion, cleaning, validation, storage, analytical querying, predictive modelling, and interactive visualisation — producing actionable business insights for a UK-based B2B wholesale gift supplier.

## 🎯 Business Impact

Key insights uncovered:

- **£18.93M net revenue** across 2 years (2009–2011)
- **4.3% of customers generate 49.7% of revenue** (Pareto distribution proven)
- **£3.7M re-engagement opportunity** identified via RFM segmentation
- **£1.26M at-risk revenue** identified via XGBoost churn prediction model
- **£379K protectable revenue** through targeted retention (industry-average rates)
- **Strong B2B pattern confirmed**: 98% of orders occur weekdays 9am–5pm
- **Christmas wholesale peak** in November every year (~2x average monthly revenue)

## 🛠️ Tech Stack

| Layer | Tool |
|---|---|
| Data Cleaning | Python (Pandas, NumPy) |
| Storage | Microsoft SQL Server |
| Analysis | T-SQL (CTEs, Window Functions, NTILE) |
| Machine Learning | scikit-learn, XGBoost |
| Visualisation | Power BI Desktop (DAX) |
| Environment | Jupyter Notebook, SSMS |

## 📁 Project Structure

```
online-retail-analytics/
├── notebooks/
│   ├── 01_data_cleaning.ipynb       # Python cleaning pipeline
│   └── 03_churn_prediction.ipynb    # ML churn model (XGBoost)
├── SQL/
│   ├── 01_executive_kpis.sql        # Headline business KPIs
│   ├── 02_customer_analytics.sql    # Top customers, segments
│   ├── 03_rfm_segmentation.sql      # RFM customer segmentation
│   └── 04_create_view.sql           # RFM view for Power BI
├── Dashboard/
│   ├── OnlineRetailDashboard.pbix   # 4-page Power BI dashboard
│   └── screenshots/                 # Dashboard previews
├── Report/
│   └── Online_Retail_Analytics_Report.docx  # Full project report
├── DATA/
│   └── README.md                    # Data source instructions
└── README.md
```

## 🔄 Pipeline Workflow

### 1. Data Cleaning (Python)

- Loaded both Excel sheets (1.07M raw rows)
- Removed **34,335 exact duplicates**
- Flagged **230,876 guest transactions** without deletion
- Flagged **19,104 cancellation invoices** (prefix 'C') for separate analysis
- Removed **5,707 admin/non-product entries** (POST, BANK CHARGES, AMAZONFEE, etc.)
- Filtered invalid prices and zero quantities
- Engineered new fields: Revenue, Year, Month, DayOfWeek, Hour, YearMonth
- **Final cleaned dataset: 1,021,330 rows × 17 columns**

### 2. SQL Server Storage

- Loaded cleaned DataFrame into SQL Server using SQLAlchemy + pyodbc
- Created persistent `sales` table and `vw_RFM_Segments` view
- All queries written in T-SQL with CTEs and window functions

### 3. Customer Segmentation (RFM)

Used **Recency, Frequency, Monetary** scoring with `NTILE(5)` to segment 5,875 registered customers into 8 strategic groups:

| Segment | Customers | % of Revenue |
|---|---|---|
| 01. Champions | 630 | 38.5% |
| 02. Loyal Customers | 1,217 | 32.3% |
| 06. At Risk | 1,216 | 21.0% |
| 03. New Customers | 1,167 | 2.7% |
| 09. Others | 785 | 2.8% |
| 08. Lost | 733 | 1.2% |
| 04. Promising | 64 | 1.4% |
| 05. Needs Attention | 40 | 0.1% |

### 4. Machine Learning — Churn Prediction

Built an **XGBoost classifier** to predict which customers will make a purchase in the next 60 days.

**Approach:**
- **Target**: Binary classification (will buy / will not buy in next 60 days)
- **Feature engineering**: 18 customer-level features including RFM metrics, time-trend features (recent vs older activity), country encoding, and behavioural ratios
- **Train/test split**: 80/20 with stratification
- **Models compared**: Logistic Regression (0.78 AUC), Random Forest (0.79 AUC), XGBoost (0.79 AUC)
- **Critical decision**: Reformulated initial 90-day churn definition after finding it inadequate for B2B wholesale buying patterns

**Results:**
- **ROC-AUC: 0.79** — moderate but useful predictive power
- **Lift over random targeting**: 1.6x when targeting top 20% of customers
- **Top 100 high-value at-risk customers identified**: £1.26M in at-risk revenue
- **Expected protected revenue**: ~£379K assuming 30% retention success rate

**Risk diagnoses** generated for each high-value at-risk customer (plain-English explanations for CRM staff): "VIP account - escalate", "Long inactivity (>6 months)", "Active buyer who stopped", etc.

### 5. Power BI Dashboard

A 4-page interactive dashboard:

**Page 1 — Executive Summary**
KPI cards, monthly revenue trend, top 10 countries, top 10 products.

<img width="1169" height="659" alt="image" src="https://github.com/user-attachments/assets/8525b533-d735-4ed9-b974-9d457ca5573a" />

**Page 2 — Customer Insights (RFM)**
RFM segment breakdown, top customers, segment × country heatmap.


<img width="1181" height="659" alt="Screenshot 2026-05-22 162003" src="https://github.com/user-attachments/assets/9f4be39d-8966-40c5-8d30-f80f386cbf3f" />

**Page 3 — Product Performance**
Top products, hour-of-day distribution, day-of-week patterns.

<img width="1166" height="658" alt="Screenshot 2026-05-22 162021" src="https://github.com/user-attachments/assets/3e128533-7753-48bb-9bc1-3b577f856d9c" />

**Page 4 — Churn Predictions**
ML-predicted risk tiers, top high-value at-risk accounts with risk reasons, country × risk heatmap.

<img width="1126" height="641" alt="image" src="https://github.com/user-attachments/assets/77f0f01a-6bef-4328-b4ec-a4725c65776d" />


## 🔍 Key SQL Techniques Demonstrated

- Common Table Expressions (CTEs) for multi-step logic
- `NTILE(5)` window function for RFM quintile scoring
- `DATEDIFF` and `TRY_CAST` for recency calculation
- `CASE` logic for segment classification
- Conditional aggregations with `SUM(CASE WHEN...)`
- Views (`CREATE VIEW`) for reusable analysis layers

## 🤖 Key ML Techniques Demonstrated

- **Time-based feature engineering** (preventing data leakage with cutoff dates)
- **Behavioural trend features** (recent vs older activity windows)
- **XGBoost** classifier with hyperparameter tuning
- **Model comparison** across Logistic Regression, Random Forest, XGBoost
- **Evaluation metrics**: ROC-AUC, precision, recall, F1-score
- **Lift charts** for business communication of model value
- **Risk-tier segmentation** for operational use
- **Explainable outputs** (plain-English risk reasons) for stakeholder consumption

## 📈 Key DAX Measures

```dax
Net Revenue = 
CALCULATE(SUM(sales[Revenue]), sales[IsCancellation] = FALSE)

High-Value At-Risk Revenue = 
SUM(high_value_at_risk_customers[monetary])

At-Risk Customers = 
CALCULATE(
    DISTINCTCOUNT(churn_predictions[Customer ID]),
    OR(churn_predictions[risk_tier] = "High Risk",
       churn_predictions[risk_tier] = "Critical Risk")
)
```

## 📚 Dataset

- **Source**: UCI Machine Learning Repository — [Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii)
- **Period**: December 2009 – December 2011
- **Records**: 1,067,371 raw → 1,021,330 cleaned
- **Geography**: 43 countries (UK 89% of revenue)

## 💡 Key Findings — Honest Assessment

The churn prediction model achieved 0.79 ROC-AUC — moderate predictive power. In a production environment, performance could be improved by adding external features such as email engagement, support ticket history, and competitor pricing. The current model is useful for **ranking and prioritisation** rather than high-stakes individual predictions.

What makes this project valuable is not the raw model accuracy, but the **iterative process**:

1. Built a baseline model
2. Discovered limitations (B2B seasonal buying complicates churn definition)
3. Reformulated the problem to predict "next 60-day purchase" instead of "churn"
4. Pivoted from "top 100 most likely to churn" (£49K total) to "top 100 high-value at-risk" (£1.26M total) — a 25x improvement in business value

This iterative thinking is what differentiates production ML from textbook exercises.

## 🚀 How to Reproduce

1. Download the dataset from the UCI link above
2. Update file path in `notebooks/01_data_cleaning.ipynb`
3. Run the cleaning notebook
4. Create a SQL Server database called `RetailDB`
5. Push cleaned data to SQL Server
6. Execute the SQL files in order
7. Run `notebooks/03_churn_prediction.ipynb` for the ML model
8. Open `OnlineRetailDashboard.pbix` in Power BI Desktop

## 👤 Author

**Jumma Mohammad Teli** — Data Analyst  
📍 Birmingham, UK  
🔗 [LinkedIn](https://linkedin.com/in/jumma-mohammad) | [GitHub](https://github.com/jumma786)  
📧 jummamohammad477@gmail.com
