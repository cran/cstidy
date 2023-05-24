## ----setup, include = FALSE---------------------------------------------------
if(isFALSE(getOption('knitr.in.progress'))){
  base_folder <- "vignettes/"
} else {
  base_folder <- ""
}

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----echo=FALSE, include=FALSE------------------------------------------------
library(data.table)
library(magrittr)
library(ggplot2)

## ----echo=FALSE, results='asis'-----------------------------------------------
d <- rbind(
  data.frame(
    granularity_time = "date",
    class = "Date",
    fn = "as.Date",
    example = "2021-12-31"
  ),
  data.frame(
    granularity_time = "isoweek (numeric)",
    class = "numeric",
    fn = "cstime::isoweek_n",
    example = "1"
  ),
  data.frame(
    granularity_time = "isoweek (character)",
    class = "character",
    fn = "cstime::isoweek_c",
    example = "\"01\""
  ),
  data.frame(
    granularity_time = "isoyear (numeric)",
    class = "character",
    fn = "cstime::isoyear_n",
    example = "2021"
  ),
  data.frame(
    granularity_time = "isoyear (character)",
    class = "character",
    fn = "cstime::isoyear_c",
    example = "\"2021\""
  ),
  data.frame(
    granularity_time = "isoyearweek",
    class = "character",
    fn = "cstime::isoyearweek_c",
    example = "\"2021-01\""
  ),
  data.frame(
    granularity_time = "event_*_date1_to_date2",
    class = "character",
    fn = "as.character",
    example = "\"event_covid19_norway_vaccination_2020_12_02_to_9999_09_09\", \"event_covid19_norway_2020_02_21_to_9999_09_09\""
  )
)

gt::gt(d) %>%
  gt::tab_options(
    table.width = "1100px"
  ) %>%
  gt::tab_header(title = "Valid times in the csverse format") %>%
  gt::cols_label(
    granularity_time = "Time (Granularity)",
    class = "Class",
    fn = "Function",
    example = "Example(s)"
  ) %>%
  gt::cols_width(
    granularity_time ~ "20%",
    class ~ "15%",
    fn ~ "20%",
    example ~ "55%"
  ) %>%
  gt::tab_style(
    style = list(
      gt::cell_text(decorate = "line-through")
    ),
    locations = gt::cells_body(
      columns = gt::everything(),
      rows = stringr::str_detect(granularity_time, "character")
    )
  ) %>%
  gt::tab_footnote(
    footnote = "isoweek (numeric) is used when it is a standalone variable.",
    locations = gt::cells_body(
      columns = granularity_time,
      rows = granularity_time == "isoweek (numeric)"
    )
  ) %>%
  gt::tab_footnote(
    footnote = "isoweek (character) is only used internally within isoyearweek. Internal use is demarcated by a line through the text.",
    locations = gt::cells_body(
      columns = granularity_time,
      rows = granularity_time == "isoweek (character)"
    )
  ) %>%
  gt::tab_footnote(
    footnote = "isoyear (numeric) is used when it is a standalone variable.",
    locations = gt::cells_body(
      columns = granularity_time,
      rows = granularity_time == "isoyear (numeric)"
    )
  ) %>%
  gt::tab_footnote(
    footnote = "isoyear (character) is only used internally within isoyearweek. Internal use is demarcated by a line through the text.",
    locations = gt::cells_body(
      columns = granularity_time,
      rows = granularity_time == "isoyear (character)"
    )
  ) %>%
  gt::tab_footnote(
    footnote = "If the event is ongoing, then the 'to' date should be 9999_09_09.",
    locations = gt::cells_body(
      columns = granularity_time,
      rows = stringr::str_detect(granularity_time, "event")
    )
  )

## ----echo=FALSE, results='asis'-----------------------------------------------
d <- rbind(
  data.frame(
    granularity_time = "event_covid19_norway_2020_02_21_to_9999_09_09",
    definition = "Covid-19 outbreak in Norway (on-going)."
  ),
  data.frame(
    granularity_time = "event_covid19_norway_vaccination_2020_12_02_to_9999_09_09",
    definition = "Covid-19 vaccination campaign in Norway (on-going)."
  )
)

