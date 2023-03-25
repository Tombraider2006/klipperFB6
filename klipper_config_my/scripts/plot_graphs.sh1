#!/bin/bash
###################################
###### GRAPH PLOTTING SCRIPT ######
###################################
# Written by Frix_x#0161 #

# @version: 1.5




# CHANGELOG:

#   v1.6: fixed race condition that results from input shaper macros delayed writes to .csv raw data in /tmp.  Added dependency for "lsof" utility.

#   v1.5: fixed klipper unnexpected fail at the end of the execution, even if graphs were correctly generated (unicode decode error fixed)

#   v1.4: added the ~/klipper dir parameter to the call of graph_vibrations.py for a better user handling (in case user is not "pi")

#   v1.3: some documentation improvement regarding the line endings that needs to be LF for this file

	@@ -21,6 +22,7 @@

#            type 'wget -P ~/printer_data/config/scripts https://raw.githubusercontent.com/Frix-x/klipper-voron-V2/main/scripts/plot_graphs.sh'

#   2. Make it executable using SSH: type 'chmod +x ~/printer_data/config/scripts/plot_graphs.sh' (adjust the path if needed).

#   3. Be sure to have the gcode_shell_command.py Klipper extension installed (easiest way to install it is to use KIAUH in the Advanced section)

#   4. If it is not already installed on your system, be sure to install the utility "lsof" as well (e.g. "apt install lsof", etc)

#   4. Create a gcode_shell_command to be able to start it from a macro (see my shell_commands.cfg file)




# Usage:

	@@ -53,6 +55,13 @@ function plot_shaper_graph {

    newfilename="$(echo ${filename} | sed -e "s/\\/tmp\///")"

    date="$(basename "${newfilename}" | cut -d '.' -f1 | awk -F'_' '{print $3"_"$4}')"

    axis="$(basename "${newfilename}" | cut -d '_' -f2)"




    # Check if file is open

    while [ $(lsof | grep "${filename}" | wc -l) -ne 0 ]; do

      # Wait until file is closed

      sleep 1

    done




    mv "${filename}" "${isf}"/inputshaper/"${newfilename}"




    sync && sleep 2

	@@ -67,6 +76,13 @@ function plot_belts_graph {




  while read filename; do

    belt="$(basename "${filename}" | cut -d '_' -f4 | cut -d '.' -f1 | sed -e 's/\(.*\)/\U\1/')"




    # Check if file is open

    while [ $(lsof | grep "${filename}" | wc -l) -ne 0 ]; do

      # Wait until file is closed

      sleep 1

    done




    mv "${filename}" "${isf}"/belts/belt_"${date_ext}"_"${belt}".csv

  done <<< "$(find /tmp -type f -name "raw_data_axis*.csv" 2>&1 | grep -v "Permission")"




	@@ -81,6 +97,13 @@ function plot_vibr_graph {




  while read filename; do

    newfilename="$(echo ${filename} | sed -e "s/\\/tmp\/adxl345/vibr_${date_ext}/")"




    # Check if file is open

    while [ $(lsof | grep "${filename}" | wc -l) -ne 0 ]; do

      # Wait until file is closed

      sleep 1

    done




    mv "${filename}" "${isf}"/vibrations/"${newfilename}"

  done <<< "$(find /tmp -type f -name "adxl345-*.csv" 2>&1 | grep -v "Permission")"



  sync && sleep 2
  "${generator}" "${isf}"/vibrations/vibr_"${date_ext}"*.csv -o "${isf}"/vibrations/vibrations_"${date_ext}".png -a "$1" -k "${KLIPPER_FOLDER}"
  
  tar cfz "${isf}"/vibrations/vibrations_"${date_ext}".tar.gz "${isf}"/vibrations/vibr_"${date_ext}"*.csv
  rm "${isf}"/vibrations/vibr_"${date_ext}"*.csv
}

function clean_files {
  local filename keep1 keep2 old csv date
  keep1=$(( ${STORE_RESULTS} + 1 ))
  keep2=$(( ${STORE_RESULTS} * 2 + 1))

  while read filename; do
    if [ ! -z "${filename}" ]; then
      old+=("${filename}")
      csv="$(basename "${filename}" | cut -d '.' -f1)"
      old+=("${isf}"/inputshaper/"${csv}".csv)
    fi
  done <<< "$(find "${isf}"/inputshaper/ -type f -name '*.png' -printf '%T@ %p\n' | sort -k 1 -n -r | sed 's/^[^ ]* //' | tail -n +"${keep2}")"
  
  while read filename; do
    if [ ! -z "${filename}" ]; then
      old+=("${filename}")
      date="$(basename "${filename}" | cut -d '.' -f1 | awk -F'_' '{print $2"_"$3}')"
      old+=("${isf}"/belts/belt_"${date}"_A.csv)
      old+=("${isf}"/belts/belt_"${date}"_B.csv)
    fi
  done <<< "$(find "${isf}"/belts/ -type f -name '*.png' -printf '%T@ %p\n' | sort -k 1 -n -r | sed 's/^[^ ]* //' | tail -n +"${keep1}")"

  while read filename; do
    if [ ! -z "${filename}" ]; then
      old+=("${filename}")
      csv="$(basename "${filename}" | cut -d '.' -f1)"
      old+=("${isf}"/vibrations/"${csv}".tar.gz)
    fi
  done <<< "$(find "${isf}"/vibrations/ -type f -name '*.png' -printf '%T@ %p\n' | sort -k 1 -n -r | sed 's/^[^ ]* //' | tail -n +"${keep1}")"

  if [ "${#old[@]}" -ne 0 -a "${STORE_RESULTS}" -ne 0 ]; then
    for rmv in "${old[@]}"; do
      rm "${rmv}"
    done
  fi
}

#############################
### MAIN ####################
#############################

if [ ! -d "${RESULTS_FOLDER}/inputshaper" ]; then
  mkdir -p "${RESULTS_FOLDER}/inputshaper"
fi
if [ ! -d "${RESULTS_FOLDER}/belts" ]; then
  mkdir -p "${RESULTS_FOLDER}/belts"
fi
if [ ! -d "${RESULTS_FOLDER}/vibrations" ]; then
  mkdir -p "${RESULTS_FOLDER}/vibrations"
fi

isf="${RESULTS_FOLDER//\~/${HOME}}"

case ${1} in
  SHAPER|shaper)
    plot_shaper_graph
  ;;
  BELTS|belts)
    plot_belts_graph
  ;;
  VIBRATIONS|vibrations)
    plot_vibr_graph ${2}
  ;;
  *)
  echo -e "\nUsage:"
  echo -e "\t${0} SHAPER, BELTS or VIBRATIONS"
  echo -e "\t\tSHAPER\tGenerate input shaper diagram"
  echo -e "\t\tBELT\tGenerate belt tension diagram"
  echo -e "\t\tVIBRATIONS axis-name\tGenerate vibration response diagram\n"
  exit 1
esac

clean_files

echo "Graphs created. You will find the results in ${isf}"