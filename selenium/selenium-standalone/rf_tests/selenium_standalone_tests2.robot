*** Settings ***
Library    Selenium2Library
Suite Teardown    Close All Browsers


*** Variables ***
${remote_url}    http://192.168.2.15:32222/wd/hub

*** Test Cases ***
Headless Chrome - Create Webdriver
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}   add_argument    headless
    Call Method    ${chrome_options}   add_argument    disable-gpu
    ${options}=     Call Method     ${chrome_options}    to_capabilities

    Create Webdriver    Remote   command_executor=${remote_url}    desired_capabilities=${options}

    Go to     http://cnn.com

    Maximize Browser Window
    Capture Page Screenshot

Headless Chrome - Open Browser
    ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}   add_argument    headless
    Call Method    ${chrome_options}   add_argument    disable-gpu
    ${options}=     Call Method     ${chrome_options}    to_capabilities

    Open Browser    http://cnn.com    browser=chrome    remote_url=${remote_url}     desired_capabilities=${options}

    Maximize Browser Window
    Capture Page Screenshot