gt::gt(d) %>%
  gt::tab_options(
    table.width = "750px"
  ) %>%
  gt::cols_width(
    granularity_time ~ "65%",
    definition ~ "35%"
  ) %>%
  gt::cols_align(
    align = "left"
  ) %>%
  gt::tab_header(title = "Approved events")

## ----echo=FALSE, results='asis'-----------------------------------------------
d <- csdata::nor_locations_names()[, .(
  n = .N,
  location_code = location_code[1],
  location_name = location_name[1],
  location_name_description_nb = location_name_description_nb[1],
  location_name_file_nb_utf = location_name_file_nb_utf[1],
  location_name_file_nb_ascii = location_name_file_nb_ascii[1]
),
by = .(granularity_geo)
]

gt::gt(d) %>%
  gt::tab_options(
    table.width = "1500px"
  ) %>%
  gt::tab_header(title = "Valid locations and location types in the csverse format") %>%
  gt::cols_label(
    granularity_geo = "Geo (Granularity)",
    n = "N"
  ) %>%
  # gt::cols_width(
  #   granularity_time ~ "20%",
  #   class ~ "15%",
  #   fn ~ "20%",
  #   example ~ "55%"
  # ) %>%
  gt::tab_spanner(
    label = "Examples",
    columns = c(location_code, location_name, location_name_description_nb, location_name_file_nb_utf, location_name_file_nb_ascii)
  ) %>%
  gt::tab_footnote(
    footnote = gt::md("**location_code**: Used a) **inside datasets** and b) in data **file names** for transfer of data/results between analytic systems. All values are unique."),
    locations = gt::cells_column_labels(
      columns = location_code
    )
  ) %>%
  gt::tab_footnote(
    footnote = gt::md("**location_name**: Used (rarely) **inside results** (figures, tables, documents). Can be confusing as some names are duplicated. Its rare usage is demarcated by a line through the text."),
    locations = gt::cells_column_labels(
      columns = location_name
    )
  ) %>%
  gt::tab_style(
    style = list(
      gt::cell_text(decorate = "line-through")
    ),
    locations = gt::cells_body(
      columns = location_name,
      rows = gt::everything()
    )
  ) %>%
  gt::tab_footnote(
    footnote = gt::md("**location_name_description_nb**: Used (frequently) **inside results** (figures, tables, documents). All values are unique."),
    locations = gt::cells_column_labels(
      columns = location_name_description_nb
    )
  ) %>%
  gt::tab_footnote(
    footnote = gt::md("**location_name_file_nb_utf**: Used (frequently) in the **file names** for results (figures, tables, documents). All values are unique."),
    locations = gt::cells_column_labels(
      columns = location_name_file_nb_utf
    )
  ) %>%
  gt::tab_footnote(
    footnote = gt::md("**location_name_file_nb_ascii**: Used (rarely) in the **file names** for results (figures, tables, documents). Used if file systems have problems with the Norwegian letters æøå. All values are unique."),
    locations = gt::cells_column_labels(
      columns = location_name_file_nb_ascii
    )
  ) %>%
  gt::tab_footnote(
    footnote = "Bo- og arbeidsmarkedsregioner. Housing and labor market regions.",
    locations = gt::cells_body(
      columns = granularity_geo,
      rows = granularity_geo == "baregion"
    )
  ) %>%
  gt::tab_footnote(
    footnote = "Mattilsynet-regioner. Food authority regions.",
    locations = gt::cells_body(
      columns = granularity_geo,
      rows = granularity_geo == "faregion"
    )
  )

## ----echo=FALSE, results='asis'-----------------------------------------------
d <- rbind(
  data.frame(
    value = "\"000\"",
    class = "character",
    definition = "One year age group (0 year olds)"
  ),
  data.frame(
    value = "\"079\"",
    class = "character",
    definition = "One year age group(79 year olds)"
  ),
  data.frame(
    value = "\"000_004\"",
    class = "character",
    definition = "Age span of 0-4 year olds"
  ),
  data.frame(
    value = "\"065p\"",
    class = "character",
    definition = "Age span of >=65 year olds"
  ),
  data.frame(
    value = "\"missing\"",
    class = "character",
    definition = "Missing/unknown"
  ),
  data.frame(
    value = "\"total\"",
    class = "character",
    definition = "Everyone"
  )
)

