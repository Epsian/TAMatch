# https://www.rdocumentation.org/packages/caseMatch/versions/1.0.7/topics/case.match

library(caseMatch)

data(EU)
mvars <- c("socialist","rgdpc","FHc","FHp","trade")
dropvars <- c("countryname","population")

## In this example, I subset to the first 40 obs. to cut run-time
out <- case.match(data=EU,
                  id.var="countryname",
                  design.type = "most similar",
                  leaveout.vars=dropvars,
                  distance="mahalanobis",
                  case.N=2, 
                  greedy.match = "pareto",
                  number.of.matches.to.return=10,
                  treatment.var="eu",
                  max.variance=TRUE)
out$cases

## Not run: 
# ## All cases:
# ## Find the best matches of EU to non-EU countries
# out <- case.match(data=EU, id.var="countryname", leaveout.vars=dropvars,
#              distance="mahalanobis", case.N=2, 
#              number.of.matches.to.return=10,
#              treatment.var="eu", max.variance=TRUE)
# out$cases
# 
# ## Find the best matches while downweighting political variables
# myvarweights <- c(1,1,.1,.1,.1)
# names(myvarweights) <- c("rgdpc","trade","FHp","FHc","socialist")
# myvarweights
# (case.match(data=EU, id.var="countryname", leaveout.vars=dropvars,
#              distance="mahalanobis", case.N=2, 
#              number.of.matches.to.return=10, treatment.var="eu",
#              max.variance=TRUE,varweights=myvarweights))$cases
# 
# ## Find the best non-EU matches for Germany
# tabGer <- case.match(data=EU, match.case="German Federal Republic", 
#              id.var="countryname",leaveout.vars=dropvars,
#              distance="mahalanobis", case.N=2, 
#              number.of.matches.to.return=10,max.variance=TRUE,
#              treatment.var="eu")
# ## End(Not run)