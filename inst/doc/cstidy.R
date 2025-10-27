## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----echo=FALSE, include=FALSE------------------------------------------------
library(data.table)
library(magrittr)

## -----------------------------------------------------------------------------
d <- cstidy::generate_test_data()
cstidy::set_csfmt_rts_data_v2(d)

# Looking at the dataset
d[]

## -----------------------------------------------------------------------------
d <- cstidy::generate_test_data()[1:5]
cstidy::set_csfmt_rts_data_v2(d)

# Looking at the dataset
d[]

# Smart assignment of time columns (note how granularity_time, isoyear, isoyearweek, date all change)
d[1,isoyearweek := "2021-01"]
d

# Smart assignment of time columns (note how granularity_time, isoyear, isoyearweek, date all change)
d[2,isoyear := 2019]
d

# Smart assignment of time columns (note how granularity_time, isoyear, isoyearweek, date all change)
d[4:5,date := as.Date("2020-01-01")]
d

# Smart assignment fails when multiple time columns are set
d[1,c("isoyear","isoyearweek") := .(2021,"2021-01")]
d

# Smart assignment of geo columns
d[1,c("location_code") := .("norge")]
d

# Collapsing down to different levels, and healing the dataset 
# (so that it can be worked on further with regards to real time surveillance)
d[, .(deaths_n = sum(deaths_n), location_code = "norge"), keyby=.(granularity_time)] %>%
  cstidy::set_csfmt_rts_data_v2(create_unified_columns = FALSE) %>%
  print()

# Collapsing to different levels, and removing the class csfmt_rts_data_v2 because
# it is going to be used in new output/analyses
d[, .(deaths_n = sum(deaths_n), location_code = "norge"), keyby=.(granularity_time)] %>%
  cstidy::remove_class_csfmt_rts_data() %>%
  print()

## -----------------------------------------------------------------------------
cstidy::generate_test_data() %>%
  cstidy::set_csfmt_rts_data_v2() %>%
  summary()

## -----------------------------------------------------------------------------
cstidy::generate_test_data() %>%
  cstidy::set_csfmt_rts_data_v2() %>%
  cstidy::identify_data_structure("deaths_n") %>%
  plot()

