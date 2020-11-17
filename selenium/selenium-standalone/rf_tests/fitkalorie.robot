*** Settings ***
Documentation    Suite description
Resource    keywords.robot

*** Variables ***
${OS}     Linux
&{BROWSERS}    chrome=32222    headlesschrome=32222   firefox=32111
@{ch_params}    --no-sandbox    --start-maximized    --disable-dev-shm-usage    --disable-web-security    --allow-running-insecure-content    --safebrowsing-disable-extension-blacklist    --safebrowsing-disable-download-protection  --excludeSwitches
@{ff_params}    --headless    --no-sandbox    --disable-dev-shm-usage
&{BROWSER_PARAMS}    chrome=@{ch_params}  headlesschrome=@{ch_params}  firefox=@{ff_params}
${selenium_host}    http://192.168.2.2:PORT/wd/hub
#${SUT_URL}    https://fitkalorie.pl/
${SUT_URL}    https://panel.fitkalorie.pl/auth/login
#${login_loc}    xpath: //button[@class="sc-cSHVUG cVPQtC sc-feryYK iEaUww"]
#${login_loc}    xpath: //div[@class="src__Box-sc-1sbtrzs-0 src__Flex-sc-1sbtrzs-1 eSpNpb"]
#${login_loc}    xpath: //div[@class="src__Box-sc-1sbtrzs-0 src__Flex-sc-1sbtrzs-1 eSpNpb"]
#${login_loc}    xpath: //div[@class="src__Box-sc-1sbtrzs-0"  src__Flex-sc-1sbtrzs-1 eSpNpb"]
#${login_loc}    xpath: //div[contains(@class,'src__Box-sc-1sbtrzs-0') and contains(@class,'src__Flex-sc-1sbtrzs-1') and contains(@class,'eSpNpb')]
#${login_loc}    xpath: //*[contains(@class,'fas') and contains(@class,'fa-sign-in-alt')]
# ${login_click}    css:button.sc-cSHVUG.cVPQtC.sc-feryYK.iEaUww  ElementNotInteractableException: Message: Element <button class="sc-cSHVUG cVPQtC sc-feryYK iEaUww"> could not be scrolled into view
#${login_loc}    css: div.src__Box-sc-1sbtrzs-0.src__Flex-sc-1sbtrzs-1.eSpNpb"]
#${login_loc}    xpath: //button[text()="Zaloguj się"]
#${login_loc}    xpath: //button[contains(text(), "Zaloguj")]


# working
#${login_loc}    css:i.fas.fa-sign-in-alt
${akceptuje_kuki}    xpath: //button[contains(text(),"Akceptuję")]
${login_email}    xpath: //input[@name="email"]
${login_pass}    xpath: //input[@name="password"]
${login_button}    css: button.sc-cSHVUG.eRMCdI.sc-kpOJdX.lnNcPz
${logout_button}     css: button.sc-cSHVUG.cVPQtC.sc-feryYK.bjrJQc
#${moje_konto_link}    xpath: //a[contains(text(),"Moje konto")]
#${moje_konto_link}    xpath: //a[contains(text(),"Moje konto")]
#${skarbonka}    css: div.sc-gldTML.gnHotK
#${ustawienia_konta_link}    link:Ustawienia konta
#${ustawienia_konta_link}    xpath: //a[text()="Ustawienia konta"]
#${ustawienia_konta_link}    xpath: //a[text()="Ustawienia konta"]
${ustawienia_konta_link}    css: h1.sc-kkGfuU.fZOOmj
# h1 sc-kkGfuU fZOOmj Moje konto
#${moje_konto}   id:menu-item-13925
#${spr_menu}    xpath: //a[contains(text(), "Sprawd")]
#${moje_konto_click}   xpath: //a[text()="MOJE KONTO"]
${dzien_click}     css: div.sc-ipXKqB.dHYxac
${szczegoly_naglowek}    css: h1.sc-kkGfuU.jxfbss
${caly_dzien_menu}     css: div.src__Box-sc-1sbtrzs-0.hWbxRF

*** Test Cases ***
Test title
    [Tags]    DEBUG
    Set Screenshot Directory    ${CURDIR}/screens
#    Create Testing Object  Chrome   ${SUT_URL}
    Create Testing Object  Firefox   ${SUT_URL}
#    Title Should Be    Catering dietetyczny do domu - Dieta pudełkowa fitness - Fit Kalorie
    Title Should Be    Fit Kalorie - Panel klienta

    Wait Until Page Contains Element   ${akceptuje_kuki}
    Click Element 	${akceptuje_kuki}
#    Wait Until Page Contains Element   ${moje_konto}
#    Wait Until Page Contains Element   ${spr_menu}
#    Click Element 	${spr_menu}
#    Sleep  5s
#    Wait Until Page Contains Element   ${login_loc}
#    Click Element 	${login_click}
    Wait Until Page Contains Element   ${login_email}
    Click Element 	${login_email}
    Press Keys     ${login_email}    login@mail.com
    Click Element 	${login_pass}
    Press Keys     ${login_pass}    haslo
    Click Element 	${login_button}
#    Sleep  10s
    Wait Until Page Contains Element   ${ustawienia_konta_link}
    Sleep  5s
    Click Element 	${dzien_click}
    Wait Until Page Contains Element   ${szczegoly_naglowek}
    Page Should Contain    Szczegóły


    @{urls}    Get urls
    FOR   ${url}   IN   @{urls}
        Log   line: ${url}    console=True
        Get Menu    ${url}
    END


    [Teardown]    Close Browser
