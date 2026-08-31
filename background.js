// Service worker for Netflix Cookie Injector
// Currently minimal – cookie operations are handled from the popup.
// Kept for future extensions (e.g. context menus, alarms, etc.)

chrome.runtime.onInstalled.addListener(() => {
  console.log('LaorORG © Netfixa installed.');
});
