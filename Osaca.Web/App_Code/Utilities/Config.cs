//=======================================
// Developer: M. Salah (09-02-2016)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

using System;
using System.Collections.Generic;
using System.Linq;
using System.Configuration;
using System.Web.Security;

public static class Config
{
    // private
    private static string user_item = "eng.msalah.abdullah@gmailcom";

    // public
    public static string AdminUrl = "sys",
    FacePageAppID = ConfigurationManager.AppSettings["FaceAppID"],
    FacePageAppSecret = ConfigurationManager.AppSettings["FaceAppSecret"],
    FacePageName = ConfigurationManager.AppSettings["FacePageName"],

    InstPageAppID = ConfigurationManager.AppSettings["instagram.clientid"],
    InstAppSecret = ConfigurationManager.AppSettings["instagram.redirecturi"],
    InstUrl = ConfigurationManager.AppSettings["FacePageName"],

    // cookie keys
    encrypptKey = "cok$4Key", _cookName = "_shwd", /*EncryptDecryptString.Encrypt("Share.UserInfo", encrypptKey),*/
    cookieID = "Share.ID", cookieUsername = "Share.Name",
    cookieLevel = "Share.Level",
    
    _encrypted_ticket = FormsAuthentication.Encrypt(new FormsAuthenticationTicket(1, " ShareWebDesign ", DateTime.Now, DateTime.Now.AddDays(1), false, user_item));
}