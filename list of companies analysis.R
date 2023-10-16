install.packages("Rtools")
install.packages("Readxl")
install.packages("openxlsx")
library(readxl)
library(lubridate)
library(tidyverse)
library(rmarkdown)
library(readr)
library(stringr)
library(openxlsx)
#importing dataset

file_path <- "Ministry of Mining and energy/HC Tech team/MINERALS AND COMPANIES.xlsx"
sheet_name <- "Sheet2"
company_minerals <- read_excel(file_path, sheet= sheet_name)
View(company_minerals)

#removing address column
company_minerals_edit1 <- company_minerals %>%
                          select(-ADDRESS)

## cleaning names in holder column 

company_minerals_Holders_edit <- company_minerals_edit %>%
  mutate(HOLDER = case_when(
    grepl("Bua International|Bua International Limited|", HOLDER) ~ "B.U.A International Limited",
    grepl("Gamla Nigeria Ltd|Gamia Nigeria Ltd", HOLDER) ~ "Gamla Nigeria Limited",
    grepl("Gold Point Mines Limited", HOLDER) ~ "Goldpoint Mines Limited",
    grepl("Hay Bravo International LTD", HOLDER) ~ "Hay Bravo International Limited",
    grepl("Novic Resources Global Industries Nig Ltd|Novic Resources Global Industries Nig. Ltd", HOLDER) ~ "Novic Resources Global Industries Nig Limited",
    grepl("Oarie Mining Company Nig. Ltd", HOLDER) ~ "Oarie Mining Company Nigeria limited",
    grepl("Somak Industries Nigeria Limited", HOLDER) ~ "Somak Industries Nigeria Limited",
    grepl("The freedom Group Limited", HOLDER) ~ "The Freedom Group Limited",
    TRUE ~ HOLDER
  ))


                              
                     #finding out unique values
## for holder
unique_company <- company_minerals_Holders_edit%>%
  select(HOLDER)%>%
  filter(grepl("^b|^B", HOLDER))%>%
  arrange(HOLDER)%>%
  distinct()                         
## for state
unique_company <- company_minerals_Holders_edit%>%
  select(STATE)%>%
  distinct()

## for LGA
unique_company <- company_minerals_Holders_edit%>%
  select(LGA)%>%
  distinct()

unique_state <- company_minerals_Holders_edit%>%
  select(LGA)%>%
  filter(grepl("^A|^a", LGA))%>%
  arrange(LGA)%>%
  distinct()   

## cleaning names in state column 

company_minerals_Holders_edit <- company_minerals_Holders_edit %>%
  mutate(STATE = case_when(
    grepl("Edo|Ondo", STATE) ~ "Edo",
    grepl("Kogi", STATE) ~ "Edo",
    grepl("EDO|DEO|ED0", STATE) ~ "Edo",
    is.na(STATE) ~ "Edo",
    TRUE ~ STATE
  ))

              ##cleaning observations in LGA Column

###removing commas at the start and end of each observation in the column

company_minerals_Holders_edit <- company_minerals_Holders_edit %>%
  mutate(LGA = str_replace(LGA, "^,|,$", ""))

###splitting observations that have two LGAs in them
company_minerals_Holders_edit <- company_minerals_Holders_edit %>%
  separate_rows(LGA, sep = ",")

### capitalizing each word in the LGA column

company_minerals_Holders_edit <- company_minerals_Holders_edit %>%
  mutate(LGA = str_to_title(LGA))


unique_state <- company_minerals_Holders_edit1%>%
  select(LGA)%>%
#filter(grepl("^U|^u", LGA))%>%
  arrange(LGA)%>%
  distinct() 

company_minerals_Holders_edit1 <- company_minerals_Holders_edit %>%
  mutate(LGA = str_trim(LGA),
    LGA = case_when(
    grepl("Akoko Edo", LGA) ~ "Akoko-Edo",
    grepl("Akoko-Ed0", LGA) ~ "Akoko-Edo",
    grepl("Akoko-Edo Etsako East", LGA) ~ "Akoko-Edo, Etsako-East",
    grepl("Akoko-Edo Etsako West", LGA) ~ "Akoko-Edo, Etsako-West",
    grepl("Easn North East Igueben", LGA) ~ "Esan-North-East,Igueben",
    grepl("Esan North East|Esan North-East", LGA) ~ "Esan-North-East",
    grepl("^Esan-South|^Esan South", LGA) ~ "Esan-South-East",
    grepl("Esan West", LGA) ~ "Esan-West",
    grepl("Orhiomwon|Orhionwon", LGA) ~ "Orhionmwon",
    grepl("Ovia North East|Ovia North-East|0via North East", LGA) ~ "Ovia-North-East",
    grepl("Ovia South West", LGA) ~ "Ovia-South-West",
    grepl("Ovia South-East", LGA) ~ "Ovia-South-East",
    grepl("Owan East", LGA) ~ "Owan-East",
    grepl("Owan West", LGA) ~ "Owan-West",
    grepl("Uhunmwode|Uhumwonde", LGA) ~ "Uhunmwonde",
    grepl("Uhunmwonde Ikpoba Okha|Uhunmwonde    Ikpoba-Okha", LGA) ~ "Uhunmwonde,Ikpoba-Okha ",
    TRUE ~ LGA)
     )

