#!/bin/bash

function repocheck() {
	GET_FAILED=false
	VALIDATE_FAILED=false
	FMT_FAILED=false
	
	for dir in $(find $PWD -type d)
	do
	  cd ${dir}
	  if compgen -G "*.tf" > /dev/null; then
	    echo "Checking ${dir}"
	
#	    terraform get > /dev/null
#	    if [[ "$?" != "0" ]]; then
#	      echo "Terraform get failed for ${dir}"
#	      GET_FAILED=true
#	    fi
	
	    terraform validate
	    if [[ "$?" != "0" ]]; then
	      echo "Terraform validate failed for ${dir}"
	      VALIDATE_FAILED=true
	    fi
	
	    FMT_RUN=$(terraform fmt)
	    if [[ "${FMT_RUN}" != "" ]]; then
	      echo "Terraform reformatted files in ${dir}"
	      echo "${dir} files: ${FMT_RUN/$'\n'/ }"
	      FMT_FAILED=true
	    fi
	  fi
	done
	
	if $GET_FAILED; then
	  echo "Terraform get failed!"
	  exit 1
	fi
	
	if $VALIDATE_FAILED; then
	  echo "Terraform validation failed!"
	  exit 1
	fi
	
	if $FMT_FAILED; then
	  echo "Terraform found files to re-format!"
	  exit 1
	fi
	
}

case "$1" in 
  "repocheck")
    repocheck
    ;;
  *)
    terraform $@
    ;;
esac

