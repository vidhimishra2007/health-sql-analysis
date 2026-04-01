# 🏥 Health SQL Analysis

A public health data analysis project using SQL and Python, exploring patterns in heart disease risk factors and India's national health indicators across two real-world datasets.

---

## 📌 Overview

This project demonstrates end-to-end SQL-based data analysis on two health datasets — the **UCI Heart Disease dataset** and **NFHS-5 (National Family Health Survey)** data. It covers 30+ SQL queries ranging from basic aggregations to complex multi-table analysis, complemented by Python visualizations.

The project is part of a personal portfolio focused on **AI for Health** and data analytics.

---

## 📂 Repository Structure

```
health-sql-analysis/
│
├── sql/                    # SQL query files
├── notebooks/              # Jupyter notebooks with analysis + visualizations
├── outputs/                # Generated charts and result exports
├── heart_final.csv         # UCI Heart Disease dataset (cleaned)
├── nfhs5_ascii.csv         # NFHS-5 national health indicators dataset
└── .gitignore
```

---

## 📊 Datasets

### 1. UCI Heart Disease Dataset (`heart_final.csv`)
- Source: [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/heart+disease)
- Contains patient-level clinical features: age, sex, chest pain type, blood pressure, cholesterol, fasting blood sugar, ECG results, max heart rate, exercise-induced angina, and heart disease diagnosis.

### 2. NFHS-5 Dataset (`nfhs5_ascii.csv`)
- Source: [National Family Health Survey – Round 5 (2019–21)](http://rchiips.org/nfhs/NFHS-5Reports/NFHS-5_INDIA_REPORT.pdf)
- Contains state/district-level indicators on maternal health, child nutrition, anaemia, immunization, and healthcare access across India.

---

## 🔍 Analysis Highlights

**Heart Disease Queries (UCI Dataset)**
- Distribution of heart disease by age group and sex
- Average cholesterol and blood pressure across patient categories
- Correlation of chest pain type with disease prevalence
- Risk stratification using multiple clinical features
- Filtering high-risk patients using compound conditions

**NFHS-5 Queries**
- State-wise comparison of child stunting, wasting, and underweight rates
- Anaemia prevalence across women and children by region
- Institutional delivery and maternal healthcare access trends
- Immunization coverage analysis across districts
- Ranking states by composite health indicators

**Cross-dataset / Advanced SQL**
- Window functions for ranking and percentile analysis
- Subqueries and CTEs for multi-step aggregations
- Grouped summaries with `HAVING` filters
- Regex-based pattern matching on categorical fields

---

## 🛠️ Tech Stack

| Tool | Usage |
|------|-------|
| **SQLite / SQLAlchemy** | Query execution on CSV-loaded datasets |
| **Python** | Data loading, SQL interface, visualization |
| **Pandas** | Data wrangling and result formatting |
| **Matplotlib / Seaborn** | Charts and visual outputs |
| **Jupyter Notebook** | Interactive analysis environment |

---

## 🚀 How to Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/vidhimishra2007/health-sql-analysis.git
   cd health-sql-analysis
   ```

2. **Install dependencies**
   ```bash
   pip install pandas matplotlib seaborn sqlalchemy jupyter
   ```

3. **Launch the notebook**
   ```bash
   jupyter notebook notebooks/
   ```

4. The notebooks load the CSV files into an in-memory SQLite database and run SQL queries directly via `pandas.read_sql`.

---

## 📈 Sample Outputs

Charts and query result exports are saved in the `outputs/` folder, including:
- Bar charts of disease prevalence by demographic group
- Heatmaps of NFHS-5 indicators by state
- Distribution plots of clinical features

---

## 🎯 Key Skills Demonstrated

- Writing and optimizing 30+ SQL queries across varied complexity levels
- Working with real public health datasets (clinical + survey data)
- Combining SQL with Python for end-to-end analysis pipelines
- Data storytelling through visualizations
- Domain focus: **AI for Health / Public Health Analytics**

---

## 👩‍💻 Author

**Vidhi Mishra**  
Bachelor of Science (Hons.) Computer Science & Data Analytics — IIT Patna  
[GitHub](https://github.com/vidhimishra2007) | [LinkedIn](https://www.linkedin.com/in/vidhi-mishra-3b2258303/)

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
