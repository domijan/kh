#' Add an additional link to a neighbourhood list by name
#'
#' @param cont A neighbourhood list of class "nb"
#' @param x Name of one spatial unit to connect
#' @param y Name of other spatial unit to connect
#'
#' @return A neighbourhood list of class "nb" with selected units connected
#' @export
#'
#' @examples
manual_link_name <- function(cont,x,y)
{
  class(cont) <- "list"

  xnum <- which(names(cont)==x) |>
    as.integer()
  ynum <- which(names(cont)==y) |>
    as.integer()

  if(xnum %in% cont[[ynum]])
  {
    class(cont) <- "nb"

    return(cont)
  }
  else
  {
  cont[[xnum]] <- c(cont[[xnum]],ynum) |>
    sort()
  cont[[ynum]] <- c(cont[[ynum]],xnum) |>
    sort()

  class(cont) <- "nb"

  return(cont)
  }
}
