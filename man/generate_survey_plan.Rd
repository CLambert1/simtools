% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_survey_plan.R
\name{generate_survey_plan}
\alias{generate_survey_plan}
\title{Generate a transect survey design}
\usage{
generate_survey_plan(
  bbx_xmin,
  bbx_xmax,
  bbx_ymin,
  bbx_ymax,
  start_x,
  end_x,
  start_y,
  end_y,
  space_out_factor,
  type = "horizontal",
  segmentize = FALSE,
  merge_last_seg = FALSE,
  seg_length,
  buffer = FALSE,
  buffer_width
)
}
\arguments{
\item{bbx_xmin, bbx_xmax, bbx_ymin, bbx_ymax}{numeric. Limits of the bounding box the transects will be generated in}

\item{start_x, end_x}{numeric. Start and end x coordinates of the transects}

\item{start_y, end_y}{numeric. Start and end y coordinates of the transects}

\item{space_out_factor}{numeric. Number of space units between transects}

\item{type}{character. Either "horizontal" (the default) or "vertical}

\item{segmentize}{Boolean. If TRUE, the transects are cut in smaller segments. Default to FALSE.}

\item{merge_last_seg}{Boolean. Should the last segment of a transect be merged with the previous one? Default to FALSE}

\item{seg_length}{numeric. Segment length.}

\item{buffer}{Boolean. Should a buffer be drawn around transects or segments? If segmentize is TRUE, buffers are drawn around segments, if segmentize is FALSE, they are drawn around transects.}

\item{buffer_width}{numeric. Width of the buffer on each side of the segments or transects.}
}
\value{
A named list.
}
\description{
This function builds a simple transect design layout, consisting of parallel transects covering a given area in the virtual environment, spaced out by a given distance. The layout can either be horizontal (the default) or vertical. The transects can be segmentized to a given length, and transects or segments can be buffered.
}
\examples{
surv <- generate_survey_plan(bbx_xmin = 30, bbx_xmax = 65, bbx_ymin = 30, bbx_ymax = 65,
                             start_x = 34, end_x = 60, start_y = 34, end_y = 68,
                             space_out_factor = 2, segmentize = TRUE, seg_length = 1,
                             buffer = TRUE, buffer_width = 0.2)
par(mfrow = c(2,2), mar = c(2.5,2.5,4,0.5))
raster::plot(surv$bbx, axes = TRUE, main = "bounding box")
plot(sf::st_geometry(surv$transects), axes = TRUE, main = "transects")
plot(sf::st_geometry(surv$segments), axes = TRUE, main = "segments")
plot(sf::st_geometry(surv$buffered_segments), axes = TRUE, main = "buffered seg")
}
\seealso{
Other survey simulation functions: 
\code{\link{assign_flight_plan}()},
\code{\link{detection_process}()},
\code{\link{launch_survey_on_movement}()}
}
\concept{survey simulation functions}