gt::gt(d) %>%
  gt::tab_header(title = "Valid ages in the csverse format") %>%
  gt::cols_label(
    value = "Value",
    definition = "Definition"
  )

## ----echo=FALSE, results='asis'-----------------------------------------------
d <- rbind(
  data.frame(
    value = "\"male\"",
    class = "character",
    definition = "Male"
  ),
  data.frame(
    value = "\"female\"",
    class = "character",
    definition = "Female"
  ),
  data.frame(
    value = "\"missing\"",
    class = "character",
    definition = "Missing/unknown"
  ),
  data.frame(
    value = "\"total\"",
    class = "character",
    definition = "Everyone"
  )
)

gt::gt(d) %>%
  gt::tab_header(title = "Valid sexes in the csverse format") %>%
  gt::cols_label(
    value = "Value",
    definition = "Definition"
  )

## ----echo=FALSE, results='asis'-----------------------------------------------
d <- rbind(
  data.frame(
    variable = "granularity_time",
    accepted_values = gt::html("\"date\", \"isoyearweek\", \"isoyear\", \"event_*_*_to_*\" (<a href='#time'>Time</a>)"),
    definition = "Granularity of time"
  ),
  data.frame(
    variable = "granularity_geo",
    accepted_values = paste0("\"", paste0(unique(csdata::nor_locations_names()$granularity_geo), collapse = "\", \""), "\""),
    definition = "Granularity of geography"
  ),
  data.frame(
    variable = "country_iso3",
    accepted_values = "\"nor\", \"den\", \"swe\", \"fin\"",
    definition = "ISO3 country code."
  ),
  data.frame(
    variable = "location_code",
    accepted_values = gt::html("\"norge\", \"countyXX\", \"municipXXXX\", ... (<a href='#location'>Location</a>)"),
    definition = "Location code"
  ),
  data.frame(
    variable = "border",
    accepted_values = "2020",
    definition = "The borders (kommunesammenslåing) that location_code represents"
  ),
  data.frame(
    variable = "age",
    accepted_values = gt::html("\"000\", \"001\", \"000_004\", \"065p\", \"total\", \"missing\", ... (<a href='#age'>Age</a>)"),
    definition = "Age in years"
  ),
  data.frame(
    variable = "sex",
    accepted_values = gt::html("\"male\", \"female\", \"total\", \"missing\" (<a href='#sex'>Sex</a>)"),
    definition = "Sex"
  ),
  data.frame(
    variable = "isoyear",
    accepted_values = "YYYY",
    definition = "Use function cstime::isoyear_n"
  ),
  data.frame(
    variable = "isoweek",
    accepted_values = "1, 2, ..., 53",
    definition = "Use functions cstime::*_to_isoweek_n"
  ),
  data.frame(
    variable = "isoyearweek",
    accepted_values = "\"YYYY-WW\"",
    definition = "Use function cstime::isoyearweek_c"
  ),
  data.frame(
    variable = "season",
    accepted_values = "\"YYYY/YYYY\"",
    definition = "Seasons start in week 30 and finish in week 29."
  ),
  data.frame(
    variable = "seasonweek",
    accepted_values = "1, 2, ..., 23, 23.5, 24, ..., 52",
    definition = "isoweek = 30 -> seasonweek = 1. isoweek = 52 -> seasonweek = 23. isoweek = 53 -> seasonweek = 23.5. isoweek = 1 -> seasonweek = 24. isoweek = 29 -> seasonweek = 52. This is used primarily for plotting/analysis reasons."
  ),
  data.frame(
    variable = "calyear",
    accepted_values = "..., 2020, 2021, ...",
    definition = "Calendar years."
  ),
  data.frame(
    variable = "calmonth",
    accepted_values = "1, 2, ..., 11, 12",
    definition = "Calendar months."
  ),
  data.frame(
    variable = "calyearmonth",
    accepted_values = "\"2021-M01\"",
    definition = ""
  ),
  data.frame(
    variable = "date",
    accepted_values = "YYYY-MM-DD",
    definition = "Always corresponds to the last date in the time period. E.g. if granularity_time=='isoweek' then date is the Sunday of that week. If granularity_time == 'event_*_date1_to_9999_09_09' then date is 9999-09-09"
  )
) %>%
  dplyr::mutate(
    accepted_values = purrr::map(accepted_values, ~ gt::html(as.character(.)))
  )

