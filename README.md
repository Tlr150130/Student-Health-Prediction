# Student-Health-Prediction

Kaggle competition submission, treated as a real ML problem provided by the business — not just a leaderboard exercise. Full data science lifecycle, explainability, monitoring design, and a stakeholder narrative are all in scope, not optional polish.

**Phase 1 — Kaggle submission (current focus).** Go through the complete data science lifecycle end-to-end and submit test predictions: business framing, data understanding, feature engineering, modeling, validation, explainability (SHAP), and a plan for monitoring/retraining. Success is beating a majority-class naive baseline on balanced accuracy.

**Phase 2 — Deployment (after submission).** Package the trained model behind a serving endpoint and ship it with Docker: containerize the model API (near-term, required) and optionally add a UI on top (framework/scope TBD — decide once the endpoint exists). GCP (Terraform + Cloud Run) remains a documented future stretch goal, not required for Phase 2 to be considered done. See the Deployment section below for detail.

# Business Question
1. What is the business question?
    - For each patient, predict a health label (at-risk, unhealthy, fit) based on demographic, lifestyle, physical activity, and health metrics

2. What business decision will this inform?
    - Unsure. Determine who might need medical intravention

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
5. Phase 2 - Create write-up and presentation
    - Learn how to create presentations for ML projects
    - add explainability
    - Add section for next phase
    - Assume this is for exec/stakeholder buy-in
6. Phase 3 plan, in order
    - Near-term / required
        - Containerize the trained model behind a serving endpoint (e.g. FastAPI) with Docker
        - Docker Compose to run the endpoint locally (and a UI container alongside it, if we build one)
        - UI is optional and TBD — decide framework/scope once the endpoint exists; not required for Phase 3 to be "done"
    - Future / stretch goal (not required)
        - GCP deployment: Terraform-provisioned infra, Cloud Run hosting the same Docker image
        - Revisit only after the local Docker deployment is working

# Monitoring
1. Performance monitoring
2. Drift MOnitoring
    - Try to keep this similar performance monitoring at Schwab
3. Retraining cadence and triggers
