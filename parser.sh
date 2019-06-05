#!/usr/bin/env bash

#
# Parsing Script
# 
# @contributors: Simone Lampacrescia [PamposDev] <simo.lampac@gmail.com> (https://pamposdev.com)
# 
# @license: This code and contributions have 'MIT License'
#

# include config
. config.sh

declare file_title
declare file_content

# array that contain scraped items
declare -a contents
# array that contain parsed items
declare -a json_arr

main(){
	# date of parsing
	file_date="$(date +%Y-%m-%d)/"
	# get scraping file name and replace with parsing file name
	file_title="${1//${cache_dir}${scraper_file_prefix}/${parsed_dir}${file_date}${parsed_file_prefix}}"
	# get scraping file content
	file_content=$(<$1)

	# init parsing of file
	parse_file

	unset json_arr
	unset cont
	unset file_title
}

parse_file(){
	# create an array by split scraping file content using grep_separator
	contents=$(echo ${file_content} | sed "s/${grep_separator}/\\n${grep_separator}/g")
	IFS=$'\n'
	for item in ${contents[@]}; do
		# init parsing of items text
		parse_line "${item//${grep_separator}/}"
	done
	# print number of items parsed
	printf "${file_title}: ${l_magenta}${#json_arr[@]} items parsed${default_color}\n"

	unset file_content
	unset contents
	
	# create json of items parsed
	create_result_json
}

create_result_json(){
	# make json as string
	declare final_json="{\n\t\"items\":[\n"
	for item in ${json_arr[@]}; do
		final_json="${final_json}${item}"
	done
	final_json="${final_json}\t]\n}"
	final_json="${final_json//,\\n\\t]/\\n\\t]}"
	# save json as file
	save_json $final_json
}

save_json(){
	local parsed_file_name="${file_title}.json"
	local json_content=$1
	# if not exist create parsed folder
	if [[ ! -e $parsed_dir ]]; then
		mkdir "${parsed_dir}"
	fi

	# if not exist create folder named as date of parsing
	if [[ ! -e ${parsed_dir}${file_date} ]]; then
		mkdir "${parsed_dir}${file_date}"
	fi

	# save output json as file
	printf $json_content > $parsed_file_name

	# print successful result
	if [[ -e ${parsed_file_name} ]]; then
		echo -e "${parsed_file_name} ${l_magenta}created${default_color}"
	fi
}

parse_line(){
	# get item text content
	local line=$1
	
	# check if text is empty
	if [ "$line" != "" ]
	then 
		# parse data using regex
		local title=$(get_parsed_value ${line} ${key_title} ${regex_title})
		local href=${base_url}$(get_parsed_value ${line} ${key_href} ${regex_href})
		local src=$(get_parsed_value ${line} ${key_src} ${regex_src})
		
		# printf "%s\n" $title $href $src

		# create json object that contain all info
		json_object="\t\t{\n\t\t\t\"$key_title\": \"$title\", \n\t\t\t\"$key_href\": \"$href\", \n\t\t\t\"$key_src\": \"$src\"\n\t\t},\n"

		# add json object to json array
		json_arr+=( "$json_object" )
		
		# print number of items parsed
		echo -ne "${file_title}: ${l_yellow}${#json_arr[@]}${default_color} items parsed\033[0K\r"

		unset json_object
	fi
}

get_parsed_value(){
	# get func parameters
	local text=$1
	local key=$2
	local regex=$3
	# get key="value" by regex
	local value=$(echo $text | grep -P $regex -o)
	# delete key
	value="${value//${key}=/}"
	# return value without ""
	echo "${value//\"/}"
}

# get scraping file name
main $1