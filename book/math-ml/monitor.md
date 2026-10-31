Monitoring Machine Learning in Production".

Key Concepts from the Article

• Model Drift & Decay: Unlike traditional software that functions predictably until code changes, machine learning models represent a mathematical snapshot of past data and naturally degrade (decay) over time as real-world conditions shift.
• Data Drift (Covariate Shift): Occurs when the statistical distribution of input features changes over time (e.g., input data looks different from training data), even though the underlying logic or target variable remains the same.
• Concept Drift (Posterior Probability Shift): The most dangerous form of decay, where the relationship between input features and the target variable changes (e.g., consumer behavior or economic shifts altering what data points mean).
• The "New User" Problem: A model trained in one environment (e.g., urban fintech) deployed in a different environment (e.g., rural market) where income levels, spending, and habits differ completely.
• Why Monitoring Matters: Models can still output a "probability score" or look healthy on an infrastructure dashboard while losing actual business value, making continuous MLOps monitoring essential.