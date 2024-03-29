# include <R.h>
# include <Rmath.h>



void kalmanLoopC(double *nlls, double *alpha, double *doobs, double *c1, double *c2, double *P, double *Q, double *H,  double *beta, double *irr, double *wtr, double *kz, double *dosat, int *nobs){
	int i;
	double a1, eta, Eff, z=0; // z has to be a double b/c kz is passed in as a double (for cases where it isn't 0)
	int ni=*nobs;
	for(i=1; i<ni; i++){

		if(kz[i-1] != z){ // if k.gas is 0, kz is 0

			a1 = *c1 * irr[i-1] + *c2 * log(wtr[i-1]) + kz[i-1] * dosat[i-1];

			*alpha = a1 / kz[i-1] + -exp(-1 * kz[i-1]) * a1 / kz[i-1] + beta[i-1] * (*alpha);


		} else { // if kz is 0, must use different equations to avoid /0

			*alpha = *alpha + *c1 * irr[i-1] + *c2 * log(wtr[i-1]);



		} // end if{}else{} for dealing with k.gas==0


		*P = pow(beta[i-1],2) * (*P) + *Q;
		eta = doobs[i] - *alpha;
		Eff = *P + *H;
		*alpha = *alpha + *P/Eff*eta;
		*P = *P - pow(*P,2)/Eff;

		nlls[i] = 0.5*log(2*M_PI) + 0.5*log(Eff) + 0.5*pow(eta,2)/Eff;
	}
}



// =============================================
// = Below is old code before dealing is kz==0 =
// =============================================

// void kalmanLoopC(double *nlls, double *alpha, double *doobs, double *c1, double *c2, double *P, double *Q, double *H,  double *beta, double *irr, double *wtr, double *kz, double *dosat, int *nobs){
// 	int i;
// 	double a1, eta, Eff;
// 	int ni=*nobs;
// 	for(i=1; i<ni; i++){
//
// 		a1 = *c1 * irr[i-1] + *c2 * log(wtr[i-1]) + kz[i-1] * dosat[i-1];
//
// 		*alpha = a1 / kz[i-1] + -exp(-1 * kz[i-1]) * a1 / kz[i-1] + beta[i-1] * (*alpha);
//
// 		*P = pow(beta[i-1],2) * (*P) + *Q;
// 		eta = doobs[i] - *alpha;
// 		Eff = *P + *H;
// 		*alpha = *alpha + *P/Eff*eta;
// 		*P = *P - pow(*P,2)/Eff;
//
// 		nlls[i] = 0.5*log(2*M_PI) + 0.5*log(Eff) + 0.5*pow(eta,2)/Eff;
// 	}
// }
