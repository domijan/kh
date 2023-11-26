#' Remove a link from a neighbourhood list by name
#'
#' @param cont A neighbourhood list of class "nb"
#' @param x Name of one spatial unit to disconnect
#' @param y Name of other spatial unit to disconnect
#'
#' @return A neighbourhood list of class "nb" with selected units disconnected
#' @export
#'
#' @examples
manual_unlink_name <- function(cont,x,y)
{
  class(cont) <- "list"

  xnum <- which(names(cont)==x) |>
    as.integer()
  ynum <- which(names(cont)==y) |>
    as.integer()

  if(xnum %in% cont[[ynum]])
  {
    cont[[xnum]] <- cont[[xnum]][cont[[xnum]] !=ynum] |>
      sort()
    cont[[ynum]] <- cont[[ynum]][cont[[ynum]] !=xnum] |>
      sort()

    class(cont) <- "nb"

    return(cont)
  }
  else
  {
    class(cont) <- "nb"

    return(cont)
  }
}
