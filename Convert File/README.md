# Convert jason file collected from Spectrum to yaml file as testbed

## Purpose of this script
  - It generate testbed files for each network site, then will be leveraged by scripts in the Full Example folder to collect network devices configuration and operation status when network perform as expected and abnormal. 

## How does it work

### Run initial_setup.py
  - Read test.json to the program
  - For each new agency, create a folder with agency name
  - For each site of the same agency, create folder with site name
  - In each agency folder, create a text file name as file11.txt and save all sites' names of the agency 
  - In each site folder, create a text file name as device.txt and save all device names of the site
  - Copy hostname.xlsx as template to each site folder
  - Add hostname, ip, credential etc to the hostname.xlsx in each site folder for those devices of the site
  - Generat testbed file(hostname.yaml) for each site
  
### Run update_new.py
  - Read test.json and test1.json to the program, test1.json is the new data collected from spectrum
  - Compare test.json and test1.json and find the difference
  - Repeat step 2 to 7 in previous run
  - It will generate testbed file based on the difference.
  
### The 5 folders in this repository show the output of this project
  
