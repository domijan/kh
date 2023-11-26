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
