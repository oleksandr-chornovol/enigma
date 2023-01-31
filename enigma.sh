#!/usr/bin/env bash
echo "Welcome to the Enigma!"
while true; do
  echo "0. Exit"
  echo "1. Create a file"
  echo "2. Read a file"
  echo "3. Encrypt a file"
  echo "4. Decrypt a file"
  echo "Enter an option:"

  read -r opt

  case "$opt" in
  0)
    echo "See you later!"
    break
    ;;
  1)
    echo "Enter the filename:"
    read -r fileName
    fileNameRegex='^[a-zA-Z]+\.[a-zA-Z]+$'
    if [[ "$fileName" =~ $fileNameRegex ]]; then
      echo "Enter a message:"
      read -r msg
      msgRegex='^[A-Z ]+$'
      if [[ "$msg" =~ $msgRegex ]]; then
        echo $msg >$fileName
        echo "The file was created successfully!"
      else
        echo "This is not a valid message!"
      fi
    else
      echo "File name can contain letters and dots only!"
    fi
    ;;
  2)
    echo "Enter the filename:"
    read -r fileName
    if test -f "$fileName"; then
      echo "File content:"
      cat $fileName
    else
      echo "File not found!"
    fi
    ;;
  3)
    echo "Enter the filename:"
    read -r fileName
    if test -f "$fileName"; then
      echo "Enter password:"
      read -r password
      openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$fileName" -out "$fileName.enc" -pass pass:"$password" &>/dev/null
      exit_code=$?
      if [[ $exit_code -eq 0 ]]; then
        echo "Success"
        rm $fileName
      else
        echo "Fail"
      fi
    else
      echo "File not found!"
    fi
    ;;
  4)
    echo "Enter the filename:"
    read -r fileName
    if test -f "$fileName"; then
      echo "Enter password:"
      read -r password
      openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$fileName" -out "${fileName%.enc}" -pass pass:"$password" &>/dev/null
      exit_code=$?
      if [[ $exit_code -eq 0 ]]; then
        echo "Success"
        rm $fileName
      else
        echo "Fail"
      fi
    else
      echo "File not found!"
    fi
    ;;
  *)
    echo "Invalid option!"
    ;;
  esac
done
