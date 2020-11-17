*** Settings ***
Library   SeleniumLibrary
Library   OperatingSystem
Library   String

*** Keywords ***
Get Menu
    [Arguments]    ${url}
#    Log   url: ${url}    console=True
    Go To    ${url}
    Sleep  5s
    Wait Until Page Contains Element   ${szczegoly_naglowek}
    Page Should Contain    Szczegóły
    ${text}    Get Text    ${caly_dzien_menu}
#    Log   dzien: ${text}    console=True
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
#    Log   Saving menu for date ${date}   console=True
    # ${content}
    Run  echo "${content}" >> ${filename}

Get Grid Url For Browser ${browser}
    [Return]    ${{str($selenium_host).replace("PORT",str(${BROWSERS}[${browser.lower()}]))}}

Get Params For Browser ${browser}
    [Return]    ${{[param for param in ${BROWSER_PARAMS}[${browser.lower()}]]}}

Return ${browser} Settings On OS ${os}
    ${params}   Get Params For Browser ${browser}
    &{args}    Create Dictionary    args=${params}
    ${grid_url}    Get Grid Url For Browser ${browser}
    ${desired caps}    Create Dictionary    platform=${os}    ${browser.lower()}Options=${args}
    @{settings}  Create List   ${grid_url}    ${desired caps}
    [Return]    ${settings}

Get Settings For Browser ${browser} On OS ${os}
    ${settings}    Return ${browser.lower()} Settings On OS ${os}
    [Return]  ${settings}

Wait For Element On Page
    [Arguments]    ${locator}
    Sleep  5s
    Element Should Be Visible   ${locator}

Test All Browsers
    @{browsers}     Create List    Chrome
    FOR   ${browser}   IN    @{browsers}
        Create Testing Object  Chrome   ${SUT_URL}
    END


Create Testing Object
    [Arguments]    ${browser}   ${sut_url}
    ${tested_url}     Set Variable    ${sut_url}
    @{settings}    Get Settings For Browser ${browser} On OS ${OS}
    Log  Testing browser ${browser}   console=true
    Open Browser    ${tested_url}    remote_url=${settings[0]}    browser=${browser}     desired_capabilities=${settings[1]}

#    ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  modules=sys,selenium.webdriver
#    FOR   ${item}   IN   @{ch_params}
#        Call Method  ${chrome_options}  add_argument  ${item}
#    END
##    ${prefs}   Create List   excludeSwitches
##    Call Method  ${chrome_options}  add_experimental_option    ${prefs}
##    Call Method  ${chrome_options}  add_experimental_option  ['enable-automation']
#    Open Browser  url=${tested_url}  browser=${browser}  remote_url=${settings[0]}  options=${chrome_options}  desired_capabilities=${settings[1]}

    Sleep  10s
    ${title}    Get Title
    Log    title: ${title}    console=true


Testing Via Python Caps
    [Arguments]    ${browser}   ${sut_url}
    ${chrome_options}    Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()   modules=sys,selenium.webdriver
    @{caps}     Create List   '--start-maximized'  '--disable-web-security'  '--allow-running-insecure-content'  '--safebrowsing-disable-extension-blacklist'  '--safebrowsing-disable-download-protection'
    @{settings}    Get Settings For Browser ${browser} On OS ${OS}
    &{tab_to_use}   Create Dictionary   platform=Linux args=${caps}
    Log  Testing browser ${browser}   console=true
    Open Browser    ${sut_url}    remote_url=http://192.168.2.15:32222/wd/hub   browser=${browser}     desired_capabilities=${tab_to_use}
    ${title}    Get Title
    Log    title: ${title}    console=true
    Close Browser


Open Remote Chrome through Selenium Hub
    [Arguments]    ${sut_url}=https://www.wp.pl
#    @{caps}     Evaluate  ['--start-maximized', '--disable-web-security', '--allow-running-insecure-content', '--safebrowsing-disable-extension-blacklist', '--safebrowsing-disable-download-protection']
#    Open Browser    ${sut_url}    remote_url=http://192.168.2.15:32222/wd/hub   browser=Chrome    options=add_argument('--start-maximized123')                  #; add_argument('')
    #&{dict_one}    Create Dictionary   debuggerAddress=localhost:46339   '--headless'=True  '--disable-gpu'=True
    #@{caps}    Create List    goog:chromeOptions=${dict_one}
    ${desired_caps}    Create Dictionary  platform=Linux  version=XX
    #args=${caps}


    #screenResolution=${screenResolution}  record_video=${record_video}  record_network=${record_network}  build=${buildNum}  name=${globalTestName}
