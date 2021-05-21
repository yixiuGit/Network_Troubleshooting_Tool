*** Settings ***
# Importing test libraries, resource files and variable files.
Library        ats.robot.pyATSRobot
Library        genie.libs.robot.GenieRobot
Library        String
Library        Collections
Library        OperatingSystem


*** Variables ***
# Define the pyATS testbed file to use for this run

${testbed}     /home/developer/testbed.yaml
# Define variable to hold input value in runtim
${sitename}
${device1}
${device2}
${device3}
${device4}
${device5}

*** Test Cases ***
# Creating test cases from available keywords.

Connect
    # Read content from files1.txt and save in variable ${File}
    ${File} =    Get File    ${CURDIR}/${sitename}/file1.txt
    # ${File}=    Get File    file1.txt
    # Save the value of each line to a list @{lines}
    @{lines}=    Split to lines  ${File}
    # Initializes the pyATS/Genie Testbed
    use genie testbed "${CURDIR}/${sitename}/testbed.yaml"
    # Allow variable to be used in other test cases
    Set Suite Variable  ${File}
    Set Suite Variable  @{lines}

    # Connect to both device
    # print out ${lines} for testing purpose
    Log    ${lines}
    # Connect to each device
    FOR    ${line}    IN    @{lines}
        connect to device "${line}"
    END
Profile the devices
    # Create a new folder
    Create Directory  ${CURDIR}/${sitename}/current
    # Create a new list to hold values inputed in runtime which is device hostname
    ${device_list} =    Create List     ${device1}    ${device2}    ${device3}    ${device4}    ${device5}
    # Create an empty list
    @{check_list} =    Create List
    # For each item in the list, check if its value is '', if not add the item in the new list(@{check_list})
    FOR  ${i}  IN RANGE  0  5
        ${d} =  Get From List  ${device_list}  ${i}
        Log  ${d}
        Run Keyword If  '${d}' != ''    Append To List    ${check_list}    ${d}
    END
    # Check the length of the list, if it is 0, which means user did not specify any hostname at runtime
    ${len} =  Get Length  ${check_list}
    # Log  ${check_list}
    # Log  ${len}
    # Get all items(hostname) in the list and catenate them as a string and assign to variables
    # ${defaultdevices} is for whole site
    # ${inputdevices} is for devices that entered by user
    ${defaultdevices} =  Catenate    SEPARATOR=;    @{lines}
    ${inputdevices} =  Catenate    SEPARATOR=;    @{check_list}
    # if ${len} == 0, no user input, it will profile whole site and compare, othrewise only profile and compare
    # the devices entered by user
    ${alldevices} =  Set Variable If  ${len} == 0  ${defaultdevices}  ${inputdevices}
    Log  ${alldevices}
    Set Suite Variable  ${alldevices}

    Run Keyword If    ${len} == 0    Profile the system for "config;interface;platform;ospf;arp;routing;vrf;vlan" on devices "${alldevices}" as "${CURDIR}/${sitename}/current/new_snapshot"
    ...    ELSE    Profile the system for "config;interface;platform;ospf;arp;routing;vrf;vlan" on devices "${alldevices}" as ".${CURDIR}/${sitename}/current/new_snapshot"

Compare snapshots
    Compare profile "${CURDIR}/${sitename}/good/good_snapshot" with "${CURDIR}/${sitename}/current/new_snapshot" on devices "${alldevices}"

