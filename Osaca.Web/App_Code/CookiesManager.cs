//=======================================
// Developer: M. Salah (09-02-2016)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

using Minutesuae.SystemUtilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class CookiesManager
{
    public static void UserLogin(HttpCookie _userInfo)
    {
        string cookieIDVal = EncryptDecryptString.Decrypt(_userInfo[Config.cookieID], Config.encrypptKey),
            cookieUsernameVal = HttpContext.Current.Server.UrlDecode(EncryptDecryptString.Decrypt(_userInfo[Config.cookieUsername], Config.encrypptKey)),
            cookieLevelVal = EncryptDecryptString.Decrypt(_userInfo[Config.cookieLevel], Config.encrypptKey);

        SessionManager.Current.ID = cookieIDVal;
        SessionManager.Current.Name = cookieUsernameVal;
        SessionManager.Current.Level = cookieLevelVal;
    }

    public static void SaveCoockie()
    {
        string cookieIDVal = EncryptDecryptString.Encrypt(SessionManager.Current.ID, Config.encrypptKey),
                cookieUsernameVal = EncryptDecryptString.Encrypt(HttpContext.Current.Server.UrlEncode(SessionManager.Current.Name), Config.encrypptKey),
                cookieLevelVal = EncryptDecryptString.Encrypt(SessionManager.Current.Level, Config.encrypptKey);

        //Creting a Cookie Object
        HttpCookie _userInfoCookies = new HttpCookie(Config._cookName, Config._encrypted_ticket);

        //Setting values inside it
        _userInfoCookies[Config.cookieID] = cookieIDVal;
        _userInfoCookies[Config.cookieUsername] = cookieUsernameVal;
        _userInfoCookies[Config.cookieLevel] = cookieLevelVal; ;

        //Adding Expire Time of cookies
        _userInfoCookies.Expires = DateTime.Now.AddDays(1);
        //_userInfoCookies.Path = "/sys";

        //Adding cookies to current web response
        HttpContext.Current.Response.Cookies.Add(_userInfoCookies);
    }

    // Delete cookie
    public static void ResetCookie()
    {
        var _userInfoCookies = new HttpCookie(Config._cookName) { Expires = DateTime.Now.AddDays(-7) };
        HttpContext.Current.Response.Cookies.Add(_userInfoCookies);
    }
}