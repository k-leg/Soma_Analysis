
# Script to add a sex column to df from quarto workflow
library(tidyverse)

patient_vec <- c("01003", "01005", "01006", 
             "01008", "01009", "01010",
             "01013", "01014","01016", "01017", 
             "01018", "01019","01020", 
             "02001","02002", "02003",
             "03001", "03002", "03003",
             "03004", "04001","04002",
             "06001","06002", "06005")

sex_vec <- c("M","M","F",
             "M","F","M",
             "F","F","M","M",
             "M","M","F",
             "M","F","F",
             "F","M","F",
             "M","M","M",
             "M","F","M")

ota_vec <-c("42A","42A","42C",
            "42B","42A","42A",
            "42A","42B","42A","43C",
            "42C","42A","43A",
            "42B","42B","42C",
            "42B","42C","42A",
            "42A","42C","42A",
            "42A","42A","42A")

age_vec <- c(55,56,48,
             23,32,37,
             65,69,46,29,
             85,53,66,
             31,36,42,
             23,46,57,
             23,34,46,
             30,24,39)

ga_vec <- c(2,3,2,
            1,1,2,
            1,1,1,3,
            3,2,1,
            2,3,2,
            2,3,2,
            2,3,2,
            3,3,2)

sex_tib <- tibble(patient_vec, sex_vec, ota_vec, age_vec, ga_vec)

sex_tib$sex_vec <- factor(sex_tib$sex_vec)
sex_tib$ota_vec <- factor(sex_tib$ota_vec)
sex_tib$ga_vec <- factor(sex_tib$ga_vec)

sex_tib <- rename(sex_tib, SubjectID = patient_vec,
                  sex = sex_vec, age = age_vec, ota = ota_vec, ga = ga_vec)