#    ${chrome_options}  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
#    ${chrome_options.add_argument}    Set Variable  --start-maximized
#    ${chrome_options.add_argument}    Set Variable  --start-maximized
#    Open Browser  url=${sut_url}  browser=Chrome  remote_url=http://192.168.2.15:32222/wd/hub  options=${chrome_options}  desired_capabilities=${desired_caps}
#    Open Browser  url=${sut_url}  browser=Chrome  remote_url=http://192.168.2.15:32222/wd/hub  options=add_argument('--start-maximized');add_argument('--disable-web-security')  desired_capabilities=${desired_caps}

#    ${browserOptions}    Set Variable    {"args":[ "--start-maximized:True", "--debuggerAddress:'localhost:43883'" ]}
#    Open Browser  url=${sut_url}  browser=Chrome  remote_url=http://192.168.2.15:32222/wd/hub  options=add_argument('--start-maximized');add_argument('--headless');add_argument('--disable-web-security');add_argument('--disable-web-security')  desired_capabilities=${desired_caps}


# approach 1
#    ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
#    Call Method  ${chrome_options}  add_argument  --start-maximized
#    Call Method  ${chrome_options}  add_argument  --headless
#    Call Method  ${chrome_options}  add_argument  --disable-web-security
#    Open Browser  url=${sut_url}  browser=Chrome  remote_url=http://192.168.2.15:32222/wd/hub  options=${chrome_options}  desired_capabilities=${desired_caps}

# approach 2
    Open Browser  url=${sut_url}  browser=Chrome  remote_url=http://192.168.2.15:32222/wd/hub  options=add_argument('--start-maximized');add_argument('--headless');add_argument('--disable-web-security');add_argument('--disable-web-security')  desired_capabilities=${desired_caps}
    ${x}    Evaluate    dir(robot.libraries.BuiltIn.BuiltIn().get_library_instance('SeleniumLibrary').driver)  modules=robot
    log  driver: ${x}   console=True
    ${d_cap}    Evaluate    robot.libraries.BuiltIn.BuiltIn().get_library_instance('SeleniumLibrary').driver.desired_capabilities  modules=robot
    log  d_cap: ${d_cap}   console=True
    ${d_name}    Evaluate    robot.libraries.BuiltIn.BuiltIn().get_library_instance('SeleniumLibrary').driver.name  modules=robot
    log  driver: ${d_name}   console=True

    Close Browser


#    webdriver.Remote(command_executor='http://127.0.0.1:4444/wd/hub',desired_capabilities={'browserName': 'htmlunit','version': '2','javascriptEnabled': True})
#    Create Webdriver    Remote    command_executor=${executor}    desired_capabilities=${desired capabilities}
#    Go To    ${url}
#    Close Browser

#Test Chrome
#    ${list} =    Create List    --start-maximized    --disable-web-security    --allow-running-insecure-content    --safebrowsing-disable-extension-blacklist    --safebrowsing-disable-download-protection
#    ${args} =    Create Dictionary    args=${list}
#    ${grid_url}    Set Variable    http://192.168.2.15:32222/wd/hub
#    ${tested_url}     Set Variable    https://www.wp.pl
#    ${BROWSER}    Set Variable    Chrome            # headlesschrome
#    ${desired caps} =    Create Dictionary    platform=${OS}    chromeOptions=${args}
#    Open Browser    ${tested_url}    remote_url=${grid_url}    browser=${BROWSER}    desired_capabilities=${desired caps}
#    ${title}    Get Title
#    Log    title: ${title}    console=true
#    Close Browser
#
#Test Headless Chrome
#    ${list} =    Create List    --start-maximized    --disable-web-security    --allow-running-insecure-content    --safebrowsing-disable-extension-blacklist    --safebrowsing-disable-download-protection
#    ${args} =    Create Dictionary    args=${list}
#    ${grid_url}    Set Variable    http://192.168.2.15:32222/wd/hub
#    ${tested_url}     Set Variable    https://www.wp.pl
#    ${BROWSER}    Set Variable    headlesschrome
#    ${desired caps} =    Create Dictionary    platform=${OS}    chromeOptions=${args}
#    Open Browser    ${tested_url}    remote_url=${grid_url}    browser=${BROWSER}    desired_capabilities=${desired caps}
#    ${title}    Get Title
#    Log    title: ${title}    console=true
#    Close Browser

#    ${swb}    Create Webdriver   Chrome
#    ${remote_webdriver}    Evaluate  sys['selenium.webdriver'].Remote(desired_capabilities=webdriver.DesiredCapabilities.Chrome,command_executor='http://192.168.2.15:32110/wd/hub')   modules=sys,selenium.webdriver

#    ${chrome_options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
#    ${prefs}  Create Dictionary  download.prompt_for_download=${FALSE}  plugins.always_open_pdf_externally=${TRUE}
#    Call Method  ${chrome_options}  add_experimental_option  prefs  ${prefs}
#
