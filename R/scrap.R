#
# scrap_info <- function(uri='http://www.ons.gov.uk/search', css = '.btn--primary' ){
#     my_url <- uri
#     my_css <- css
#
#
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
#     return(my_element)
# }
#
#

