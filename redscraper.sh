#!/usr/bin/env bash

#
# Start Script
# 
# @contributors: Simone Lampacrescia [PamposDev] <simo.lampac@gmail.com> (https://pamposdev.com)
# 
# @license: This code and contributions have 'MIT License'
#

# include config
. config.sh

main(){
	# print base info
	printf "${redscaper_start}\n"

	# print user info
	printUserInfo

	# get redbubble items defined in user_config
	for item in "${redbubble_items[@]}"
	do
		init_scraping $item
	done

	# delete cache folder if enable in config
	[[ $delete_cache_dir = true ]] && rm -r $cache_dir || sleep 2s

	# finish
	printf "${red}DONE${default_color}"
}

init_scraping(){
	local item=$1
	echo -e "${l_magenta}Item: $item${default_color}"
	# init item scraping
	bash ./scraper.sh $item
	# init item parsing
	init_parsing $item
	echo -e "${l_yellow}Delay: ${delay}s${default_color}"
	sleep ${delay}s
	echo ""
}

init_parsing(){
	# scraped file name located in cache folder
	scraping_file_name="${cache_dir}${scraper_file_prefix}${1}"
	if [ -f $scraping_file_name ] 
	then 
		echo "$scraping_file_name ready for parsing"
		bash ./parser.sh $scraping_file_name
	else 
		echo "$scraping_file_name not exist"
	fi
}

printUserInfo(){
	printf "${l_magenta}RedBubble Author: ${redbubble_author}${default_color}\n"

	printf "${l_magenta}RedBubble items:${default_color}\n"
	printf "${l_magenta} - %s${default_color}\n" ${redbubble_items[@]}
	printf "\n"
}

main