# Takify
This script allows to copy the files from a multi-cam shot (usually from a 360 video rig) into a folder structure organized by takes (and not by cameras). 

##  Input structure
Your input should be a folder organized by shot names (which I am calling "spheres" in the script), and then by cameras:

```
- ProjectName
  \_ ShotName1
	 \_ Cam1
		\_Filename_1_1.MP4
		 _Filename_1_2.MP4
		 _Filename_1_3.MP4
		Cam2
		\_Filename_2_1.MP4
		 _Filename_2_2.MP4
		 _Filename_2_3.MP4
		Cam3
		  ...
   \_ ShotName2
	 ...
```

## Output structure
If you set the copy flag, which you should do only after checking take integrity (see usage below), the script will make a copy of your files into a folder structured by *takes*, which is more convenient for stitching or processing. The output structure will be as follows:

```
-Takes
	\_ ShotName1
		\_ Take1
		 	\_ShotName1-Take1-Cam1-Filename_1_1.MP4
			 _ShotName1-Take1-Cam2-Filename_2_1.MP4
			 _ShotName1-Take1-Cam3-Filename_3_1.MP4
			Take2
		 	\_ShotName1-Take1-Cam1-Filename_1_1.MP4
			 _ShotName1-Take1-Cam2-Filename_2_1.MP4
			 _ShotName1-Take1-Cam3-Filename_3_1.MP4
			  ...
	   \_ ShotName2
		 ...
```

## Usage
### Check integrity

`./takify.sh <InputFolder>`

In this usage, the script will make a summary of your folder structure. This is an example of the text output:

```
Input directory:
----------------

 /home/sergio/Documents/MACARENA


Output Directory:
-----------------
 /home/sergio/Documents/MACARENA/../Takes


Spheres: // ---> Note that there are two "shots" or "spheres".
--------

 Avion1Cabina
 Avion1Ejecutiva


Structure:
----------

/home/sergio/Documents/MACARENA/Avion1Cabina:
Cam1  Cam2  Cam3  Cam4

/home/sergio/Documents/MACARENA/Avion1Ejecutiva:
Cam1  Cam2  Cam3  Cam4


Integrity:  // ----> You should check this section before copying!
----------

SPHERENUM  NUMCAMERAS  TAKES  NAME

0    4    7777    Avion1Cabina     
								   
1    4    4444    Avion1Ejecutiva  

It appears you have  4  cameras
```

Note that sphere0 has 4 cameras and seven takes. There are 7 files in each cam folder and hence there is 7777. If you see 7677, it means cam2 likely did not start in one of the takes. You should manually delete this take from all folders before copying.


### Check integrity and copy files

Add the "c" character to tell the script to copy files. 

`./takify.sh <InputFolder> c`

* Please note that the "Takes" folder will be at the same level of your ProjectName folder. 
* The copy process is non-destructive. However, please make sure you have made a backup of your files before running this script.
* There is a commented line in the copy routine in case you want to do some additional processing (e.g. ffmpeg re-scaling, re-encoding, etc).

## Install

1. Copy the script to a location.
2. In the script location, make the script executable by doing `chmod +x  takify.sh`
3. If you want the script to be available anywhere, add the containing folder to your path.