gt::gt(d) %>%
  gt::tab_options(
    table.width = "750px"
  ) %>%
  gt::cols_width(
    variable ~ "20%",
    accepted_values ~ "40%",
    definition ~ "40%"
  ) %>%
  gt::cols_align(
    align = "left"
  ) %>%
  gt::tab_header(title = "Unified columns (16) in the csverse format csfmt_rts_data_v1") %>%
  gt::cols_label(
    variable = "Variable",
    accepted_values = "Accepted values",
    definition = "Definition"
  )

## ----echo=FALSE, results='asis'-----------------------------------------------
d <- rbind(
  data.frame(
    x = "",
    examples = "deaths, consultations, cases",
    definition = "Simple."
  ),
  data.frame(
    x = "",
    examples = "deaths_registered, deaths_nowcasted, deaths_nowcasted_baseline",
    definition = "Slightly complex."
  ),
  data.frame(
    x = "",
    examples = "hospital_deaths, vax_administered_dose_1, vax_coverage_dose_1, msis_cases_testdate, msis_cases_regdate",
    definition = "Complex."
  ),
  data.frame(
    x = "",
    examples = "outcome, exposure, model",
    definition = "Generally used in conjunction with 'tag' (see 'Format')."
  ),
  data.frame(
    x = "",
    examples = "sum0_13",
    definition = "The sum of values for the given date and the previous 13 days. If granularity_time=='isoyearweek' and the given isoweek has full data, then it is the sum of values for the Sunday in the given isoweek and the previous 13 days. If granularity_time=='isoyearweek' and the given isoweek does not have full data, or granularity_time=='event_*_to_9999_09_09' (ongoing event), then it is the sum of values for the last day with data and the previous 13 days."
  ),
  data.frame(
    x = "",
    examples = "sum0_999999",
    definition = "The sum of all days with data."
  ),
  data.frame(
    x = "",
    examples = "daymean0_13",
    definition = "The mean of all the daily observations for the given date and the previous 13 days."
  ),
  data.frame(
    x = "",
    examples = "isoweekmean0_13",
    definition = "The mean of all the weekly observations for the given date and the previous 13 days (i.e. the last 2 weeks)."
  ),
  data.frame(
    x = "",
    examples = "predinterval_q02x5",
    definition = "Prediction interval for the baseline (2.5th quantile). 'x' is used to denominate a decimal point, so that we can differentiate between 100 (100x0) and 10.0 (10x0)."
  ),
  data.frame(
    x = "",
    examples = "credintervalobs_q02x5",
    definition = "Credibility interval for a new observation of data according to the baseline model (2.5th quantile)."
  ),
  data.frame(
    x = "",
    examples = "credintervalmean_q02x5",
    definition = "Credibility interval for the mean of the data according to the baseline model (2.5th quantile)."
  ),
  data.frame(
    x = "",
    examples = "*interval*_q50x0",
    definition = "Generally speaking, the 50th percentile is the expected value."
  ),
  data.frame(
    x = "",
    examples = "id/tag",
    definition = "Used when data is in long format, to indicate an id variable. Frequently combined with descriptions of 'outcome', 'exposure', 'model'. id is used for numeric columns. tag is used for character columns."
  ),
  data.frame(
    x = "",
    examples = "n",
    definition = "Numerical value"
  ),
  data.frame(
    x = "",
    examples = "pr1",
    definition = "Proportion (between 0 and 1)"
  ),
  data.frame(
    x = "",
    examples = "pr100",
    definition = "Percentage (between 0 and 100)"
  ),
  data.frame(
    x = "",
    examples = "pr100000, prX",
    definition = "Rate per X"
  ),
  data.frame(
    x = "",
    examples = "date",
    definition = "Date"
  ),
  data.frame(
    x = "",
    examples = "bool",
    definition = "TRUE/FALSE"
  ),
  data.frame(
    x = "",
    examples = "forecast",
    definition = "TRUE/FALSE. Only used when a column contains both forecasted and non-forecasted data."
  ),
  data.frame(
    x = "",
    examples = "censored",
    definition = "TRUE/FALSE"
  ),
  data.frame(
    x = "",
    examples = "status",
    definition = "Character."
  )
)

