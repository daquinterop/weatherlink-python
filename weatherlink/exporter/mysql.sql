CREATE TABLE `weather_archive_record` (
    `record_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    -- date and time informaton used for display, summary period analysis, and rain event analysis
    `timestamp_weatherlink` bigint unsigned NOT NULL COMMENT 'The convoluted WeatherLink timestamp (see Python code for details)',
    `timestamp_station` datetime NOT NULL COMMENT 'The station-local date and time of the end of the archive record period (you must know station time zone for this to be useful)',
    `timestamp_utc` datetime NOT NULL COMMENT 'The UTC date and time of the end of the archive record period',
    `summary_year` year(4) NOT NULL COMMENT 'Which summary year this record belongs to, if any',
    `summary_month` tinyint unsigned NOT NULL COMMENT 'Which summary month this record belongs to, if any',
    `summary_day` tinyint unsigned NOT NULL COMMENT 'Which summary day this record belongs to, if any',
    -- averages and end-of-period values of actual, physical measurements
    `temperature_outside` decimal(4,1) NULL COMMENT 'The current outdoor temperature at the end of the archine period in ºF',
    `temperature_outside_low` decimal(4,1) NULL COMMENT 'The low outdoor temperature during the archive period in ºF',
    `temperature_outside_high` decimal(4,1) NULL COMMENT 'The high outdoor temperature during the archive period in ºF',
    `temperature_inside` decimal(4,1) NULL COMMENT 'The current indoor temperature at the end of the archive period in ºF',
    `humidity_outside` tinyint unsigned NULL COMMENT 'The current outdoor relative humidity at the end of the archive period in percents',
    `humidity_inside` tinyint unsigned NULL COMMENT 'The current indoor relative humidity at the end of the archive period in percents',
    `barometric_pressure` decimal(6,3) unsigned NULL COMMENT 'The current barometric pressure at the end of the archive period in inches of Hg',
    `wind_speed` smallint unsigned NULL COMMENT 'The prevailing wind speed at the end of the archive period in miles per hour',
    `wind_speed_direction` enum('N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW') NULL COMMENT 'The prevailing wind direction',
    `wind_speed_high` smallint unsigned NULL COMMENT 'The high (gust) wind speed during the archive period in miles per hour',
    `wind_speed_high_direction` enum('N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW') NULL COMMENT 'The high (gust) wind speed direction',
    `wind_run_distance_total` decimal(10,2) unsigned NULL COMMENT 'The total distance traversed by the wind during the archive period in miles',
    `rain_total` decimal(7,3) unsigned NULL COMMENT 'The total amount of rain that fell during the archive period in inches',
    `rain_rate_high` decimal(5,2) unsigned NULL COMMENT 'The highest rate of rain during the archive period in inches per hour',
    `rain_clicks` smallint unsigned NULL COMMENT 'The number of times the rain measurement clicked during the archive period',
    `rain_click_rate_high` smallint unsigned NULL COMMENT 'The highest rate of rain measurement clicks per hour during the archive period',
    `solar_radiation` smallint unsigned NULL COMMENT 'The current solar radiation at the end of the archive period in watts per square meter',
    `solar_radiation_high` smallint unsigned NULL COMMENT 'The high solar radiation during the archive period in watts per square meter',
    `uv_index` decimal(4,1) unsigned NULL COMMENT 'The current UV index at the end of the archive period in UV index numbers',
    `uv_index_high` decimal(4,1) unsigned NULL COMMENT 'The high UV index during the archive period in UV index numbers',
    `evapotranspiration` decimal(6,3) unsigned NULL COMMENT 'Amount of evapotranspiration during the past hour in inches (only has values on top-of-the-hour records)',
    -- calculated values derived from two or more physical measurements
    `temperature_wet_bulb` decimal(4,1) NULL COMMENT 'The current outdoor wet bulb temperature at the end of the archive period in ºF',
    `temperature_wet_bulb_low` decimal(4,1) NULL COMMENT 'The low outdoor wet bulb temperature during the archive period in ºF',
    `temperature_wet_bulb_high` decimal(4,1) NULL COMMENT 'The high outdoor wet bulb temperature during the archive period in ºF',
    `dew_point_outside` decimal(4,1) NULL COMMENT 'The current outdoor dew point temperature at the end of the archive period in ºF',
    `dew_point_outside_low` decimal(4,1) NULL COMMENT 'The low outdoor dew point temperature during the archive period in ºF',
    `dew_point_outside_high` decimal(4,1) NULL COMMENT 'The high outdoor dew point temperature during the archive period in ºF',
    `dew_point_inside` decimal(4,1) NULL COMMENT 'The current indoor dew point temperature at the end of the archive period in ºF',
    `heat_index_outside` decimal(4,1) NULL COMMENT 'The current outdoor heat index temperature at the end of the archive period in ºF',
    `heat_index_outside_low` decimal(4,1) NULL COMMENT 'The low outdoor heat index temperature during the archive period in ºF',
    `heat_index_outside_high` decimal(4,1) NULL COMMENT 'The high outdoor heat index temperature during the archive period in ºF',
    `heat_index_inside` decimal(4,1) NULL COMMENT 'The current indoor heat index temperature at the end of the archive period in ºF',
    `wind_chill` decimal(4,1) NULL COMMENT 'The current wind chill temperature at the end of the archive period in ºF',
    `wind_chill_low` decimal(4,1) NULL COMMENT 'The low wind chill temperature during the archive period in ºF',
    `wind_chill_high` decimal(4,1) NULL COMMENT 'The high wind chill temperature during the archive period in ºF',
    `thw_index` decimal(4,1) NULL COMMENT 'The current temperature-humidity-wind index temperature at the end of the archive period in ºF',
    `thw_index_low` decimal(4,1) NULL COMMENT 'The low temperature-humidity-wind index temperature during the archive period in ºF',
    `thw_index_high` decimal(4,1) NULL COMMENT 'The high temperature-humidity-wind index temperature during the archive period in ºF',
    `thsw_index` decimal(4,1) NULL COMMENT 'The current temperature-humidity-sun-wind index temperature at the end of the archive period in ºF',
    `thsw_index_low` decimal(4,1) NULL COMMENT 'The low temperature-humidity-sun-wind index temperature during the archive period in ºF',
    `thsw_index_high` decimal(4,1) NULL COMMENT 'The high temperature-humidity-sun-wind index temperature during the archive period in ºF',
    PRIMARY KEY (`record_id`),
    UNIQUE INDEX `g$exporter` (`timestamp_weatherlink`),
    INDEX `g$summary_analyzer` (`summary_year`, `summary_month`, `summary_day`),
    INDEX `g$rain_event_analyzer` (`timestamp_station`, `rain_total`, `rain_rate_high`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Stores archived raw measurements and calculations for small periods of time';

CREATE TABLE `weather_calculated_summary` (
    `summary_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    -- summary grouping information
    `summary_type` enum('DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY', 'ALL_TIME') NOT NULL COMMENT 'The summary type',
    `summary_year` year(4) NOT NULL COMMENT 'Which year this summary belongs to, if any (0 = null, necessary for unique index)',
    `summary_month` tinyint unsigned NOT NULL COMMENT 'Which month this summary belongs to, if any (0 = null, necessary for unique index)',
    `summary_week` tinyint unsigned NOT NULL COMMENT 'Which week this summary belongs to, if any (0 = null, necessary for unique index)',
    `summary_day` tinyint unsigned NOT NULL COMMENT 'Which day this summary belongs to, if any (0 = null, necessary for unique index)',
    -- averages, highs, lows, and totals of actual, physical measurements
    `temperature_outside_average` decimal(4,1) NULL COMMENT 'The average outdoor temperature during the summary period in ºF',
    `temperature_outside_low` decimal(4,1) NULL COMMENT 'The low outdoor temperature during the summary period in ºF',
    `temperature_outside_high` decimal(4,1) NULL COMMENT 'The high outdoor temperature during the summary period in ºF',
    `temperature_inside_average` decimal(4,1) NULL COMMENT 'The average indoor temperature during the summary period in ºF',
    `temperature_inside_low` decimal(4,1) NULL COMMENT 'The low indoor temperature during the summary period in ºF',
    `temperature_inside_high` decimal(4,1) NULL COMMENT 'The high indoor temperature during the summary period in ºF',
    `humidity_outside_average` tinyint unsigned NULL COMMENT 'The average outdoor relative humidity during the summary period in percents',
    `humidity_outside_low` tinyint unsigned NULL COMMENT 'The low outdoor relative humidity during the summary period in percents',
    `humidity_outside_high` tinyint unsigned NULL COMMENT 'The high outdoor relative humidity during the summary period in percents',
    `humidity_inside_average` tinyint unsigned NULL COMMENT 'The average indoor relative humidity during the summary period in percents',
    `humidity_inside_low` tinyint unsigned NULL COMMENT 'The low indoor relative humidity during the summary period in percents',
    `humidity_inside_high` tinyint unsigned NULL COMMENT 'The high indoor relative humidity during the summary period in percents',
    `barometric_pressure_average` decimal(6,3) unsigned NULL COMMENT 'The average barometric pressure during the summary period in inches of Hg',
    `barometric_pressure_low` decimal(6,3) unsigned NULL COMMENT 'The low barometric pressure during the summary period in inches of Hg',
    `barometric_pressure_high` decimal(6,3) unsigned NULL COMMENT 'The high barometric pressure during the summary period in inches of Hg',
    `wind_speed_average` smallint unsigned NULL COMMENT 'The average wind speed during the summary period in miles per hour',
    `wind_speed_high` smallint unsigned NULL COMMENT 'The high (gust) wind speed during the summary period in miles per hour',
    `wind_speed_high_direction` enum('N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW') NULL COMMENT 'The high (gust) wind speed direction',
    `wind_speed_high_10_minute_average` smallint unsigned NULL COMMENT 'The high (average) wind speed during the summary period in miles per hour',
    `wind_speed_high_10_minute_average_direction` enum('N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW') NULL COMMENT 'The high (average) wind speed direction',
    `wind_run_distance_total` decimal(10,2) unsigned NULL COMMENT 'The total distance traversed by the wind during the summary period in miles',
    `rain_total` decimal(7,3) unsigned NULL COMMENT 'The total amount of rain that fell during the summary period in inches',
    `rain_rate_high` decimal(5,2) unsigned NULL COMMENT 'The highest rate of rain during the summary period in inches per hour',
    `solar_radiation_average` smallint unsigned NULL COMMENT 'The average solar radiation during the summary period in watts per square meter',
    `solar_radiation_low` smallint unsigned NULL COMMENT 'The low solar radiation during the summary period in watts per square meter',
    `solar_radiation_high` smallint unsigned NULL COMMENT 'The high solar radiation during the summary period in watts per square meter',
    `uv_index_average` decimal(4,1) unsigned NULL COMMENT 'The average UV index during the summary period in UV index numbers',
    `uv_index_low` decimal(4,1) unsigned NULL COMMENT 'The low UV index during the summary period in UV index numbers',
    `uv_index_high` decimal(4,1) unsigned NULL COMMENT 'The high UV index during the summary period in UV index numbers',
    `evapotranspiration` decimal(6,3) unsigned NULL COMMENT 'Amount of evapotranspiration during the summary period in inches',
    -- averages, highs, lows, and totals of calculated values derived from two or more physical measurements
    `temperature_wet_bulb_average` decimal(4,1) NULL COMMENT 'The average outdoor wet bulb temperature during the summary period in ºF',
    `temperature_wet_bulb_low` decimal(4,1) NULL COMMENT 'The low outdoor wet bulb temperature during the summary period in ºF',
    `temperature_wet_bulb_high` decimal(4,1) NULL COMMENT 'The high outdoor wet bulb temperature during the summary period in ºF',
    `dew_point_outside_average` decimal(4,1) NULL COMMENT 'The average outdoor dew point temperature during the summary period in ºF',
    `dew_point_outside_low` decimal(4,1) NULL COMMENT 'The low outdoor dew point temperature during the summary period in ºF',
    `dew_point_outside_high` decimal(4,1) NULL COMMENT 'The high outdoor dew point temperature during the summary period in ºF',
    `dew_point_inside_average` decimal(4,1) NULL COMMENT 'The average indoor dew point temperature during the summary period in ºF',
    `dew_point_inside_low` decimal(4,1) NULL COMMENT 'The low indoor dew point temperature during the summary period in ºF',
    `dew_point_inside_high` decimal(4,1) NULL COMMENT 'The high indoor dew point temperature during the summary period in ºF',
    `heat_index_outside_average` decimal(4,1) NULL COMMENT 'The average outdoor heat index temperature during the summary period in ºF',
    `heat_index_outside_low` decimal(4,1) NULL COMMENT 'The low outdoor heat index temperature during the summary period in ºF',
    `heat_index_outside_high` decimal(4,1) NULL COMMENT 'The high outdoor heat index temperature during the summary period in ºF',
    `heat_index_inside_average` decimal(4,1) NULL COMMENT 'The average indoor heat index temperature during the summary period in ºF',
    `heat_index_inside_low` decimal(4,1) NULL COMMENT 'The low indoor heat index temperature during the summary period in ºF',
    `heat_index_inside_high` decimal(4,1) NULL COMMENT 'The high indoor heat index temperature during the summary period in ºF',
    `wind_chill_average` decimal(4,1) NULL COMMENT 'The average wind chill temperature during the summary period in ºF',
    `wind_chill_low` decimal(4,1) NULL COMMENT 'The low wind chill temperature during the summary period in ºF',
    `wind_chill_high` decimal(4,1) NULL COMMENT 'The high wind chill temperature during the summary period in ºF',
    `thw_index_average` decimal(4,1) NULL COMMENT 'The average temperature-humidity-wind index temperature during the summary period in ºF',
    `thw_index_low` decimal(4,1) NULL COMMENT 'The low temperature-humidity-wind index temperature during the summary period in ºF',
    `thw_index_high` decimal(4,1) NULL COMMENT 'The high temperature-humidity-wind index temperature during the summary period in ºF',
    `thsw_index_average` decimal(4,1) NULL COMMENT 'The average temperature-humidity-sun-wind index temperature during the summary period in ºF',
    `thsw_index_low` decimal(4,1) NULL COMMENT 'The low temperature-humidity-sun-wind index temperature during the summary period in ºF',
    `thsw_index_high` decimal(4,1) NULL COMMENT 'The high temperature-humidity-sun-wind index temperature during the summary period in ºF',
    `integrated_heating_degree_days` decimal(4,1) unsigned NULL COMMENT 'The total heating degree days for the summary period in ºF',
    `integrated_cooling_degree_days` decimal(4,1) unsigned NULL COMMENT 'The total cooling degree days for the summary period in ºF',
    PRIMARY KEY (`summary_id`),
    UNIQUE INDEX `g$summary_locator_day` (`summary_type`, `summary_year`, `summary_month`, `summary_day`, `summary_week`),
    INDEX `g$summary_locator_week` (`summary_type`, `summary_year`, `summary_week`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Stores daily, weekly, monthly, yearly, and all-time summaries';

CREATE TABLE `weather_rain_event` (
    `event_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `timestamp_start` datetime NOT NULL COMMENT 'The station-local date and time that the rain event started',
    `timestamp_end` datetime NULL COMMENT 'The station-local date and time that the rain event ended',
    `timestamp_rain_rate_high` datetime NOT NULL COMMENT 'The station-local date and time that the highest rain rate was recorded for this event',
    `rain_total` decimal(7,3) unsigned NOT NULL COMMENT 'The total amount of rain that fell during this rain event',
    `rain_rate_average` decimal(5,2) unsigned NULL COMMENT 'The average rain rate during this rain event',
    `rain_rate_high` decimal(5,2) unsigned NULL COMMENT 'The highest recorderd rain rate during this rain event',
    PRIMARY KEY (`event_id`),
    UNIQUE INDEX `g$display` (`timestamp_start`),
    INDEX `g$latest` (`timestamp_end`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Stores calculated rain event details';
