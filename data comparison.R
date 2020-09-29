library(tidyverse)

#######################################################################################  I  ### Load data----
path <- fs::path("","Volumes","Gillis_Research","Christelle Colin-Leitzinger", "mutation data comparison")
# 1.1.Load Demographics data -------------------------------------------------------------------------------------
Nancy_data <-
  read_csv(paste0(path, "/data/Nancys calls_.001to.45.csv")) %>% 
  rename(id_NoFilters = "Nancy_NoFilters")
Sam_data <-
  read_csv(paste0(path, "/data/Sams calls_.001to.45.csv")) %>% 
  rename(id_NoFilters = "Sam_NoFilters") %>% 
  mutate(id_NoFilters = str_remove(id_NoFilters, "chr"))

Nancy_data2 <-
  read_csv(paste0(path, "/data/Nancys calls_.001to.45[2].csv")) %>% 
  rename(id_NoFilters_position = "Nancy_NoFilters_position")
Sam_data2 <-
  read_csv(paste0(path, "/data/Sams calls_.001to.45[2].csv")) %>% 
  rename(id_NoFilters_position = "Sam_NoFilters_position")

#######################################################################################  II  ### Comparison----

full_data <- bind_rows(Nancy_data, Sam_data, .id = "Nancy1_Sam2")

commun_data <- full_data[duplicated(full_data$id_NoFilters),]
commum_id <- paste(commun_data$id_NoFilters, collapse = '|')

commun_data_both <- full_data[(grepl(commum_id, full_data$id_NoFilters)),]
wrongly_detected <- commun_data_both[264,]
commun_data_both <- commun_data_both[-264,] # remove row 264 which was not detected by duplicate
write_csv(commun_data_both, paste0(path, "/lists/Commun data.csv"))

single_data <- full_data[(!grepl(commum_id, full_data$id_NoFilters)),] %>% bind_rows(., wrongly_detected)

Nancy_single <- single_data %>% 
  filter(Nancy1_Sam2 == 1)
write_csv(Nancy_single, paste0(path, "/lists/Single data from Nancy.csv"))

Sam_single <- single_data %>% 
  filter(Nancy1_Sam2 == 2)
write_csv(Sam_single, paste0(path, "/lists/Single data from Sam.csv"))

#######################################################################################  II  ### Comparison 2----
Sam_data2 <- Sam_data2 %>% distinct(id_NoFilters_position, .keep_all = TRUE)

full_data <- bind_rows(Nancy_data2, Sam_data2, .id = "Nancy1_Sam2")

commun_data <- full_data[duplicated(full_data$id_NoFilters_position),]
commum_id <- paste(commun_data$id_NoFilters_position, collapse = '|')

commun_data_both <- full_data[(grepl(commum_id, full_data$id_NoFilters_position)),]
write_csv(commun_data_both, paste0(path, "/lists/Commun data 2.csv"))

single_data <- full_data[(!grepl(commum_id, full_data$id_NoFilters_position)),]

Nancy_single <- single_data %>% 
  filter(Nancy1_Sam2 == 1)
write_csv(Nancy_single, paste0(path, "/lists/Single data from Nancy 2.csv"))

Sam_single <- single_data %>% 
  filter(Nancy1_Sam2 == 2)
write_csv(Sam_single, paste0(path, "/lists/Single data from Sam 2.csv"))


