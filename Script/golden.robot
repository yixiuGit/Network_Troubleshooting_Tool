*** Settings ***
# Importing test libraries, resource files and variable files.
Library        ats.robot.pyATSRobot
Library        genie.libs.robot.GenieRobot
Library        String
Library        Collections
Library        OperatingSystem

*** Variables ***
# Define the pyATS testbed file to use for this run


${folder}      good_snapshot
${testbed}     ${CURDIR}/testbed.yaml
${pts_file}    ${CURDIR}/good/${folder}
${DEVICE}      dist-rtr01
${device1}

*** Test Cases ***
# Creating test cases from available keywords.
Connect
    # Save data from file1.txt to variable ${File}
    ${File} =    Get File    ${CURDIR}/file1.txt
    # ${File}=    Get File    file1.txt
    # Save the value of each line to a list @{lines}
    @{lines}=    Split to lines  ${File}
    # Initializes the pyATS/Genie Testbed
    use genie testbed "${testbed}"

    # print out ${lines} for testing purpose
    Log    ${lines}
    # Connect to each device
    FOR    ${line}    IN    @{lines}
        connect to device "${line}"
    END


Profile the devices
    ${File} =    Get File    ${CURDIR}/file1.txt
    @{lines}=    Split to lines  ${File}
    Create Directory  ${CURDIR}/good
    # Catenate each device name to a string with ; as separator,save the value to the variable ${alldevices}
    ${alldevices}=     Catenate    SEPARATOR=;    @{lines}
    Profile the system for "config;interface;platform;ospf;arp;routing;vrf;vlan" on devices "${alldevices}" as "${pts_file}"