gt::gt(d) %>%
  gt::tab_options(
    table.width = "750px"
  ) %>%
  gt::cols_width(
    x ~ "5%",
    examples ~ "35%",
    definition ~ "60%"
  ) %>%
  gt::cols_align(
    align = "left"
  ) %>%
  gt::tab_header(title = "Context-specific columns in the csverse format csfmt_rts_data_v1") %>%
  gt::cols_label(
    x = "",
    examples = "Examples",
    definition = "Definition"
  ) %>%
  gt::tab_row_group(
    label = "Censored/Status (optional)",
    rows = 21:nrow(d)
  ) %>%
  gt::tab_row_group(
    label = "Forecast (optional)",
    rows = 20
  ) %>%
  gt::tab_row_group(
    label = "Format (mandatory)",
    rows = 13:19
  ) %>%
  gt::tab_row_group(
    label = "Statistics (optional)",
    rows = 9:12
  ) %>%
  gt::tab_row_group(
    label = "Time (optional)",
    rows = 5:8
  ) %>%
  gt::tab_row_group(
    label = "Description (mandatory)",
    rows = 1:4
  )

## -----------------------------------------------------------------------------
d <- cstidy::generate_test_data()[1:5]
cstidy::set_csfmt_rts_data_v1(d)

# Looking at the dataset
d[]

# Smart assignment of time columns (note how granularity_time, isoyear, isoyearweek, date all change)
d[1, isoyearweek := "2021-01"]
d

# Smart assignment of time columns (note how granularity_time, isoyear, isoyearweek, date all change)
d[2, isoyear := 2019]
d

# Smart assignment of time columns (note how granularity_time, isoyear, isoyearweek, date all change)
d[4:5, date := as.Date("2020-01-01")]
d

# Smart assignment fails when multiple time columns are set
d[1, c("isoyear", "isoyearweek") := .(2021, "2021-01")]
d

# Smart assignment of geo columns
d[1, c("location_code") := .("norge")]
d

# Collapsing down to different levels, and healing the dataset
# (so that it can be worked on further with regards to real time surveillance)
d[, .(deaths_n = sum(deaths_n), location_code = "norge"), keyby = .(granularity_time)] %>%
  cstidy::set_csfmt_rts_data_v1(create_unified_columns = TRUE) %>%
  print()

# Collapsing down to different levels, without healing the dataset and without
# removing the class csfmt_rts_data_v1 (this is uncommon)
d[, .(deaths_n = sum(deaths_n), location_code = "norge"), keyby = .(granularity_time)] %>%
  print()

# Collapsing to different levels, and removing the class csfmt_rts_data_v1 because
# it is going to be used in new output/analyses
d[, .(deaths_n = sum(deaths_n), location_code = "norge"), keyby = .(granularity_time)] %>%
  cstidy::remove_class_csfmt_rts_data() %>%
  print()

## -----------------------------------------------------------------------------
cstidy::generate_test_data() %>%
  cstidy::set_csfmt_rts_data_v1() %>%
  dplyr::filter(location_code == "county03") %>%
  cstidy::expand_time_to(max_isoyearweek = "2022-08") %>%
  print()

## -----------------------------------------------------------------------------
cstidy::generate_test_data() %>%
  cstidy::set_csfmt_rts_data_v1() %>%
  cstidy::unique_time_series()

## -----------------------------------------------------------------------------
cstidy::generate_test_data() %>%
  cstidy::set_csfmt_rts_data_v1() %>%
  summary()

## -----------------------------------------------------------------------------
cstidy::generate_test_data() %>%
  cstidy::set_csfmt_rts_data_v1() %>%
  cstidy::identify_data_structure("deaths_n") %>%
  plot()

## ----echo=FALSE, results='asis'-----------------------------------------------
d <- csdata::nor_locations_names()[, .(
  location_order = paste0("#", location_order),
  location_code,
  location_name_description_nb
)]

gt::gt(d) %>%
  gt::tab_options(
    table.width = "750px"
  ) %>%
  gt::tab_header(title = "Reference table of location_code and location_name_description_nb") %>%
  gt::cols_label(
    location_order = "#"
  )

