#!/usr/bin/env bash

OPTION=$1
HOSTNAME=$(hostname)
DATE=$(date +%Y-%m-%d-%H-%M-%S)
REPORT_FILE="report-${HOSTNAME}-${DATE}.txt"
INTERESTING_FILES='.bash_history .bash_logout .bashrc .ssh known_hosts authorized_keys id_rsa id_rsa.pub authorized_keys2'
INTERESTING_PLACES='/var /tmp /dev/shm'
COMPRESSED_FILE_EXTENSIONS='.zip .tar .gz .rar'

# Function to print title
function title () 
{
  TITLE=$1
  echo -e "-----------------------------------------------------"
  echo -e "CHECKING FOR ${TITLE}..."
  echo -e "-----------------------------------------------------"
}

# Function to print end of check
function end () 
{
  echo -e "-----------------------------------------------------"
  echo -e ""
}

# Function to check file permissions
function check_permission () 
{
  PERMISSION=$1
  PERMISSION_TEXT=$2
  
  title "${PERMISSION_TEXT}"
  echo "${PERMISSION_TEXT} is ${PERMISSION}"
  find / -type f -perm "${PERMISSION}" -exec ls -ld {} \; 2>/dev/null 
  end
}

# Function to check world-writable directories
function check_writable_directories () 
{
  title "world-writable directories"
  find / -type d -perm -2 -exec ls -ld {} \; 2>/dev/null
  end
}

# Function to check for specific files
function check_file () 
{
  FILE_NAME=$1
  FILE_DESCRIPTION=$2
  title "${FILE_NAME} file"
  echo "${FILE_DESCRIPTION}"
  find / -name "${FILE_NAME}" -exec ls -ld {} \; 2>/dev/null
  end
}

# Function to check interesting files
function interesting_files () 
{
    local interesting_files=$1
    for FILE in ${interesting_files}
    do
        check_file "${FILE}" "Checking file: ${FILE}"
    done
}

# Function to check writable files in interesting places
function check_writable_files () 
{
    local interesting_places=$1
    
    title "writable files in interesting places: ${interesting_places}"
    for PLACE in ${interesting_places}
    do
        find "${PLACE}" -writable -printf '%p\n' 2>/dev/null
    done
    end
}

# Function to check for compressed files
function check_compressed_files () 
{
    local compressed_file_extensions=$1
    
    for EXT in ${compressed_file_extensions}
    do
        title "readable ${EXT} files"
        find / -type f -name "*${EXT}" -readable 2>/dev/null
        end
    done
}

# Function to check sudo privileges
function check_sudo () 
{
    title "sudo available commands"
    env sudo -l 2>/dev/null || echo "No sudo privileges found."
    end
}

# Function to check crontab content
function check_crontab () 
{
    title "crontab content"
    env crontab -l 2>/dev/null || echo "No crontab entries found."
    end
}

# Function to check active connections
function check_connections () 
{
    title "connections"
    env ss -tunapo 2>/dev/null
    end
}

# Function to check the process list
function check_process () 
{
    title "process list"
    env ps auxwwf
    end
}

# Option to save output to a report file
if [[ "${OPTION}" == "--save" ]]
then
  exec > >(tee "${REPORT_FILE}")
fi

# Performing various checks
check_permission "-u+s" "SUID executables"
check_permission "-g+s" "SGID executables"

check_writable_directories
interesting_files "${INTERESTING_FILES}"
check_writable_files "${INTERESTING_PLACES}"
check_compressed_files "${COMPRESSED_FILE_EXTENSIONS}"

check_sudo
check_crontab
check_connections 
check_process