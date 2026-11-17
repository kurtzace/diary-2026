Monitoring Machine Learning in Production".

Key Concepts from the Article

• Model Drift & Decay: Unlike traditional software that functions predictably until code changes, machine learning models represent a mathematical snapshot of past data and naturally degrade (decay) over time as real-world conditions shift.
• Data Drift (Covariate Shift): Occurs when the statistical distribution of input features changes over time (e.g., input data looks different from training data), even though the underlying logic or target variable remains the same.
• Concept Drift (Posterior Probability Shift): The most dangerous form of decay, where the relationship between input features and the target variable changes (e.g., consumer behavior or economic shifts altering what data points mean).
• The "New User" Problem: A model trained in one environment (e.g., urban fintech) deployed in a different environment (e.g., rural market) where income levels, spending, and habits differ completely.
• Why Monitoring Matters: Models can still output a "probability score" or look healthy on an infrastructure dashboard while losing actual business value, making continuous MLOps monitoring essential.



---

## MLOps
The article focuses on maintaining machine learning model performance over time by identifying when real-world production data begins to differ significantly from the data used during training.

---

## Key Takeaways

### 1. Common Types of Data Discrepancies

* **Training-Inference Data Skew:** A structural mismatch often caused by architectural flaws or engineering differences (e.g., using different mathematical libraries or windowing logic in Python vs. C++ pipelines).
* **Data Leakage:** Incorporating features during training that are only available after the target event occurs (e.g., using "total call duration" to predict if a customer will churn).

### 2. Drift Detection Methods
Because manual inspection cannot reliably catch subtle or compounding data shifts, teams use objective statistical calculations:

* **Numerical Features (Kolmogorov-Smirnov Test):** The K-S test compares the shape of two distributions without assuming normality. It outputs a distance score representing the maximum separation between them; if it exceeds a set threshold, drift is confirmed.
* **Categorical Features:** Uses the Chi-Squared Test or Jensen-Shannon Divergence (JSD) to measure how much category frequencies have shifted compared to baseline data.
* **Population Stability Index (PSI):** A single, easy-to-interpret numerical value often used by teams to classify drift into categories:
  * $\text{PSI} < 0.1$: No change
  * $0.1 \le \text{PSI} \le 0.25$: Moderate drift
  * $\text{PSI} > 0.25$: Significant drift

### 3. MLOps Tools and Frameworks

| Tool | Focus | Main Benefit / Why Use It? |
| :--- | :--- | :--- |
| **Evidently** | Visual analysis | Generates interactive HTML reports for data scientists to quickly debug where and why drift is happening. |
| **WhyLogs** | Data profiling | Uses compact, mergeable data "sketches" instead of raw data, making it highly efficient for high-volume pipelines where moving massive datasets is too expensive. |
| **MLflow** | Lifecycle tracking | Primarily tracks experiments and logging. It links drift alerts directly back to specific model versions and training parameters. |
| **Great Expectations** | Data quality | Focuses on unit testing for data, ensuring incoming data matches specific schemas and distributions before hitting the model. |

---

## Hands-on Example Mentioned
The text introduces a practical walkthrough using the California Housing dataset from `sklearn`. It demonstrates how to train a model on a clean baseline subset and then "corrupt" a second subset to simulate real-world economic shifts (such as drastic changes to house prices or local income) to test drift detection tools.


```
import numpy as np
import pandas as pd
from scipy.stats import ks_2samp
from sklearn.datasets import fetch_california_housing

# ==========================================
# 1. Setup Data
# ==========================================
# Fetch the California housing dataset as a Pandas DataFrame
data = fetch_california_housing(as_frame=True)
df = data.frame

# Split the dataset into "Past" (Training) and "Present" (Production) subsets
# Sample 50% randomly for training, use the rest for production simulation
training_data = df.sample(frac=0.5, random_state=42)
production_data = df.drop(training_data.index)

# ==========================================
# 2. Simulate Production Drift
# ==========================================
# Make a copy to inject artificial data drift
production_data_drifted = production_data.copy()

# Scenario A: A massive real estate bubble occurs where prices ('MedHouseVal')
# and incomes ('MedInc') decouple significantly from historical norms.
# In this case, median income dramatically drops to 10% of its original value.
production_data_drifted["MedInc"] = production_data_drifted["MedInc"] * 0.1

# Scenario B: Introduce a weird data error / pipeline bug into the 'AveRooms' feature
# by scaling all values up by a factor of 1.8.
production_data_drifted["AveRooms"] = production_data_drifted["AveRooms"] * 1.8


# ==========================================
# 3. Detection Function
# ==========================================
def detect_drift(baseline, current, threshold=0.05):
    """Compares baseline (training) and current (production) distributions

    using the Kolmogorov-Smirnov (K-S) two-sample test.
    """
    report = []

    # Iterate through each feature column present in the baseline data
    for col in baseline.columns:
        # Perform the K-S test to compare the two feature distributions
        stat, p_value = ks_2samp(baseline[col], current[col])

        # A very low p-value (below the threshold) indicates that the
        # probability of these two datasets coming from the same
        # distribution is near zero, meaning drift has occurred.
        is_drifted = p_value < threshold

        # Log the statistical results and evaluation status
        report.append(
            {
                "Feature": col,
                "K-S Stat": round(stat, 4),
                "P-Value": f"{p_value:.2e}",
                "Status": "DRIFTED" if is_drifted else "OK",
            }
        )

    return pd.DataFrame(report)


# ==========================================
# Execution & Monitoring Report
# ==========================================
# Run the drift detection against our manipulated production dataset
drift_report = detect_drift(training_data, production_data_drifted)
print(drift_report)
```