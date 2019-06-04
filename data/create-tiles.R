library(viridis)
library(furrr)
library(tictoc)
library(tidyverse)
plan(multiprocess, workers = 4)

# setup files
f_raw <- list.files("data", "tif$")
f_dl <- tolower(f_raw) %>% 
  paste0("migratory-optimization_", .) %>% 
  file.path("data", .)
f_tiles <- tolower(f_raw) %>% 
  paste0("mig-opt_", .) %>% 
  file.path("tiles", .)
f_color <- tolower(f_raw) %>% 
  paste0("mig-opt_color_", .) %>% 
  file.path("tiles", .)
f_raw <- file.path("data", f_raw)

# create tifs for download
str_glue("gdal_translate -ot Byte -a_nodata 0 -co COMPRESS=LZW ",
                "{f_raw} {f_dl}") %>% 
  future_walk(system)
zip("data/migratory-optimization.zip",
    c(f_dl, "data/readme.txt"))
unlink(f_dl)

# create tiles
# project
str_glue("gdalwarp -t_srs EPSG:3857 -r near -dstnodata 0 -ot Byte ",
         "-co TILED=YES -co COMPRESS=DEFLATE ",
         "{f_raw} {f_tiles}") %>% 
  future_walk(system)
# color
vals <- 1:52
plasma(length(vals)) %>% 
  col2rgb() %>% 
  t() %>% 
  cbind(vals, ., 255) %>% 
  rbind(c("nv", 0, 0, 0, 0)) %>% 
  data.frame() %>% 
  write_csv("tiles/colors_wk.txt", col_names = FALSE)
col2rgb("#CC4678") %>% 
  t() %>% 
  cbind(1, ., 255) %>% 
  rbind(c("nv", 0, 0, 0, 0)) %>% 
  data.frame() %>% 
  write_csv("tiles/colors_yr.txt", col_names = FALSE)
col_tbl <- if_else(str_detect(f_tiles, "wk"), "tiles/colors_wk.txt", 
                   "tiles/colors_yr.txt")
str_glue("gdaldem color-relief -alpha {f_tiles} {col_tbl} {f_color}") %>% 
  future_walk(system)
# tile
resamp <- if_else(str_detect(f_color, "wk"), "average", "near")
tile_dir <- str_remove(f_tiles, "\\.tif") %>% 
  str_replace("^tiles", "www")
tic()
str_glue("gdal2tiles.py -r {resamp} -a 0 -z '1-7' -w none ",
         "{f_color} {tile_dir}") %>% 
  future_walk(system)
toc()
unlink(f_color)
unlink(f_tiles)
unlink(list.files("tiles", "^colors", full.names = TRUE))
