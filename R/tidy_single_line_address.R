#' Tidy a single line address
#'
#' Tidy a single line address ready for tokenising.
#'
#' @param df Database table
#' @param col Single line address column
#' @param remove_postcode If to remove the postcode. Default is FALSE
#'
#' @examples
#' @export
tidy_single_line_address <- function(df, col, remove_postcode = FALSE) {

  # Remove postcode from single line address if necessary (e.g. after last ",")
  if (remove_postcode) {
    df <- df %>%
      dplyr::mutate({{ col }} := REGEXP_REPLACE({{ col }}, "[,][^,]+$", ""))
  }

  # Prep the single line address for tokenisation
  df %>%
    dplyr::mutate(

      {{ col }} := trimws(REPLACE(REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(toupper({{ col }}),           # Uppercase
                                                                                                              "[,.();:#'']", " "),  # replace special characters with a single space
                                                                                                              "(\\d)(\\D)", "\\1 \\2"), # add a space between any digit followed by a non-digit (e.g. 1A becomes 1 A)
                                                                                                              "(\\D)(\\d)", "\\1 \\2"), # add a space between any non-digit followed by a digit (e.g. A1 becomes A 1)
                                                                                                              "&", " AND "),        # replace the ampersand character with the string "and"
                                                                                                              "( ){2,}", " "),      # replace any multiple spaces with a single space
                                                                                                              " - ", "-")           # remove any spaces around a hyphen
                                                                                                              )                     # Trim whitespace
    )
}
