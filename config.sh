#!/usr/bin/env bash

#
# Configuration Script
# 
# @contributors: Simone Lampacrescia [PamposDev] <simo.lampac@gmail.com> (https://pamposdev.com)
# 
# @license: This code and contributions have 'MIT License'
#

# include user config
. user_config.sh

# RedBubble base url
declare base_url="https://www.redbubble.com"

# delay of X seconds between items curl scraping (5 seconds is recommended value)
declare delay=5

# enable script to do curl for scraping, if not enabled scraping use old cached file in cache_dir folder
declare curl_enabled=true # true|false

# enable script to delete old cached file at the end of execution
declare delete_cache_dir=false # true|false

# separator in scraping output
declare grep_separator="-----------"

# scraping output file prefix name
declare scraper_file_prefix="scraping_"

# parsing output file prefix name
declare parsed_file_prefix="parsed_"

# cache folder name and position
declare cache_dir="./cache/"

# parsed result folder name and position
declare parsed_dir="./parsed/"

# item attributes key
declare key_title="title"
declare key_href="href"
declare key_src="src"

# item attributes key regex
declare regex_title="(${key_title}=\".*?\")"
declare regex_href="(${key_href}=\".*?\")"
declare regex_src="(${key_src}=\".*?\")"

# output print color string
declare red='\e[31m'
declare l_magenta='\e[95m'
declare l_yellow='\e[93m'
declare l_green='\e[92m'
declare default_color='\e[39m' # No Color

# script info
declare redscaper_version="1.0"
declare redscaper_author="PamposDev"
declare redscaper_start="${l_green}RedScraper Author: ${redscaper_author}\nRedScraper Version: ${redscaper_version}${default_color}\n"