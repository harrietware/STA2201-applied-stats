//Stan model

data {
  int<lower=1> N;
  int<lower=1> pred_N;
  int<lower=1> C;
  int<lower=1> R; 
  int<lower=1,upper=C> country[N]; // country membership
  int<lower=1,upper=C> new_country[pred_N];
  int<lower=1,upper=R> new_region[pred_N];
  int<lower=1,upper=R> region[N];
  vector[N] y;
  vector[N] x1;
  vector[N] x2;
  vector[N] x3;
  vector[pred_N] new_x1;
  vector[pred_N] new_x2;
  vector[pred_N] new_x3;
}

parameters {
  vector[4] beta; 
  real<lower=0> sigma_y;
  
  real<lower=0> sigma_c;
  real<lower=0> sigma_r;
  vector[C] eta_c;
  vector[R] eta_r;
}

model {
  vector[N] y_hat;
  
  for (i in 1:N)
    y_hat[i]=beta[1]+eta_c[country[i]]+eta_r[region[i]]+x1[i]*beta[2]+
    x2[i]*beta[3]+x3[i]*beta[4];
  
  eta_c~normal(0,sigma_c);
  eta_r~normal(0,sigma_r);
    
  //priors
  beta ~ normal(0,1);
  sigma_c ~ normal(0,1);
  sigma_r ~ normal(0,1);
  sigma_y ~ normal(0,1);
  
  //likelihood
  y ~ normal(y_hat,sigma_y);
}

generated quantities {
  vector[pred_N] y_pred; // predictions from posterior predictive dist
    for (i in 1:pred_N)
    y_pred[i] = normal_rng(beta[1]+eta_c[new_country[i]]+eta_r[new_region[i]]+new_x1[i]*beta[2]+
    new_x2[i]*beta[3]+new_x3[i]*beta[4], sigma_y);
}
