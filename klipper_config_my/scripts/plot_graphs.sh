#!/usr/bin/env bash
###################################
###### GRAPH PLOTTING SCRIPT ######
###################################
# Written by Frix_x#0161 #
# @version: 1.6




#################################################################################################################
RESULTS_FOLDER=~/printer_data/config/adxl_results # Path to the folder where storing the results files
SCRIPTS_FOLDER=~/printer_data/config/scripts # Path to the folder where the graph_vibrations.py is located
KLIPPER_FOLDER=~/klipper # Path of the klipper main folder
STORE_RESULTS=3 # Number of results to keep (older files are automatically cleaned). 0 to keep them indefinitely
#################################################################################################################


#####################################################################
################ !!! DO NOT EDIT BELOW THIS LINE !!! ################
#####################################################################

export LC_ALL=C

function is_fopen() {
  filepath=$(realpath "$1")
  for pid in $(ls /proc | grep -E '^[0-9]+$'); do
    if [ -d "/proc/$pid/fd" ]; then
      for fd in /proc/$pid/fd/*; do
        if [ -L "$fd" ] && [ "$(readlink -f "$fd")" == "$filepath" ]; then
          return 0
        fi
      done
    fi
  done
  return 1
}

function plot_shaper_graph {
  local generator filename newfilename date axis
  generator="${KLIPPER_FOLDER}/scripts/calibrate_shaper.py"

  # For each file
  while read filename; do
    # Wait for the file handler to be released by Klipper
    while is_fopen "${filename}"; do
      sleep 3
    done

    # We remove the /tmp in front of the filename
    newfilename="$(echo ${filename} | sed -e "s/\\/tmp\///")"

    # We check if there is the position added by Klipper and remove it
    if [[ ${newfilename} =~ ^resonances_[[:alpha:]]_([0-9]*\.)+[0-9]*_ ]]; then
      newfilename="$(echo ${newfilename} | sed -E 's/(^resonances_[[:alpha:]])_(([0-9]*\.)+[0-9]*_)+/\1_/')"
    fi

    # We extract the date and axis name from the filename
    date="$(basename "${newfilename}" | cut -d '.' -f1 | awk -F'_' '{print $3"_"$4}')"
    axis="$(basename "${newfilename}" | cut -d '_' -f2)"

    # Then we move the file to the result folder
    mv "${filename}" "${isf}"/inputshaper/"${newfilename}"
    sync && sleep 2

    # Finally we compute the shaper graphs
    "${generator}" "${isf}"/inputshaper/"${newfilename}" -o "${isf}"/inputshaper/resonances_"${axis}"_"${date}".png
  done <<< "$(find /tmp -type f -name "resonances_*.csv" 2>&1 | grep -v "Permission")"
}

function plot_belts_graph {
  local date_ext generator filename belt
  date_ext="$(date +%Y%m%d_%H%M%S)"
  generator="${KLIPPER_FOLDER}/scripts/graph_accelerometer.py"

  # For each file
  while read filename; do
    # Wait for the file handler to be released by Klipper
    while is_fopen "${filename}"; do
      sleep 3
    done

    # We extract the belt tested from the filename
    belt="$(basename "${filename}" | cut -d '_' -f4 | cut -d '.' -f1 | sed -e 's/\(.*\)/\U\1/')"

    # And we move it to the result folder while injecting the date and belt inside the filename
    mv "${filename}" "${isf}"/belts/belt_"${date_ext}"_"${belt}".csv
  done <<< "$(find /tmp -type f -name "raw_data_axis*.csv" 2>&1 | grep -v "Permission")"
  sync && sleep 2

  # Finally we compute the belts graph
  "${generator}" -c "${isf}"/belts/belt_"${date_ext}"_*.csv -o "${isf}"/belts/belts.png
#  "${generator}" -c "${isf}"/belts/belt_"${date_ext}"_*.csv -o "${isf}"/belts/belts_"${date_ext}".png
}

function plot_vibr_graph {
  local date_ext generator filename newfilename
  date_ext="$(date +%Y%m%d_%H%M%S)"
  generator="${SCRIPTS_FOLDER}/graph_vibrations.py"

  # For each file
  while read filename; do
    # Wait for the file handler to be released by Klipper
    while is_fopen "${filename}"; do
      sleep 3
    done

    # Cleanup of the filename and moving it in the result folder
    newfilename="$(echo ${filename} | sed -e "s/\\/tmp\/adxl345/vibr_${date_ext}/")"
    mv "${filename}" "${isf}"/vibrations/"${newfilename}"
  done <<< "$(find /tmp -type f -name "adxl345-*.csv" 2>&1 | grep -v "Permission")"
  sync && sleep 2

  # We compute the vibration graphs using all the csv files
  "${generator}" "${isf}"/vibrations/vibr_"${date_ext}"*.csv -o "${isf}"/vibrations/vibrations.png -a "$1" -k "${KLIPPER_FOLDER}"
#  "${generator}" "${isf}"/vibrations/vibr_"${date_ext}"*.csv -o "${isf}"/vibrations/vibrations_"${date_ext}".png -a "$1" -k "${KLIPPER_FOLDER}"
  # Finally we cleanup the folder by moving the csv files in an archive
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
