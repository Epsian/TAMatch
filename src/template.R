#### Setup ####
library(matchingR)

#### Data Load ####
ta_rank = read.csv("data/Grad Student TA Ranking Form.csv", header = TRUE, stringsAsFactors = FALSE)
# course_rank = read.csv()

ta_rank = data.frame()
course_rank = read.csv()

#### Clean Course Names ####
ta_cor_names = colnames(ta_rank)
ta_cor_names = gsub("Course.Rankings..", "", ta_cor_names)
colnames(ta_rank) = ta_cor_names
rm(ta_cor_names)

#### TAs ####

tas = ta_rank$Username

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