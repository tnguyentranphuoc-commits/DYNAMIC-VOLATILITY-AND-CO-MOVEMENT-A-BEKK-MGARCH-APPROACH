# DYNAMIC VOLATILITY AND CO-MOVEMENT: A BEKK-MGARCH APPROACH
🛠️ **Tech Stack**: R (bmgarch, BEKKs, xts, pastecs, rstan)

---

## (i). Overview

This project investigates the **dynamic interaction, volatility transmission, and co-movement** between the **Vietnam Stock Index (VNI)** and **West Texas Intermediate (WTI) crude oil prices** using a **bivariate BEKK-MGARCH model**.

Unlike correlation-based GARCH models (e.g., CCC or DCC), the **non-diagonal BEKK framework** explicitly models **time-varying conditional variances and covariances**, allowing for **directional volatility spillovers** between oil prices and the Vietnamese stock market. The model is estimated within a **Bayesian MCMC framework**, enabling robust inference despite limited sample size.

The central objective is to understand **how volatility shocks propagate across markets** and what these dynamics imply for **risk management and economic forecasting** in an emerging market context.

---

## (ii). Data Description

- **Vietnam Stock Index (VNI)**  
  - Monthly log returns  
  - Source: Investing.com  

- **West Texas Intermediate (WTI)**  
  - Monthly prices (USD), transformed to first differences  
  - Source: Investing.com  

- **Sample size**: 72 monthly observations  
- **Frequency**: Monthly  

All series are transformed to ensure **stationarity**, a prerequisite for BEKK-MGARCH estimation.

---

## (iii). Methodology

### 🔍 Pre-Estimation Diagnostics
- **Descriptive statistics** indicate non-normal, skewed, and leptokurtic distributions.
- **ADF tests** confirm:
  - VNI is stationary at level *(I(0))*.
  - WTI is non-stationary at level but stationary after first differencing *(I(1))*.
- These properties justify the use of **multivariate GARCH modeling**.

---

### 📈 BEKK-MGARCH Model
- **Mean structure**: Constant mean returns.
- **Variance structure**: BEKK(1,1), ensuring positive-definite covariance matrices.
- **Estimation**: Bayesian MCMC with multiple chains and convergence diagnostics.
- **Outputs**:
  - Time-varying conditional variances
  - Dynamic conditional covariances
  - Implied conditional correlations

**Purpose**:
- Capture **volatility clustering**
- Identify **volatility spillover effects**
- Examine **dynamic oil–stock market co-movement**

---

## (iv). Modeling Pipeline

```text
STEP 1: Import and clean monthly VNI and WTI data
→ STEP 2: Descriptive statistics and normality testing
→ STEP 3: Stationarity testing (ADF)
→ STEP 4: Data transformation for stationarity
→ STEP 5: BEKK-MGARCH(1,1) estimation via MCMC
→ STEP 6: Convergence diagnostics and posterior analysis
→ STEP 7: Conditional variance, correlation, and forecast visualization
```

## (v). Main Findings (Summary)

- The **conditional correlation between VNI and WTI** is **positive on average**, but **varies substantially over time**, indicating **unstable co-movement**.
- **Own-market volatility effects dominate**, while **cross-market volatility spillovers** are present but **asymmetric**.
- **Oil price uncertainty** contributes to **Vietnamese stock market risk**, particularly during periods of heightened volatility.
- Forecasted volatilities and correlations suggest **mean-reverting behavior** following large shocks.

---

## (vi). Economic Relevance

- Demonstrates that **oil price volatility** is a **non-negligible external risk factor** for Vietnam’s equity market.
- Highlights the importance of **time-varying risk dependence**, rather than static correlation assumptions.

**Relevant for:**
- **Portfolio risk management** in emerging markets
- **Energy price shock assessment**
- **Macroeconomic and financial forecasting**

---

## (vii). Repository Contents

- `/R_Script.R` – Full BEKK-MGARCH estimation and diagnostics pipeline  
- `/Methods and Results.pdf` – Detailed methodological explanation and empirical discussion  
- `/Dataset.dta` – Monthly VNI and WTI data  
- `/README.md` – Project documentation  

---

## (viii). Keywords

BEKK-GARCH · Volatility spillovers · Oil price shocks · Emerging markets · VNI · WTI · Financial risk


