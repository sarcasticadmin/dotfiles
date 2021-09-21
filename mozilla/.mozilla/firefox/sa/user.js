// Good sources:
// https://github.com/arkenfox/user.js/blob/master/user.js
// https://git.server1.link/akp/dotfiles/-/blob/master/.mozilla/firefox/sch.default/user.js

// XUL/XHTML version
user_pref("general.warnOnAboutConfig", false);
user_pref("browser.aboutConfig.showWarning", false); // HTML version [FF71+]
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.startup.page", 0);
user_pref("browser.startup.homepage", "about:blank");

// Leave this alone or else youll be continuously prompted to open any page (including https)
user_pref("network.protocol-handler.expose-all", true);
// Stop prompting me for mail application crap
user_pref("network.protocol-handler.external.mailto", false);

user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtab.preload", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.asrouter.providers.snippets", "{}");
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false); // [FF66+]
user_pref("browser.newtabpage.activity-stream.default.sites", "");

/* 0204: disable using the OS's geolocation service ***/
user_pref("geo.provider.ms-windows-location", false); // [WINDOWS]
user_pref("geo.provider.use_corelocation", false); // [MAC]
user_pref("geo.provider.use_gpsd", false); // [LINUX]

// End of apk inspired configs

// Disable password manager
user_pref("privacy.cpd.passwords", false);
user_pref("security.ask_for_password", 0);

// Disable form stuff
user_pref("signon.autofillForms", false);
user_pref("signon.formlessCapture.enabled", false);

// feature from hell I dont want notifications
user_pref("dom.webnotifications.enabled", false);

// Disable DOH
user_pref("network.trr.mode", 5);

// Move cache to RAM
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true); // [FF75+]
user_pref("browser.cache.memory.capacity", 524288); // Give it 512mb of RAM

// Basically disable sessionstore
user_pref("browser.sessionstore.interval", 15000000);
user_pref("browser.urlbar.trimURLs", false);

// Search preferences

// Keep this as it is since the behavior of default searching in the address bar will break otherwise
user_pref("keyword.enabled", true);

// DID NOT WORK
//user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts", false);
//user_pref("browser.urlbar.update2", false);
//user_pref("browser.search.geoSpecificDefaults", false);
//user_pref("browser.search.defaultenginename.US","data:text/plain,browser.search.defaultenginename.US=Bing");

// Going to try it out being less busy
user_pref("browser.urlbar.maxRichResults", 0);
