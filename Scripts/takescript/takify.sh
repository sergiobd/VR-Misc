#!/bin/bash

#check if no arguments supplied
if [ $# -eq 0 ]
  then
    echo "No directory supplied, using current directory."
    dir=$(pwd)
else
	dir=$1
fi

copy_flag=$2

echo
echo "Input directory:"
echo "----------------" 
echo
echo " "$dir
echo
echo

outputDir=$dir"/../Takes"

echo "Output Directory:" 
echo "-----------------" 
echo " "$outputDir
echo


spheresDir=$(ls $dir)

echo
echo "Spheres:"
echo "--------"
echo

for sphere in $spheresDir
do
	echo " "$sphere
done

echo
echo
echo "Structure:"
echo "----------"
echo

ls $dir/*

echo
echo
echo "Integrity:"
echo "----------"

echo
echo "SPHERENUM  NUMCAMERAS  TAKES  NAME"
echo

#Check number of cameras - take integrity

meanCams=0
sphereCounter=0
for sphere in $spheresDir
do
	#echo $dir/$sphere
	numcams=$(ls -ld $dir/$sphere/*/ | wc -l )
	camDirs=$(ls -d $dir/$sphere/*/)
	TakesForAllCams=""

	meanCams=$(($meanCams+$numcams))
	#echo $meanCams
	for cam in $camDirs
	do
		#echo $cam
		numTakes=$(ls $cam/*.MP4| wc -l)
		TakesForAllCams=$TakesForAllCams$numTakes
		#echo $TakesForAllCams
	done

	echo $sphereCounter "  " $numcams "  " $TakesForAllCams "  " $sphere
	sphereCounter=$(($sphereCounter+1))
	
	# echo $sphereCounter
	echo
done

meanCams=$(($meanCams/$sphereCounter))
echo "It appears you have " $meanCams " cameras"
echo




# COPY FILES!!!


if [ "$copy_flag" == "c" ]
then
	
	#Check for output directory https://stackoverflow.com/questions/59838/check-if-a-directory-exists-in-a-shell-script
	while [ -d $outputDir ]
	do
		outputDir=$outputDir"-Copy"
		echo $outputDir "Already exists" 
	done

	mkdir $outputDir
	echo "Created output directory: " $outputDir
	echo

	sphereCounter=0
	for sphere in $spheresDir
	do
		#echo $dir/$sphere
		mkdir $outputDir"/"$sphere
		camDirs=$(ls -d $dir/$sphere/*/ | xargs -n 1 basename)

	
		for cam in $camDirs
		do
			# echo $dir
			# echo $cam
			# echo $sphere

			filenames=$(ls $dir/$sphere/$cam/*.MP4)

			#This can be problematic if your path has spaces!
			shortFilenames=$( ls $dir"/"$sphere"/"$cam/*.MP4 | xargs -n 1 basename) #https://stackoverflow.com/questions/8518750/to-show-only-file-name-without-the-entire-directory-path

			 #echo $shortFilenames
			#echo $filenames
			takeCounter=1
			for filename in $shortFilenames
			do			
				takeFolder=$outputDir/$sphere/"Take-"$takeCounter

				# echo $takeCounter
				# echo $outputDir
				# echo $sphere
				# echo $takeFolder

				if [ ! -d $takeFolder ];then
					mkdir $takeFolder
				fi
			
				#echo $shortFileName
				#echo $filename
				# Actually not using the prefix right now.
			 	outputFilename=$takeFolder"/"$sphere"_Take-"$takeCounter"_"$prefix"_"$cam"_"$filename
			 	inputFilename=$dir/$sphere/$cam/$filename
			 	echo "copying" $inputFilename " to " 
			 	echo $outputFilename
				echo

			 	cp $inputFilename $outputFilename

				# In case you want to do some processing on each file:
			 	#echo "ffmpeg -i $inputFilename -vf scale=1280:-1 $outputFilename"
			 	
			 	takeCounter=$(($takeCounter+1))
			done
		
		done
	 
		sphereCounter=$(($sphereCounter+1))
		#echo $sphereCounter
	
	done

fi #end of copy_flag


