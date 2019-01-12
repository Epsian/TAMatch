
#### Setup ####
library(matchingR)
library(Rcpp)

#### Command Line Args ####

args = commandArgs(trailingOnly = TRUE)

ta_file = args[1]
i_file = args[2]

#### Data Load ####
ta_rank = read.csv(ta_file, header = TRUE, stringsAsFactors = FALSE)
course_rank = read.csv(i_file, header = TRUE, stringsAsFactors = FALSE)

# What courses are being offered? This MUST be in the same order as the google form
offered_courses = sort(c(course_rank$What.is.your.first.course., course_rank$What.is.your.second.course.))

#### TAs ####
# Clean Emails
ta_rank$Username = gsub("@.*$", "", ta_rank$Username)

# Clean Course Names
colnames(ta_rank) = c("Time", "Username", offered_courses)

# Turn strings to Numeric
ta_rank[ta_rank == "Preference 6"] = 1
ta_rank[ta_rank == "Preference 5"] = 2
ta_rank[ta_rank == "Preference 4"] = 3
ta_rank[ta_rank == "Preference 3"] = 4
ta_rank[ta_rank == "Preference 2"] = 5
ta_rank[ta_rank == "Preference 1"] = 6
ta_rank[ta_rank == "Can TA"] = 0
ta_rank[ta_rank == "Last Resort"] = -5
ta_rank[ta_rank == "Can Not TA"] = -999

# Make TA Key
ta_key = data.frame("TAs" = ta_rank$Username, id = 1:nrow(ta_rank), stringsAsFactors = FALSE)

#### Instructors ####
# Clean Emails
course_rank$Username = gsub("@.*$", "", course_rank$Username)

course_rank[course_rank == "6"] = 1
course_rank[course_rank == "5"] = 2
course_rank[course_rank == "4"] = 3
course_rank[course_rank == "3"] = 4
course_rank[course_rank == "2"] = 5
course_rank[course_rank == "1"] = 6

course_b1 = course_rank[, 3:(3+length(ta_key$TAs))]
colnames(course_b1) = c("course", ta_key$TAs)
course_b2 = course_rank[, (4+length(ta_key$TAs)):ncol(course_rank)]
colnames(course_b2) = c("course", ta_key$TAs)

course_picks = rbind(course_b1, course_b2)
course_picks = course_picks[!is.na(course_picks$course),]

course_picks[is.na(course_picks)] = -999

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
results = galeShapley.collegeAdmissions(studentUtils =  ta_matrix, collegeUtils =  course_matrix, slots = 3)

# Is this match optimal?
print("CHECK: Is this match optimal?")
galeShapley.checkStability(ta_matrix, course_matrix, results$matched.students, results$matched.colleges)

# Rename to make results readable
colnames(results$matched.colleges) = c("TA1", "TA2", "TA3")
row.names(results$matched.colleges) = offered_courses
results$matched.colleges[] = ta_key$TAs[match(results$matched.colleges, ta_key$id)]
unmatched_courses = table(results$unmatched.colleges)
names(unmatched_courses) = offered_courses

print("Unmatched students:")
results$unmatched.students

print("Unmatched courses:")
unmatched_courses

print("TA Matches:")
results$matched.colleges

