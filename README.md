# Student-Health-Prediction
Kaggle competition submission. Treat this as a real ML problem provided by the business.
Go through complete data science lifecycle. Add monitoring. How does the user interact with it?
How do we deploy this on gcp?
Add explainability
Add sell to stakeholders

# Business Question
1. What is the business question?
    - For each patient, predict a health label (at-risk, unhealthy, fit) based on demographic, lifestyle, physical activity, and health metrics

2. What business decision will this inform?
    - Unsure. Determine who mihgt need medical intravention

3. Who is the decision maker and what is their current process?
    - Unknown

4. What is the cost of being incorrect? Is it symmetric?
    - For this case, we will assume that there is an equal cost of incorrect decision. Outside of a competition, the cost of a FN would outweight the cost of a FP because life could be lost and those that are FP would be close to the decision boundary anyway which could mean that treatment could be helpful

5. What is the time horizon for treatment? 
    - For this purpose we will assume immediate treatment implementation. 

6. What data exists and is it available at the time of inference/decision time?
    - We assume that all data is available at the time of inference
    - demographic, lifestyle, physical activity, and health metrics are available

7. Who acts on the output and will they trust this? (this is not as needed and redundant)
    - It will be assumed that doctors will act on the output and will investigate further if the patient is flagged

8. What are the ethical/privacy/regulatory constraints? 
    - There is HIPPA considerations for this. 
    - Though the patient is hidden by a patient ID, it will be assumed that this is medical data and will be treated as such for this implementation

9. What is the deployment/maintainence reality? 
    - We will assume a batch process
    - maintainence and productionalization will be owned by this team

10. WHat is the success criteria?
    - We will try to get the best balanced accuracy possible.
    - For this project, we will try to beat a majority naive classifier


# Data
1. Sources
    - Unknown
    - Probably taken in person or done via surveys
2. Quality
    - Assume that the quality is good
3. Cadence
    - Unknown, assume monthly
4. Class Balance
    - Majority are at-risk
5. Bias
    - This depends on the how the data was surveyed
    - The at-risk class being the majority suggests that the sampling was a routine survey across the entire university

# Features
1. Business intuition?
2. Technical Judgement
    - OHE, ratios, temporal aggregations?
    - Feature transformation
    - Dimensionality Reduction?

# Modeling Ideas - Explainability matters
1. Multiclass prediction using treebased predictors
2. One vs. rest
3. Neural Network
4. Tabular Foundation Models

# Validation
1. How was the train/test split done?
    - Stratified k-fold?
    - Holdout window?
    - Governance-style?
        - Stability across segments?
        - Assumption documentation?
        - Sign-off process
2. Explainability
    - SHAP

# Deployment
1. DVC
2. MLFlow
3. Unit tests
4. CI/CD - tie to dvc
    - precommits
    - branch rules
5. How to get this to gcp?
    - Set up with terraform
    - Set up cloudrun backend with docker
    - Set up front-end

# Monitoring
1. Performance monitoring
2. Drift MOnitoring
    - Try to keep this similar performance monitoring at Schwab
3. Retraining cadence and triggers
