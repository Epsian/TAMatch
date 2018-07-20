
#### Setup ####
library(matchingR)

#### Data Load ####
ta_rank = read.csv("data/Grad Student TA Ranking Form.csv", header = TRUE, stringsAsFactors = FALSE)
course_rank = read.csv("data/Instructor TA Rank Form.csv", header = TRUE, stringsAsFactors = FALSE)

# What courses are being offered? This MUST be in the same order as the google form
offered_courses = c("101", "102", "103", "104", "105")

#### TAs ####
# Clean Emails
ta_rank$Username = gsub("@.*$", "", ta_rank$Username)

# Clean Course Names
colnames(ta_rank) = c("Time", "Username", offered_courses)

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
ta_key = data.frame("TAs" = ta_rank$Username, id = 1:nrow(ta_rank), stringsAsFactors = FALSE)

#### Instructors ####
# Clean Emails
course_rank$Username = gsub("@.*$", "", course_rank$Username)

course_b1 = course_rank[, 3:(3+length(ta_key$TAs))]
colnames(course_b1) = c("course", ta_key$TAs)
course_b2 = course_rank[, (4+length(ta_key$TAs)):ncol(course_rank)]
colnames(course_b2) = c("course", ta_key$TAs)

course_picks = rbind(course_b1, course_b2)
course_picks = course_picks[!is.na(course_picks$course),]

course_picks[is.na(course_picks)] = 999

#### Make Matrix ####
# TAs
ta_matrix = as.matrix(ta_rank[ , 3:ncol(ta_rank)])
storage.mode(ta_matrix) = "numeric"
row.names(ta_matrix) = ta_key$TAs
ta_matrix = t(ta_matrix)

# Instructor
course_matrix = as.matrix(course_picks[, -1])
storage.mode(course_matrix) = "numeric"
row.names(course_matrix) = offered_courses
course_matrix = t(course_matrix)

#### Match! ####
results = galeShapley.collegeAdmissions(studentUtils =  ta_matrix, collegeUtils =  course_matrix, slots = 3, studentOptimal = TRUE)

# Is this match optimal?
galeShapley.checkStability(ta_matrix, course_matrix, results$matched.students, results$matched.colleges)

# Rename to make readable
colnames(results$matched.colleges) = c("TA1", "TA2", "TA3")
row.names(results$matched.colleges) = offered_courses

results$matched.colleges[] = ta_key$TAs[match(results$matched.colleges, ta_key$id)]
results$matched.colleges


