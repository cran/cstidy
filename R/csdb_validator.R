#' Field types validator (csfmt_rts_data_v1)
#' An example (schema) validator of field_types used in csfmt_rts_data_v1
#' @param db_field_types db_field_types passed to schema
#' @returns Boolean, corresponding to where or not the validator is passed.
#' @export
csdb_validator_field_types_csfmt_rts_data_v1 <- function(db_field_types) {
  if (!inherits(db_field_types, "character")) {
    return(FALSE)
  }
  if (!length(db_field_types) >= 16) {
    return(FALSE)
  }
  if (!identical(
      db_field_types[1:16],
      c(
        "granularity_time" = "TEXT",
        "granularity_geo" = "TEXT",
        "country_iso3" = "TEXT",
        "location_code" = "TEXT",
        "border" = "INTEGER",
        "age" = "TEXT",
        "sex" = "TEXT",
        "isoyear" = "INTEGER",
        "isoweek" = "INTEGER",
        "isoyearweek" = "TEXT",
        "season" = "TEXT",
        "seasonweek" = "DOUBLE",
        "calyear" = "INTEGER",
        "calmonth" = "INTEGER",
        "calyearmonth" = "TEXT",
        "date" = "DATE"
      )
    )) {
    return(FALSE)
  }

  return(TRUE)
}

#' Field contents validator (csfmt_rts_data_v1)
#' An example (schema) validator of database data used in csfmt_rts_data_v1
#' @param data data passed to schema
#' @returns Boolean, corresponding to where or not the validator is passed.
#' @export
csdb_validator_field_contents_csfmt_rts_data_v1 <- function(data) {
  for (i in unique(data$granularity_time)) {
    if (sum(stringr::str_detect(
      i,
      c(
        "total",
        "isoyear",
        "calyear",
        "year",
        "season",
        "month",
        "isoweek",
        "week",
        "day",
        "hour",
        "minute",
        "^event"
      )
    )) == 0) {
      retval <- FALSE
      attr(retval, "var") <- "granularity_time"
      return(retval)
    }
  }

  if (sum(!unique(data$granularity_geo) %in% c(
    "nation",
    "region",
    "hospitaldistrict",
    "county",
    "municip",
    "wardoslo",
    "extrawardoslo",
    "wardbergen",
    "wardtrondheim",
    "wardstavanger",
    "missingwardoslo",
    "missingwardbergen",
    "missingwardtrondheim",
    "missingwardstavanger",
    "ward",
    "station",
    "baregion",
    "missingcounty",
    "missingmunicip",
    "notmainlandcounty",
    "notmainlandmunicip",
    "lab"
  )) > 0) {
    retval <- FALSE
    attr(retval, "var") <- "granularity_geo"
    return(retval)
  }

  if (sum(!unique(data$border) %in% c(
    "2020"
  )) > 0) {
    retval <- FALSE
    attr(retval, "var") <- "border"
    return(retval)
  }

  if (sum(!unique(data$sex) %in% c(
    "male",
    "female",
    "total"
  )) > 0) {
    retval <- FALSE
    attr(retval, "var") <- "sex"
    return(retval)
  }

  if (!inherits(data$date, "Date")) {
    retval <- FALSE
    attr(retval, "var") <- "date"
    return(retval)
  }

  return(TRUE)
}
