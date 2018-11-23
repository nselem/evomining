
file=$1

cut -d'|' -f2,5 $file | while read line
	do 
	match="Not marked as GDH"
	genome=$(echo "${line}" | cut -d'|' -f1)

	g1=$genome
	g2=""
	g3=""

	# Constructing id
	if ! [[ "{$genome}" =~ [BGC] ]]
		then
		g1="$(echo "${genome}" | cut -d'.' -f1)_"
		g2="$(echo "${genome}" | cut -d'.' -f2)_"
		g3=$(echo "${genome}" | cut -d'.' -f3)
	fi

	if [[ "{$line}"=~glutamate ]]
		then

		##  NADP
		if [[ "{$line}" =~ NADP && ! "{$line}" =~ NAD_ ]] 
			then 
			match="NADP"
		fi
  
		##
		if [[ "{$line}" =~ NAD_ && ! "{$line}" =~ NADP ]] 
			then 
			match="NAD"
		fi 
 
		###
		if [[ "{$line}" =~ NADP &&  "{$line}" =~ NAD_ ]] 
			then 
			match="NADP y NAD"
		fi
		
		if [[ "{$line}" =~ related ]] 
			then 
			match="related to GDH"
		fi
	fi  

#	 [[ $line =~ 'NADP_' ]] && match="NADP" ; 
	echo $g1$g2$g3$'\t'$match$'\t'$line; 
	done
