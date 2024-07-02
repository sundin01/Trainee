
# InfluxDB token for access of data
token <- "tu3zUeCazQobS4TrIIRftQS3Tr4xoZQoZaRf0Ve0iCrU4LZSY1jTS3laCJ_OjwJxWJ6WsKuwXN_tVV10R73hyg=="

# Create InfluxDB client
client <- InfluxDBClient$new(
  url = "https://influx.smcs.abilium.io",
  token = token,
  org = "abilium")

# Build the Flux query
flux_query <- paste0(
  'from(bucket: "smcs") |> ',
  'range(start: ', Sys.Date() - 1, ', stop: ', Sys.Date() + 1, ') |> ',
  'filter(fn: (r) => r["_measurement"] == "mqtt_consumer") |> ',
  'filter(fn: (r) => r["_field"] == "decoded_payload_temperature" or r["_field"] == "decoded_payload_humidity") |> ',
  'filter(fn: (r) => r["topic"] != "v3/dynamicventilation@ttn/devices/eui-f613c9feff19276a/up") |> ',
  'filter(fn: (r) => r["topic"] != "helium/eeea9617559b/rx") |> ',
  'pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value")')

# Execute the query
data_current <- client$query(flux_query)

tables <- bind_rows(data_current) |> #binding since better this way, tidy
  mutate(across(starts_with("_"), ~as.POSIXct(., format="%Y-%m-%dT%H:%M:%S%z")))|> #format time
  mutate(Code_grafana = name) #add code grafana for joining


n_distinct(tables$Code_grafana)

meta <- as.tibble(read_delim('../Trainee/data/Messnetz_Thun_Steffisburg_Uebersicht.csv', delim = ';'))

result <- inner_join(tables,meta, by = "Code_grafana",relationship = "many-to-many") |> #many to many since several code grafanas per entry sometimes
  mutate(time = round_date(time, unit = "10 minutes")) |> # round to 10minutes interval
  group_by(time, Log_NR) |> #group now to mean since some may have several
  summarize(temperature = mean(decoded_payload_temperature, na.rm = TRUE),
            humidity = mean(decoded_payload_humidity, na.rm = TRUE), .groups = "drop") |> #now summarize
  ungroup() |>#important for order
  arrange(Log_NR,time) #now can be arranged

