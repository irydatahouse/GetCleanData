library(dplyr)

# --- merges data sets
train.set <- read.table("data/train/X_train.txt")
test.set <- read.table("data/test/X_test.txt")
x.set <- rbind(train.set, test.set)

train.set <- read.table("data/train/subject_train.txt")
test.set <- read.table("data/test/subject_test.txt")
subj.set <- rbind(train.set, test.set)

train.set <- read.table("data/train/y_train.txt")
test.set <- read.table("data/test/y_test.txt")
y.set <- rbind(train.set, test.set)

features <- read.table("data/features.txt")
extracted.cols <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])

x.set <- x.set[, extracted.cols]
names(x.set) <- features[extracted.cols, 2]
names(x.set) <- gsub("\\(|\\)", "", names(x.set))
names(x.set) <- tolower(names(x.set))

# --- to name the activities
act.labels <- read.table("data/activity_labels.txt")
act.labels[, 2] = gsub("_", "", tolower(as.character(act.labels[, 2])))
y.set[,1] = act.labels[y.set[,1], 2]
names(y.set) <- "activity"

names(subj.set) <- "subject"
clean.set <- cbind(subj.set, y.set, x.set)
write.table(clean.set, "data/clean_activities.txt")

# result dataset
sum.set <- aggregate(clean.set[names(x.set)],
                       by=clean.set[c("activity", "subject")], 
                       FUN=mean, simplify=TRUE)

write.table(sum.set, "resut_dataset.txt", row.names = FALSE)

