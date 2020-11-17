*** Settings ***
Documentation    Suite description
Library    String
Library    OperatingSystem

*** Test Cases ***
Test title
    @{urls}    Get urls
    FOR   ${url}   IN   @{urls}
        Log   line: ${url}    console=True
        Get Menu    ${url}
    END


*** Keywords ***
Get Menu
    [Arguments]    ${url}
    Log   url: ${url}    console=True
    Go To    ${url}
    Sleep  5s
    Wait Until Page Contains Element   ${szczegoly_naglowek}
    Page Should Contain    Szczegóły
    ${text}    Get Text    ${caly_dzien_menu}
    Log   dzien: ${text}    console=True
#    ${url}   Get Location
    ${data}    Get Date    ${url}
    Save To File With Date   ${data}   ${text}

Get urls
    ${file}    Get File    ${CURDIR}/urls.txt
    @{lines}   Split String     ${file}    \n
    [Return]   @{lines}

Get Date
    [Arguments]    ${url}
    ${data}   Get Regexp Matches     ${url} 	(.*?)(/[\-0-9]+/)(.*?)    2
    ${data}   replace string    ${data}[0]   /   ${EMPTY}
    [Return]   ${data}

Save To File With Date
    [Arguments]    ${date}    ${content}
    ${filename}    Set Variable    ${CURDIR}/files/${date}_dieta.txt
    Touch    ${filename}
    Log   Saving menu for date ${date}   console=True
    # ${content}
    Run  echo "${content}" >> ${filename}