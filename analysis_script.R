# install.packages("tidyverse")
#install.packages("directlabels")
library(tidyverse)
library(directlabels)

fvfm.data <-
  list.files(path = "./data/",pattern = "*.CSV",full.names=TRUE) %>% 
  map_df(~read_csv(.)) %>%
  as.data.frame()

head(fvfm.data)
fvfm.data$Date<- as.Date(fvfm.data$Date, "%b/%d/%Y") # %b is 3-letter month
names(fvfm.data)<- c("tree", "date", "time", "fo","fv","fm","fv.fm","fv.fo")
###load the treatments data
treatments <- read.csv("./treatments/treatment_assignments.csv")
fvfm.data<-merge(fvfm.data, treatments, by ="tree", all.x=TRUE)
head(fvfm.data)
levels(fvfm.data$treatment) #this shows us the levels of the factor "treatment". We want to reorder them.
levels(fvfm.data$treatment) <- c("intact", "girdle", "topclip") #reorders the factor "treatment"
levels(fvfm.data$rewater.at) <- c("control", "P40", "P60", "P80", "P90", "P100") #reorders the factor "rewater.at"

## All data
ggplot(fvfm.data, aes(x=date, y=fv/fm, group = tree)) +  #ggplot() adds a plot. x= xaxis, y=yaxis, group=how data are grouped together
  geom_line() + #adds a line between grouped observations (tree)
  geom_point() +  #adds points for each observation
  #  facet_wrap(~tree) + #can uncomment this line to see a separate plot for each tree
  geom_hline(yintercept=0.70, color = "red", linetype ="dashed") #adds a dashed hline (horizontal line) at 0.7 fv/fm


ggplot(fvfm.data, aes(x=date, y=fv/fm, group = tree)) + 
  geom_line() +
  geom_point() +
  geom_dl(aes(label = tree), method = list("last.points",cex = .8, hjust = 1.5)) +
  facet_wrap(treatment~rewater.at, ncol=6) +
  geom_hline(yintercept=c(0.85, 0.70), linetype = "dotted") +
  theme(axis.text.x = element_text(angle=45))

