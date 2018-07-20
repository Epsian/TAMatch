
#### Setup ####
library(matchingR)

#### Data Load ####
ta_rank = read.csv("data/Grad Student TA Ranking Form.csv", header = TRUE, stringsAsFactors = FALSE)
course_rank = read.csv("data/Instructor TA Rank Form.csv", header = TRUE, stringsAsFactors = FALSE)

#### TAs ####
# Clean Emails
ta_rank$Username = gsub("@.*$", "", ta_rank$Username)

# Clean Course Names
colnames(ta_rank) = c("Time", "Username", "101", "102", "103", "104", "105")

# Turn strings to Numeric
ta_rank[ta_rank == "Preference 1"] = 1
ta_rank[ta_rank == "Preference 2"] = 2
ta_rank[ta_rank == "Preference 3"] = 3
ta_rank[ta_rank == "Preference 4"] = 4
ta_rank[ta_rank == "Preference 5"] = 5
ta_rank[ta_rank == "Preference 6"] = 6
ta_rank[ta_rank == "Can TA"] = 10
ta_rank[ta_rank == "Last Resort"] = 50
ta_rank[ta_rank == "Can Not TA"] = 99

# Make TA Key
ta_key = data.frame("TAs" = ta_rank$Username, id = 1:nrow(ta_rank))

#### Instructors ####
# Clean Emails
course_rank$Username = gsub("@.*$", "", course_rank$Username)

courses = course_rank[,3:5]
courses = unlist(courses)
courses = courses[!is.na(courses)]
courses = sort(courses)

#### Make Matrix ####
# TAs
ta_matrix = matrix(t(ta_rank[ , 3:7]), ncol = nrow(ta_key), nrow = length(courses))
colnames(ta_matrix) = ta_key$TAs
row.names(ta_matrix) = courses

# Instructor
c_matrix = matrix(NA, ncol = length(courses), nrow = nrow(ta_key))
colnames(c_matrix) = courses
row.names(c_matrix) = ta_key$TAs







# Make instructor/course matches
in_co = apply(course_rank, 1, function(x){
  courses = x[3:5]
  courses = courses[!is.na(courses)]
  combo = expand.grid(as.character(x[2]), courses, stringsAsFactors = FALSE)
  named = as.character(combo$Var2)
  names(named) = combo$Var1
})

in_co = unlist(in_co)

#### Make Matrix ####
ta_natrix = matrix


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


