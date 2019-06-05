#!/usr/bin/env bash

#
# Scraping Script
# 
# @contributors: Simone Lampacrescia [PamposDev] <simo.lampac@gmail.com> (https://pamposdev.com)
# 
# @license: This code and contributions have 'MIT License'
#

# include config
. config.sh

declare tmp_file_name=""

main(){
	# get item name
	tmp_file_name=$1

	# check if cache folder exist
	check_cache_dir

	# call url page
	[[ $curl_enabled = true ]] && rb_curl || printf "${red}rb_curl not enabled${default_color}\n"

	check_temp_file
}

rb_curl(){
	local rb_url="$base_url/people/$redbubble_author/works/$tmp_file_name"
	printf "${l_yellow}${rb_url}${default_color}\n"
	# copy web page
	curl $rb_url > ${cache_dir}$tmp_file_name
}

check_cache_dir(){
	# check if cache folder exist
	[[ -d $cache_dir ]] && echo "cache folder already exist" || mkdir $cache_dir
}

create_scraping_file(){
	scraping_file_name="$cache_dir${scraper_file_prefix}${tmp_file_name}"
	# create scraped file and grep content that contain data using css class name 
	cat ${cache_dir}$tmp_file_name | grep -A4 'class=\"carousel_item\"' --group-separator=$grep_separator | tail +1 > $scraping_file_name
	# check if scraped file exist
	if [ -f $scraping_file_name ] 
	then 
		echo "$scraping_file_name created"
	else 
		echo "$scraping_file_name not exist"
	fi
}

check_temp_file(){
	local file_name="${cache_dir}${tmp_file_name}"
	# if file with web page content exist init scraping of this content and create other file with scraping output
	if [ -e $file_name ]; then
		# check if web page file is empty
		if [ $(wc -c "$file_name" | awk '{print $1}') -ne 0 ]; then
			echo "$file_name ready for scraping"
			create_scraping_file
		else
			echo "Empty file $file_name"
		fi
	else
		echo "$file_name not exist"
	fi
}

# get item name
main $1
