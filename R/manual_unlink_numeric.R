#' Remove a link from a neighbourhood list by index numbers
#'
#' @param cont A neighbourhood list of class "nb"
#' @param x Index number of one spatial unit to disconnect
#' @param y Index number of other spatial unit to disconnect
#'
#' @return A neighbourhood list of class "nb" with selected units disconnected
#' @export
#'
#' @examples
manual_unlink_numeric <- function(cont,x,y)
{
  class(cont) <- "list"

  x <- as.integer(x)
  y <- as.integer(y)

  if(x %in% cont[[y]])
  {
    cont[[x]] <- cont[[x]][cont[[x]] !=y] |>
      sort()
    cont[[y]] <- cont[[y]][cont[[y]] !=x] |>
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
