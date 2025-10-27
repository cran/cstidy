# Version 2025.10.27

- Updating csfmt_rts_data_v2 to be in line with the newest cstime version 2025.10.13

# Version 2024.6.13

- Inclusion of season in csfmt_rts_data_v2

# Version 2023.12.28

- Inclusion of isoquarter and isoyearquarter in csfmt_rts_data_v2

# Version 2023.5.22

- CRAN Submission.

# Version 2023.5.16

- Removing `print.csfmt_rts_data_v1`.

# Version 2023.4.26

- `cstidy::set_csfmt_rts_data_v1` is now 1.5x faster due to using the upgraded `cstime` package that now uses binary searches. An 80 million row dataset is now processed in 2 minutes, instead of 3.

# Version 2023.4.25

- `cstidy::set_csfmt_rts_data_v1` is now 6x faster due to using the upgraded `cstime` package that now uses `csutil::apply_fn_via_hash_table`. An 80 million row dataset is now processed in 3 minutes, instead of 20.

# Version 2022.1.17

- Dataset norway_covid19_cases_by_time_location renamed to nor_covid19_cases_by_time_location_csfmt_rts_v1.
- Dataset norway_covid19_icu_and_hospitalization renamed to nor_covid19_icu_and_hospitalization_csfmt_rts_v1.

# Version 2022.5.31

- In csfmt_rts_v1, age now uses underscores instead of hyphens so that valid variable names are generated when converting to wide-format.

# Version 2022.5.25

- Dataset covid19_msis_cases_by_time_location renamed to norway_covid19_cases_by_time_location.
- In csfmt_rts_v1, the granularity_time for "an ongoing event" was changed from event_\*_9999_01_01 to event_\*_9999_09_09. This was done because isoyear for 9999-01-01 is 9998 (which is confusing), while isoyear for 9999-09-09 is 9999 (which makes sense).
- In csfmt_rts_v1, the missing value for sex and age was changed to "missing" instead of NA_character_. This was chosen because NA_character_ requires special manipulation functions (is.na) which makes post-processing of data less efficient for the end-user.
- In csfmt_rts_v1, cstidy::heal now works when granularity_time=='event_*'

# Version 2022.5.19

- Dataset covid19_msis_cases_by_time_location included, containing number of Covid19 cases from MSIS registry. The locations are for both national and county level. The percentage per 100.000 population is included. The time period is between 2020-02-21 and 2022-05-03 (data extracted on 2022-05-04).

# Version 2022.5.5

- Dataset norway_covid19_icu_and_hospitalization included, containing admissions to the ICU with a positive PCR test and number of new hospitalizations with Covid-19 as the primary cause between 2020-02-21 and 2022-05-03 (data extracted 2022-05-04).

# Version 2022.4.26

- save_cs, read_cs functions to save/read data efficiently, allowing passwordless encryption.

# Version 2022.4.22

- print.csfmt_rts_data_v1 now automatically rounds numerics to 4 decimal places

# Version 2022.4.7

- unique_time_series function added.
