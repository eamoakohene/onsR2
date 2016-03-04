
# ts_search_info <- function(code='mgsx', cs = '.btn--primary' ){
#     my_code <- code
#     my_css <- cs
#
#     my_url <- paste0('http://www.ons.gov.uk/search?q=',tolower(my_code))
#     my_page <- try(xml2::read_html(my_url),silent = T)
#
#     if(class(my_page)[1]=='try-error'){
#         cat('Error occurred why reading page. Exiting now ...')
#         return(NULL)
#     }
#
#
#     my_element <- rvest::html_nodes(my_page, my_css)
#     if(is.null(my_element)){ return(NULL) }
#
#     my_links <- rvest::html_attr(my_element, "href")
#     if(is.null(my_links)){ return(NULL) }
#
#     my_substr_start <- nchar('/generator?format=') + 1
#     my_substr_end <- my_substr_start +nchar('csv') - 1
#     my_link_csv <- my_links[ substr( my_links,my_substr_start, my_substr_end ) == 'csv' ]
#
#     return(my_link_csv[1])
# }


#onsR2::add_missing_codes()