company_minerals_Holders_edit1 <- company_minerals_Holders_edit1 %>%
  separate_rows(LGA, sep = ",")

company_minerals_Holders_edit1 <- company_minerals_Holders_edit1 %>%
  mutate(LGA= str_trim(LGA))

#Fixing Etsako East to Etsako-East
company_minerals_Holders_edit1 <- company_minerals_Holders_edit1 %>%
  mutate(LGA= str_replace(LGA,"Estako-East", "Etsako-East"))


company_minerals_Holders_edit1 <- company_minerals_Holders_edit1 %>%
  mutate(LGA= str_replace(LGA,"Estako East", "Etsako East"))

company_minerals_Holders_edit1 <- company_minerals_Holders_edit1 %>%
  mutate(LGA= str_replace(LGA,"Etsako East", "Etsako-East"))


company_minerals_Holders_edit1 <- company_minerals_Holders_edit1 %>%
  mutate(LGA= str_replace(LGA,"Estako-East", "Etsako-East"))

#Merging Estako West to Etsako-West
company_minerals_Holders_edit1 <- company_minerals_Holders_edit1 %>%
  mutate(LGA= str_replace(LGA,"Estako West", "Etsako West"))

company_minerals_Holders_edit1 <- company_minerals_Holders_edit1 %>%
  mutate(LGA= str_replace(LGA,"Etsako West", "Etsako-West"))


#Removing Ose LGA
company_minerals_Holders_edit <- company_minerals_Holders_edit1 
company_minerals_Holders_edit <- company_minerals_Holders_edit%>%
                                filter(LGA!= "Ose")

#checking if ose lga is still showing 
unique_state <- company_minerals_Holders_edit%>%
  select(LGA)%>%
  #filter(grepl("^U|^u", LGA))%>%
  arrange(LGA)%>%
  distinct()
company_minerals_Holders_edit_final <- company_minerals_Holders_edit %>%
  mutate(HOLDER = case_when(
    grepl("Bua International|Bua International Limited|B.U.A International Ltd", HOLDER) ~ "B.U.A International Limited",
    grepl("Gamla Nigeria Ltd|Gamia Nigeria Ltd", HOLDER) ~ "Gamla Nigeria Limited",
    grepl("Gold Point Mines Limited", HOLDER) ~ "Goldpoint Mines Limited",
    grepl("Hay Bravo International LTD", HOLDER) ~ "Hay Bravo International Limited",
    grepl("Novic Resources Global Industries Nig Ltd|Novic Resources Global Industries Nig. Ltd", HOLDER) ~ "Novic Resources Global Industries Nig Limited",
    grepl("Oarie Mining Company Nig. Ltd", HOLDER) ~ "Oarie Mining Company Nigeria limited",
    grepl("Somak Industries Nigeria Limited", HOLDER) ~ "Somak Industries Nigeria Limited",
    grepl("The freedom Group Limited", HOLDER) ~ "The Freedom Group Limited",
    TRUE ~ HOLDER
  ))

##cleaning observations in MINERALS Column

###removing commas at the start and end of each observation in the column

company_minerals_Holders_edit1 <- company_minerals_Holders_edit_final %>%
  mutate(MINERAL = str_replace(MINERAL, "^,|,$", ""))

###seperating the mineral column
company_minerals_Holders_edit1<- company_minerals_Holders_edit1%>%
                                  separate_rows(MINERAL, sep= ",")%>%
                                  mutate(MINERAL= str_to_sentence(MINERAL))
                                
                                


unique_company <- company_minerals_Holders_edit1%>%
  select(MINERAL)%>%
 # filter(grepl("^b|^B", HOLDER))%>%
  arrange(MINERAL)%>%
  distinct() 





#exporting to excel 
write.xlsx(company_minerals_Holders_edit_final, file = "cleaned_Minerals_and_Companies_Edo_State.xlsx", rowNames = FALSE)
getwd()
