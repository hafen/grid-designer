# Draw a labeled reference map for a grid from open boundary data.
#
# Boundary sources that we use (all openly licensed):
# - Natural Earth (public domain), via the rnaturalearth package
# - geoBoundaries (CC BY / ODbL, see https://www.geoboundaries.org)
# - geo.api.gouv.fr for French administrative units (Licence Ouverte / Etalab)
#
# The map shows every unit in the grid, filled and labeled with the grid's
# code, so that someone can check the grid against the real geography.

library(sf)
library(ggplot2)

# shapes: an sf object of polygons
# shape_key: column in `shapes` that matches `grid_key` in the grid
# grid: the grid data frame
# grid_key: column in the grid used to join (usually "code" or "name")
# label: column in the grid used for the map labels
# context: optional sf object drawn in light grey behind the grid units
# source: text for the caption that credits the boundary data
ref_map <- function(shapes, shape_key, grid, grid_key = "code",
  label = "code", context = NULL, source = "", out = NULL,
  width = 8, height = 8, label_size = 3, xlim = NULL, ylim = NULL) {

  shapes <- sf::st_make_valid(shapes)
  shapes$.key <- shapes[[shape_key]]
  grid$.key <- grid[[grid_key]]
  missing <- setdiff(grid$.key, shapes$.key)
  if (length(missing) > 0)
    warning("No shape found for: ", paste(missing, collapse = ", "))

  # keep only the join key so grid columns cannot clash with shape columns
  grid$.label <- grid[[label]]
  units <- merge(shapes[, ".key"], grid[, c(".key", ".label")], by = ".key")
  # one feature per unit, so that each unit gets exactly one label
  if (anyDuplicated(units$.key))
    units <- stats::aggregate(units[, ".label"], by = list(.key = units$.key),
      FUN = function(x) x[1])
  pts <- suppressWarnings(sf::st_point_on_surface(units))
  xy <- sf::st_coordinates(pts)
  pts$x <- xy[, 1]
  pts$y <- xy[, 2]

  # xlim / ylim override the frame, for example to leave out remote islands
  bb <- sf::st_bbox(units)
  if (!is.null(xlim)) bb[c(1, 3)] <- xlim
  if (!is.null(ylim)) bb[c(2, 4)] <- ylim
  p <- ggplot()
  if (!is.null(context))
    p <- p + geom_sf(data = context, fill = "grey92", color = "grey75",
      linewidth = 0.2)
  p <- p +
    geom_sf(data = units, fill = "#c6dbef", color = "#2b5c8a",
      linewidth = 0.3) +
    ggrepel::geom_label_repel(data = sf::st_drop_geometry(pts),
      aes(x = x, y = y, label = .label),
      size = label_size, label.size = 0.15, label.padding = 0.15,
      min.segment.length = 0, max.overlaps = Inf, seed = 1) +
    coord_sf(xlim = bb[c(1, 3)], ylim = bb[c(2, 4)], expand = TRUE) +
    labs(caption = source) +
    theme_void() +
    theme(plot.background = element_rect(fill = "white", color = NA),
      plot.caption = element_text(size = 7, color = "grey40"))

  if (!is.null(out))
    ggsave(out, p, width = width, height = height, dpi = 110, bg = "white")
  invisible(p)
}
