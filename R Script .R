# ================================================================
# BEKK-VCC-GARCH MODELING ON VIETNAM STOCK INDEX (VNI) AND WTI OIL PRICES
# ================================================================

# STEP 1. Load Required Libraries
library(BEKKs)       # For BEKK GARCH estimation
library(xts)         # For time series handling
library(haven)       # For reading Stata (.dta) files
library(bmgarch)     # Bayesian MGARCH estimation
library(pastecs)     # Descriptive statistics
library(tseries)     # ADF Unit Root Test

# STEP 2. Import Data from Stata File
data <- read_dta("/Users/thieu/Desktop/Allmonthly-stock.dta")
View(data)

# STEP 3. Handle Missing Values
data_clean <- na.omit(data)
data_clean$date <- as.Date(data_clean$date)

# STEP 4. Declare Multivariate Time Series Objects
# → Both as xts (for visualization) and matrix (for modeling)
vniandoil_xts <- xts(data_clean[, c("VNI", "WTI")], order.by = data_clean$date)
vniandoil_dta <- as.matrix(data_clean[, c("VNI", "WTI")])
colnames(vniandoil_dta) <- c("VNI", "WTI")

# STEP 5. (Optional) Convert to Returns
# If needed: data_clean$VNI <- diff(log(data_clean$VNI)), etc.

# STEP 6. Descriptive Statistics
des_vnandoil <- stat.desc(vniandoil_dta, norm = TRUE)
print(des_vnandoil)

# STEP 7. Stationarity Testing (ADF)
# At Level I(0)
sta_vni <- adf.test(data_clean$VNI)
cat("ADF Test for VNI:\n"); print(sta_vni)

sta_wti <- adf.test(data_clean$WTI)
cat("ADF Test for WTI:\n"); print(sta_wti)

# STEP 7.1. Differencing Non-stationary Series (if needed)
d_wti <- diff(data_clean$WTI)
adfd_wti <- adf.test(d_wti[-1])  # Remove NA from first diff
cat("ADF Test for d(WTI):\n"); print(adfd_wti)

# STEP 8. Reconstruct Time Series at Appropriate Integration Order
VNI <- ts(data_clean$VNI, start = c(2001, 2), frequency = 12)     # Stationary at I(0)
dWTI <- ts(data_clean$dWTI, start = c(2010, 3), frequency = 12)   # First-differenced

# STEP 9. Combine Stationary Series for Modeling
dvnandoil_xts <- xts(data_clean[, c("VNI", "dWTI")], order.by = data_clean$date)
dvnandoil_matrix <- coredata(dvnandoil_xts)
colnames(dvnandoil_matrix) <- c("VNI", "dWTI")

# STEP 10. Estimate Bivariate BEKK(1,1) GARCH via Bayesian MGARCH
bekk_model <- bmgarch(
  data = dvnandoil_matrix,
  parameterization = "BEKK",
  P = 1,
  Q = 1,
  meanstructure = "constant",
  distribution = "Gaussian",
  iterations = 100,
  chains = 4
)

# STEP 11. Summarize and Diagnose Model Fit
summary(bekk_model)
model_fitt <- bekk_model$model_fit

# Plot MCMC Diagnostics
rstan::plot(model_fitt)
rstan::traceplot(model_fitt)
rstan::check_hmc_diagnostics(model_fitt)

# STEP 12. Retrieve and Visualize Fitted Values
fitted_values <- fitted(bekk_model)
print(fitted_values)

# STEP 13. Plot Variance-Covariance and Correlation Dynamics
plot(bekk_model, type = "var")
plot(bekk_model, type = "cor")

# STEP 14. Forecasting Conditional Volatility and Correlation
forecast_results <- forecast(bekk_model, ahead = 10)
print(forecast_results)

# Visualize Forecast Results
plot(forecast_results, type = "var")
plot(forecast_results, type = "cor")
