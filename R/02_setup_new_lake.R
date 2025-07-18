library(AEME)
library(aemetools) # For working with AEME
library(sf) # For spatial data
library(tmap) # For mapping
library(ggplot2) # For plotting
tmap_mode("view") # Set tmap mode to interactive view model
tmap_options(basemap.server = "OpenStreetMap") # Set the basemap to OpenStreetMap

# AEME - lake ----
# Define the location of your lake,  (Lough Feeagh in Ireland)
lat <- 53.948
lon <- -9.575

# Convert the coordinates to a spatial object
coords <- data.frame(lat = lat, lon = lon) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326)

tm_shape(coords) +
  tm_dots(fill = "red", size = 2)

# Download the lake shapefile
# Query features in your web browser: https://www.openstreetmap.org/
library(osmdata)
osm_data <- opq(bbox = "Ireland") |>
  add_osm_feature(key = "name", value = "Lough Feeagh", value_exact = FALSE) |>
  osmdata_sf()

# Extract lake polygon
lake_shape <- osm_data$osm_multipolygons |>
  st_make_valid()
lake_shape

tm_shape(lake_shape) +
  tm_fill(fill = "blue", fill_alpha = 0.5) +
  tm_borders(col = "black")

# Set depth & area
depth <- 44 # Depth of the lake in metres
area <- lake_shape |>
  st_area() |> # Calculate the area of the lake
  units::set_units(m^2) |> # Set units to square metres
  as.numeric()
area

# Get the elevation of the lake
elevation <- 13 # Elevation of the lake in metres above sea level
elevation

# Define lake list
lake = list(
  name = "feeagh", # Use lowercase for lake name
  id = lake_shape$osm_id, # Use the OpenStreetMap ID for the lake
  latitude = lat,
  longitude = lon,
  elevation = elevation,
  depth = depth,
  area = area
)
lake


# AEME - time ----
# Define start and stop times
start <- "2020-01-01 00:00:00"
stop <- "2021-01-01 00:00:00"

time <- list(
  start = start,
  stop = stop
)


# AEME - input ----
# Get ERA5 meteorological data
# We will use the `aemetools` package to get the ERA5 data for this lake
# Years available are 1900-2021, so we will use 2020-2021 for this example.

# met <- get_era5_land_point_nz(lat = -36.8898, lon = 174.46898,
#                               years = 2019:2021)
vars <- c("MET_tmpair", "MET_humrel", "MET_wndspd", "MET_pprain",
          "MET_prsttn", "MET_radswd")
met <- get_era5_isimip_point(lat = lat, lon = lon, vars = vars,
                             years = 2020:2021)
summary(met)

# Light Extinction Coefficient
secchi_depth <- 1.7 # Secchi depth in metres
Kw <- 1.7 / secchi_depth # Light extinction coefficient in m^-1
Kw

# Generate a hypsograph
# Because Lake lake is volcanic in nature, we will use a volume development
# factor of 0.8. A volume development factor less than 1.5 indicates a concave
# hypsograph, which is typical of volcanic lakes.

hypsograph <- generate_hypsograph(max_depth = depth, surface_area = area,
                                  volume_development = 0.8, elev = elevation)

# Plot the hypsograph
ggplot(hypsograph, aes(x = area, y = depth)) +
  geom_line() +
  xlab("Area (m2)") +
  ylab("Elevation (m)") +
  theme_bw()

# However it is good practice to extend the hypsograph above the lake surface
# to account for water level fluctuations. We will extend the hypsograph by 2 m.
hypsograph <- generate_hypsograph(max_depth = depth, surface_area = area,
                                  volume_development = 0.8, elev = elevation,
                                  ext_elev = 2)

# Plot the hypsograph
ggplot(hypsograph, aes(x = area, y = depth)) +
  geom_line() +
  xlab("Area (m2)") +
  ylab("Elevation (m)") +
  theme_bw()

# Define input list
input = list(
  init_depth = depth, # Initial depth of the lake in metres
  hypsograph = hypsograph,
  meteo = met,
  use_lw = TRUE,
  Kw = Kw
)

# Construct AEME object ----
aeme <- aeme_constructor(lake = lake,
                         time = time,
                         input = input)
aeme # Print the AEME object to the console

# Model controls
# Get model controls
model_controls <- get_model_controls()
View(model_controls)

# Select models
model <- c("glm_aed", "gotm_wet")

# Path for model directory
path <- "aeme"

# Build ensemble
aeme <- build_aeme(aeme = aeme, model = model, model_controls = model_controls,
                   path = path)

print(aeme)

# Run the ensemble
aeme <- run_aeme(aeme = aeme, model = model, path = path)

# View the output
plot_output(aeme = aeme, model = model, var_sim = "HYD_temp")

plot_output(aeme = aeme, model = model, var_sim = "LKE_lvlwtr", facet = FALSE)

# Build the model with the biogeochemical model switched on
model_controls <- get_model_controls(use_bgc = TRUE)
aeme <- build_aeme(aeme = aeme, model = model, model_controls = model_controls,
                   path = path, use_bgc = TRUE)

# Run the ensemble
aeme <- run_aeme(aeme = aeme, model = model, path = path)

# View the output
plot_output(aeme = aeme, model = model, var_sim = "CHM_oxy") # Dissolved oxygen
plot_output(aeme = aeme, model = model, var_sim = "PHY_tchla") # Chlorophyll-a

