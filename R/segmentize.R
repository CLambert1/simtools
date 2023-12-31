# WARNING - Generated by {fusen} from dev/flat_simulate_survey.Rmd: do not edit by hand

### Segmentize transects
### 

#' Author: Auriane Virgili
#' @param coords numeric
#' @param from numeric
#' @param to numeric
#' @export
#' @rdname segmentize
CreateSegment <- function(coords, from, to) {
  distance <- 0
  coordsOut <- c()
  biggerThanFrom <- F
  for (i in 1:(nrow(coords) - 1)) {
    d <- sqrt((coords[i, 1] - coords[i + 1, 1])^2 + (coords[i, 2] - coords[i + 1, 2])^2)
    distance <- distance + d
    if (!biggerThanFrom && (distance > from)) {
      w <- 1 - (distance - from)/d
      x <- coords[i, 1] + w * (coords[i + 1, 1] - coords[i, 1])
      y <- coords[i, 2] + w * (coords[i + 1, 2] - coords[i, 2])
      coordsOut <- rbind(coordsOut, c(x, y))
      biggerThanFrom <- T
    }
    if (biggerThanFrom) {
      if (distance > to) {
        w <- 1 - (distance - to)/d
        x <- coords[i, 1] + w * (coords[i + 1, 1] - coords[i, 1])
        y <- coords[i, 2] + w * (coords[i + 1, 2] - coords[i, 2])
        coordsOut <- rbind(coordsOut, c(x, y))
        break
      }
      coordsOut <- rbind(coordsOut, c(coords[i + 1, 1], coords[i + 1, 2]))
    }
  }
  return(coordsOut)
}

#' 
#' @param coords numeric
#' @param length numeric
#' @param n.parts numeric
#' @export
#' @rdname segmentize
#'
CreateSegments <- function(coords, length = 0, n.parts = 0) {
  stopifnot((length > 0 || n.parts > 0))
  # calculate total length line
  total_length <- 0
  for (i in 1:(nrow(coords) - 1)) {
    d <- sqrt((coords[i, 1] - coords[i + 1, 1])^2 + (coords[i, 2] - coords[i + 1, 2])^2)
    total_length <- total_length + d
  }
  
  # calculate stationing of segments
  if (length > 0) {
    stationing <- c(seq(from = 0, to = total_length, by = length), total_length)
  } else {
    stationing <- c(seq(from = 0, to = total_length, length.out = n.parts), 
                    total_length)
  }
  
  # calculate segments and store the in list
  newlines <- list()
  for (i in 1:(length(stationing) - 1)) {
    newlines[[i]] <- CreateSegment(coords, stationing[i], stationing[i + 1])
  }
  return(newlines)
}

#' @param lst list
#' @export
#' @rdname segmentize
MergeLast <- function(lst) {
  l <- length(lst)
  lst[[l - 1]] <- rbind(lst[[l - 1]], lst[[l]])
  lst <- lst[1:(l - 1)]
  return(lst)
}

#' @param sl a spatial line object
#' @param length length to segmentize
#' @param n.parts number of parts to cut the transect into
#' @param merge.last should the last bit be merged with the previous one?
#'
#' @importFrom sp Lines
#' @importFrom sp Line
#' @importFrom sp SpatialLines
#' @export
#' @rdname segmentize
SegmentSpatialLines <- function(sl, length = 0, n.parts = 0, merge.last = FALSE) {
  stopifnot((length > 0 || n.parts > 0))
  id <- 0
  newlines <- list()
  sl <- as(sl, "SpatialLines")
  for (lines in sl@lines) {
    for (line in lines@Lines) {
      crds <- line@coords
      # create segments
      segments <- CreateSegments(coords = crds, length, n.parts)
      if (merge.last && length(segments) > 1) {
        # in case there is only one segment, merging would result into error
        segments <- MergeLast(segments)
      }
      # transform segments to lineslist for SpatialLines object
      for (segment in segments) {
        newlines <- c(newlines, sp::Lines(list(sp::Line(unlist(segment))), ID = as.character(id)))
        id <- id + 1
      }
    }
  }
  return(sp::SpatialLines(newlines))
}

#' @param segments a sf object
#'
#' @importFrom sf st_length st_union
#' 
#' @return a sf object
#' @export
#' @rdname segmentize
#' 
Merge <- function(segments) {
  
  n <- as.numeric(nrow(segments))
  
  if (n > 2 && as.numeric(sf::st_length(segments$geometry[n])) < 3000){
    
    corr <- segments[(n-1):n,] |> summarize(geometry = sf::st_union(geometry)) 
    
    segments_corr <- rbind(segments[1:(n-2),], corr)
    
    return(segments_corr)
    
  }
  
  else if (n == 2 && as.numeric(sf::st_length(segments$geometry[n])) < 3000){
    
    corr <- segments[(n-1):n,] |> summarize(geometry = sf::st_union(geometry)) 
    
    segments_corr <- corr
    
    return(segments_corr)
    
  }
  
  else {
    
    return(segments)
  }
  
} 
