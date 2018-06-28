
library(matchingR)

# set seed
set.seed(1)
# set number of students
nstudents = 1000
# set number of colleges
ncolleges = 400
# generate preferences
uStudents = matrix(runif(ncolleges*nstudents), nrow = ncolleges, ncol = nstudents)
uColleges = matrix(runif(nstudents*ncolleges), nrow = nstudents, ncol = ncolleges)
# student-optimal matching
results = galeShapley.collegeAdmissions(studentUtils =  uStudents, collegeUtils =  uColleges, slots = 2)
str(results)

galeShapley.checkStability(uStudents, uColleges, results$matched.students, results$matched.colleges)

#### TAs ####

TAs = c("Jared", "Savannah", "RJ", "Ori", "Elyssa", "Tanaya", "Abbey")
Courses = c("101", "102")
Key = data.frame("TAs" = TAs, id = 1:7)

TAPref = matrix(runif(2*7), nrow = 2, ncol = 7)
CoursePref = matrix(runif(7*2), nrow = 7, ncol = 2)

colnames(TAPref) = TAs
row.names(TAPref) = Courses

colnames(CoursePref) = Courses
row.names(CoursePref) = TAs

results = galeShapley.collegeAdmissions(studentUtils =  TAPref, collegeUtils =  CoursePref, slots = 3)

galeShapley.checkStability(TAPref, CoursePref, results$matched.students, results$matched.colleges)

colnames(results$matched.colleges) = c("TA1", "TA2", "TA3")
row.names(results$matched.colleges) = Courses

results$matched.colleges[] = TAs[match(results$matched.colleges, Key$id)]
results$matched.colleges


