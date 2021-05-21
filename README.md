# Network-Troubleshooting-Tool
#### Network device configuration, operation status and trouble shooting
This tool is used to collect network devices configuration, operation status when network performance as expected, save them as golden image. When any problem is being reported for the network, it will collect the same data again and compare with the golden image, point out any change/difference in a minute, which will help engineer to find out the cause of the problem.

#### System requirement
- Linux
- Python 3.5.x and above
- pyATS

#### Supported platform
- Cisco IOS
- Cisco IOXE
- Cisco IOSXR
- Cisco NXOS
- Cisco ASA

#### Supported connect methods
- telnet
- ssh
- console

#### Installation
       pip install pyats[full]

#### Testbed file
       The testbed.yaml file is to outline what the topology is and how pyATS can connect to it.

#### Golden image collection
      Run below command to collect golden image
      
		robot --outputdir run -v folder:folder name golden.robot
	
      Devices are defined in testbed.yaml file, the command will collect all devices configuration, 
      operation status information, save that information in the folder you defined in the command line.

#### Information compares
     When there is network problem being reported, run below command to collect same information and 
     do the comparison with the golden image.
     The change/difference will be displayed via the console and saved in a html file that you can check with any browser.
     
		robot --outputdir run compare.robot 
	
     If you are only interest in certain device(s) information, 
     you can specify the device hostname in the command line. 
     It supports up to 5 devices.
     
		robot --outputdir run -v folder:abc -v device1:hostname1 -v device2:hostname2 … compare.robot
	
      The output will be saved in the folder run with 3 files(output.xml, log.html and report.html). 
      Open the report.html with any browser, it will show you the difference if there is. 
      Otherwise, it will tell you the information is identical between the golden image and newly generated image.
      
      ![image](https://github.dxc.com/dxcconnect/Network-Troubleshooting-Tool/blob/master/compare1.png)



