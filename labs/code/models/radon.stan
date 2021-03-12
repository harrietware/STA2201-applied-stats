//Stan model

data {
  int<lower=1> N;
  int<lower=1> J; // number of counties
  int<lower=1,upper=J> county[N]; // county membership
  vector[N] y;
  vector[N] x;
  vector[J] u;
}

parameters {
  real beta;
  real<lower=0> sigma_alpha;
  real<lower=0> sigma;
  real gamma0;
  real gamma1;
  vector[J] alpha;
}

model {
  vector[N] y_hat;
  vector[J] alpha_hat;
  
  for (i in 1:N)
    y_hat[i]=alpha[county[i]]+x[i]*beta;
  
  for(j in 1:J)
    alpha_hat[j]=gamma0+gamma1*u[j];
    
  //priors
  alpha ~ normal(alpha_hat,sigma_alpha);
  beta ~ normal(0,1);
  sigma ~ normal(0,1);
  sigma_alpha ~ normal(0,1);
  gamma0 ~ normal(0,1);
  gamma1 ~ normal(0,1);
  
  //likelihood
  y ~ normal(y_hat,sigma);
}

generated quantities {
  real y_rep; // replications from posterior predictive dist
  y_rep = normal_rng(alpha[county[2]]+x[2]*beta, sigma);
}
