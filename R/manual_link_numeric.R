#' Add an additional link to a neighbourhood list by index numbers
#'
#' @param cont A neighbourhood list of class "nb"
#' @param x Name of one spatial unit to connect
#' @param y Name of other spatial unit to connect
#'
#' @return A neighbourhood list of class "nb" with selected units connected
#' @export
#'
#' @examples
manual_link_numeric <- function(cont,x,y)
{
  class(cont) <- "list"

  x <- as.integer(x)
  y <- as.integer(y)

  if(x %in% cont[[y]])
  {
    class(cont) <- "nb"

    return(cont)
  }
  else
  {
  cont[[x]] <- sort(c(cont[[x]],y))
  cont[[y]] <- sort(c(cont[[y]],x))

  class(cont) <- "nb"

  return(cont)
  }
}
