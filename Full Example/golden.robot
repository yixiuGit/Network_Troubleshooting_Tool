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
# ${testbed}     ${CURDIR}/testbed.yaml
# ${pts_file}    ${CURDIR}/good/${folder}
# ${DEVICE}      dist-rtr01
# ${device1}

*** Test Cases ***
# Creating test cases from available keywords.
Connect and Profile
    # Create folders for each site that will contain testbed file and device list file
    ${Sites} =  Get File    ${CURDIR}/sitelist.txt
    @{sites} =  Split to lines  ${Sites}
    FOR  ${site}  IN  @{sites}
        Create Directory  ${CURDIR}/${site}

    END
    # Save data from file1.txt to variable ${File}
    ${Sites} =  Get File    ${CURDIR}/sitelist.txt
    @{sites} =  Split to lines  ${Sites}



    FOR  ${site}  IN  @{sites}

        ${File} =    Get File    ${CURDIR}/${site}/file1.txt
        # Save the value of each line to a list @{lines}
        @{lines}=    Split to lines  ${File}
        ${site_name} =  Create List
        Log  ${site_name}
        Set Suite Variable  ${site_name}
        # Create a folder to keep output
        Create Directory  ${CURDIR}/${site}/good
        # Initializes the pyATS/Genie Testbed
        use genie testbed "${CURDIR}/${site}/testbed.yaml"
        Set Suite Variable  ${site}
        Loop over items  @{lines}
    END
*** Keywords ***
Loop over items
    [Arguments]  @{lines}
    Log  ${lines}
    ${empty_list} =  Create List
    # Connect to each device
    FOR    ${device}    IN    @{lines}
        Log  ${device}
        Append To List  ${site_name}  ${device}
        Log  ${site_name}
        connect to device "${device}"
        ${p} =  Get From List  ${lines}  -1
        ${device_list} =  Set Variable If  "${device}" == "${p}"  ${site_name}  ${empty_list}
        Log  ${p}
        Log  ${device_list}
        ${alldevices} =  Catenate    SEPARATOR=;    @{device_list}
        Log  ${alldevices}
        ${len} =  Get Length  ${device_list}
        # ${len} =  Set Variable If   "${first_item}" ==  "None"  0  1

        Run Keyword If  ${len} != 0  Profile the system for "config;interface;platform;ospf;arp;routing;vrf;vlan" on devices "${alldevices}" as "${CURDIR}/${site}/good/${folder}"

        # ${alldevices} =  Catenate    SEPARATOR=;    @{device_list}}

        # ${alldevices} =  Set Variable If  ${len} != 0 Catenate    SEPARATOR=;    @{lines}
        # connect to device "${device}"
        # Profile device
        # Profile the system for "config;interface;platform;ospf;arp;routing;vrf;vlan" on devices "dist-rtr01" as "${CURDIR}/${site}/good/${folder}"
    END
