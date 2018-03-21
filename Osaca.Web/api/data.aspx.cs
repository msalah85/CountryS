//=======================================
// Developer: M. Salah (09-02-2016)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

using System;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.IO;
using System.Collections;
using ShareWeb.Business.DataUtility;
using ShareWeb.Business.Business;

public partial class api_data : System.Web.UI.Page
{
    #region "Get General Data"

    [WebMethod] // paged by scroll
    public static string GetPagedList(string pageIndex, string pageSize, string actionName)
    {
        // create filter paramters
        string[,] _params = { { "PageIndex", pageIndex }, { "PageSize", pageSize } };

        // get all of data.
        var _ds = new Select().SelectPagedLists(actionName, _params);
        string compressedXML = TrimmerUtil.RemoveSpaces(_ds.GetXml());
        return compressedXML;
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public static object LoadDataTables()
    {
        jQueryDataTableParamModel param = new jQueryDataTableParamModel();
        HttpContext Context = HttpContext.Current;
        param.sEcho = String.IsNullOrEmpty(Context.Request["sEcho"]) ? 0 : Convert.ToInt32(Context.Request["sEcho"]);
        param.sSearch = String.IsNullOrEmpty(Context.Request["sSearch"]) ? "" : Context.Request["sSearch"];
        param.iDisplayStart += String.IsNullOrEmpty(Context.Request["iDisplayStart"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayStart"]);
        param.iDisplayLength = String.IsNullOrEmpty(Context.Request["iDisplayLength"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayLength"]);
        var sortColumnIndex = Convert.ToInt32(Context.Request["iSortCol_0"]);
        var sortDirection = Context.Request["sSortDir_0"];// asc or desc          

        // create filter parameters
        string[,] _params = {{"DisplayStart",param.iDisplayStart.ToString()}, {"DisplayLength", param.iDisplayLength.ToString()},
                             {"SearchParam", param.sSearch}, {"SortColumn", sortColumnIndex.ToString()}, {"SortDirection", sortDirection}};

        // get all of data.
        var _ds = new Select().SelectLists(Context.Request["funName"], _params);

        // enhance data to be list.
        var rows = DataUtilities.ConvertDTToList(_ds.Tables[0]);

        var data = new
        {
            param.sEcho,
            iTotalRecords = _ds.Tables[1].Rows[0][0],
            iTotalDisplayRecords = _ds.Tables[1].Rows[0][0],
            aaData = rows.ToList()
        };

        return data;
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    public static object GetData(string actionName, string value)
    {
        // create filter paramters
        string[,] _params = { { "Id", value } };

        // get all of data.
        var _ds = new Select().SelectLists(actionName, _params);
        string compressedXML = TrimmerUtil.RemoveSpaces(_ds.GetXml());
        return compressedXML;
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    public static object GetDataDirect(string actionName)
    {
        if (!String.IsNullOrEmpty(actionName))
        {
            // get all of data.
            var _ds = new Select().SelectLists(actionName);
            string compressedXML = TrimmerUtil.RemoveSpaces(_ds.GetXml());
            return compressedXML;
        }
        else
            return null;
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    public static string GetDataList(string actionName, string[] names, string[] values)
    {
        // get all of data.
        var _ds = new Select().SelectLists(actionName, names, values);
        string compressedXML = TrimmerUtil.RemoveSpaces(_ds.GetXml());
        return compressedXML;
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    public static object saveData(string actionName, string[] names, string[] values)
    {   // start save data.
        var saved = new Save().SaveRow(actionName, names, values);
        object data = new { };

        if (saved != -1)
        {
            data = new
            {
                ID = saved,
                Status = true,
                message = Resources.Resource_ar.SuccessSave
            };
        }
        else
        {
            data = new { ID = 0, status = false, message = Resources.Resource_ar.ErrorSave };
        }

        return data;
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    //[MinifyXml]
    public static object LoadDataTablesXML()
    {
        jQueryDataTableParamModel param = new jQueryDataTableParamModel();
        HttpContext Context = HttpContext.Current;

        param.sSearch = String.IsNullOrEmpty(Context.Request["sSearch"]) ? "" : Context.Request["sSearch"];
        param.iDisplayStart += String.IsNullOrEmpty(Context.Request["iDisplayStart"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayStart"]);
        param.iDisplayLength = String.IsNullOrEmpty(Context.Request["iDisplayLength"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayLength"]);
        var sortColumnIndex = Convert.ToInt32(Context.Request["iSortCol_0"]);
        var sortDirection = Context.Request["sSortDir_0"] ?? "desc"; // asc or desc

        // grid static parameters
        string[] names = { "DisplayStart", "DisplayLength", "SortColumn", "SortDirection", "SearchParam" },
                 values = { param.iDisplayStart.ToString(), param.iDisplayLength.ToString(), sortColumnIndex.ToString(), sortDirection, param.sSearch },

        // get dynamic more parameters from user
        addtionNames = string.IsNullOrEmpty(Context.Request["names"]) ? new string[0] : Context.Request["names"].Split('~'),
        addtionValues = string.IsNullOrEmpty(Context.Request["values"]) ? new string[0] : Context.Request["values"].Split('~'),


        // merge all parameters (union)
        namesAll = names.Concat(addtionNames).ToArray(),
        valuesAll = values.Concat(addtionValues).ToArray();


        // get all of data.
        var _ds = new Select().SelectLists(Context.Request["funName"], namesAll, valuesAll);

        // return data as xml
        return LZStringUpdated.compressToUTF16(_ds.GetXml());
    }
    #endregion

    #region "Profile"
    [WebMethod]
    public static object GetProfile()
    {
        // create filter paramters
        string[,] _params = { { "ClientID", SessionManager.Current.ID } };
        // get all of data.
        var _ds = new Select().SelectLists("Clients_SelectRow", _params);
        string compressedXML = TrimmerUtil.RemoveSpaces(_ds.GetXml());
        return compressedXML;
    }

    #endregion

    #region "Clients Login"

    [WebMethod]
    public static object login(string text1, string text2)
    {
        // create filter paramters
        //string _pass = EncryptDecryptString.Encrypt(text2, "Taj$$Key");
        string[,] _params = { { "Username", text1 }, { "Password", text2 } };

        // get all of data.
        var _ds = new Select().SelectLists("Clients_Login", _params);
        var dt = _ds.Tables[0];

        object result = new { Status = false, Name = "" };

        if (dt.Rows.Count > 0)
        {
            SessionManager.Current.ID = string.Format("{0}", dt.Rows[0][0]);
            SessionManager.Current.Name = string.Format("{0}", dt.Rows[0][1]);
            CookiesManager.SaveCoockie();

            result = new
            {
                Status = true,
                Name = SessionManager.Current.Name
            };
        }
        return result;
    }

    [WebMethod]
    public static object checklogin()
    {
        object ob = new { Name = SessionManager.Current.Name };
        return ob;
    }

    [WebMethod]
    public static object forgetpassword(string email)
    {
        string[,] _params = { { "Email", email } };

        // get all of data.
        var _ds = new Select().SelectLists("Clients_Password", _params);
        var dt = _ds.Tables[0];

        var result = new { Status = false };

        if (dt.Rows.Count > 0)
        {
            string name = string.Format("{0}", dt.Rows[0][0]),
               pass = string.Format("{0}", dt.Rows[0][1]),
               full = string.Format("{0}", dt.Rows[0][2]);

            // recover pass
            var mail = new SendEmail();
            var _body = new api_data().CreateEmailStr(name, pass, full);
            var checkSent = mail.SendNow("eng.msalah.abdullah@gmail.com", email, Resources.Resource_ar.PasswordForget, _body);
            result = new
            {
                Status = checkSent,
            };
        }

        return result;
    }

    public string CreateEmailStr(string Name, string pass, string full)
    {
        string strBody = new SendEmail().ReadTemplate(Server.MapPath("~/Templates/password.html"));
        strBody = strBody.Replace("@@Username@@", Name);
        strBody = strBody.Replace("@@Password@@", pass);
        strBody = strBody.Replace("@@Full@@", full);

        return strBody;
    }
    [WebMethod]
    public static object SendFriend(string[] values)
    {
        string name = string.Format("{0}", values[0]),
               email = string.Format("{0}", values[1]),
               comment = string.Format("{0}", values[2]),
               id = string.Format("{0}", values[3]),
               img = string.Format("{0}", values[4]),
               car = string.Format("{0}", values[5]);

        // recover pass
        var mail = new SendEmail();
        var _body = new api_data().CreateEmailFriend(name, id, car, img, comment);
        var checkSent = mail.SendNow("eng.msalah.abdullah@gmail.com", email, Resources.Resource_ar.FriendMail, _body);

        var result = new
        {
            Status = checkSent,
        };
        return result;
    }

    private string CreateEmailFriend(string name, string id, string car, string img, string comment)
    {
        string strBody = new SendEmail().ReadTemplate(Server.MapPath("~/Templates/sendcar.html"));
        strBody = strBody.Replace("@@Name@@", name);
        strBody = strBody.Replace("@@ID@@", id);
        strBody = strBody.Replace("@@Car@@", car.Replace(" ", "-"));
        strBody = strBody.Replace("@@IMG@@", img);
        strBody = strBody.Replace("@@Comment@@", comment);

        return strBody;
    }

    #endregion

    #region "Home Methods"

    [WebMethod]
    public static string GetHomeList(string pageIndex, string maker, string type)
    {
        // create filter paramters
        string actionName = "SiteGetHomeCars";
        string[,] _params = { { "PageIndex", pageIndex }, { "Maker", maker }, { "PageSize", "6" }, { "Type", type } };

        // get all of data.
        var _ds = new Select().SelectPagedList(actionName, _params);
        string compressedXML = TrimmerUtil.RemoveSpaces(_ds.GetXml());
        return compressedXML;
    }

    #endregion

    #region "Payments"

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public static object LoadPayments()
    {
        jQueryDataTableParamModel param = new jQueryDataTableParamModel();
        HttpContext Context = HttpContext.Current;
        param.sEcho = String.IsNullOrEmpty(Context.Request["sEcho"]) ? 0 : Convert.ToInt32(Context.Request["sEcho"]);
        param.iDisplayStart += String.IsNullOrEmpty(Context.Request["iDisplayStart"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayStart"]);
        param.iDisplayLength = String.IsNullOrEmpty(Context.Request["iDisplayLength"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayLength"]);
        var sortColumnIndex = Convert.ToInt32(Context.Request["iSortCol_0"]);
        var sortDirection = Context.Request["sSortDir_0"];// asc or desc          

        param.sSearch = String.IsNullOrEmpty(Context.Request["sSearch"]) ? "" : Context.Request["sSearch"];
        //var clientID = String.IsNullOrEmpty(Context.Request["ClientID"]) ? "" : Context.Request["ClientID"];
        var customCo = String.IsNullOrEmpty(Context.Request["CustomCo"]) ? "" : Context.Request["CustomCo"];
        string from = String.IsNullOrEmpty(Context.Request["From"]) ? null : Convert.ToDateTime(Context.Request["From"]).ToShortDateString();
        string to = String.IsNullOrEmpty(Context.Request["To"]) ? null : Convert.ToDateTime(Context.Request["To"]).ToShortDateString();

        // create filter paramters
        string[,] _params = {{"DisplayStart",param.iDisplayStart.ToString()},
                                {"DisplayLength", param.iDisplayLength.ToString()},
                                {"SearchParam", param.sSearch},
                                {"SortColumn", sortColumnIndex.ToString()},
                                {"SortDirection", sortDirection},
                                {"ClientID", SessionManager.Current.ID},
                                {"CustomID", customCo}, {"From", from}, {"To", to}};

        // get all of data.
        var _ds = new Select().SelectLists("ClientsPayments_SelectList", _params);

        // inhance data to be list.
        var rows = DataUtilities.ConvertDTToList(_ds.Tables[0]);

        var data = new
        {
            sEcho = param.sEcho,
            iTotalRecords = _ds.Tables[1].Rows[0][0],
            iTotalDisplayRecords = _ds.Tables[1].Rows[0][0],
            aaData = rows.ToList()
        };

        return data;
    }

    [WebMethod] // datatables cars control
    [ScriptMethod(UseHttpGet = true)]
    public static object LoadCars()
    {
        jQueryDataTableParamModel param = new jQueryDataTableParamModel();
        HttpContext Context = HttpContext.Current;
        param.sEcho = String.IsNullOrEmpty(Context.Request["sEcho"]) ? 0 : Convert.ToInt32(Context.Request["sEcho"]);
        param.iDisplayStart += String.IsNullOrEmpty(Context.Request["iDisplayStart"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayStart"]);
        param.iDisplayLength = String.IsNullOrEmpty(Context.Request["iDisplayLength"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayLength"]);
        var sortColumnIndex = Convert.ToInt32(Context.Request["iSortCol_0"]);
        var sortDirection = Context.Request["sSortDir_0"];
        var finished = Context.Request["finish"] ?? "1";

        param.sSearch = String.IsNullOrEmpty(Context.Request["sSearch"]) ? "" : Context.Request["sSearch"];

        // create filter paramters
        string[,] _params = {{"DisplayStart",param.iDisplayStart.ToString()},
                             {"DisplayLength", param.iDisplayLength.ToString()},
                             {"SearchParam", param.sSearch}, {"SortColumn", sortColumnIndex.ToString()},
                             {"SortDirection", sortDirection}, {"ClientID", SessionManager.Current.ID},
                             {"IsDone", finished}};

        // get all of data.
        var _ds = new Select().SelectLists("ClientCars_SelectList", _params);

        // inhance data to be list.
        var rows = DataUtilities.ConvertDTToList(_ds.Tables[0]);

        var data = new
        {
            sEcho = param.sEcho,
            iTotalRecords = _ds.Tables[1].Rows[0][0],
            iTotalDisplayRecords = _ds.Tables[1].Rows[0][0],
            aaData = rows.ToList(),
            Client = new { full_name = _ds.Tables[2].Rows[0][0], Balance = _ds.Tables[2].Rows[0][3], ClientRequired = _ds.Tables[2].Rows[0][4] } //_ds.GetXml()
        };

        return data;
    }

    [WebMethod] // datatables cars control
    [ScriptMethod(UseHttpGet = true)]
    public static object ClientCars4Sale()
    {
        jQueryDataTableParamModel param = new jQueryDataTableParamModel();
        HttpContext Context = HttpContext.Current;
        param.sEcho = String.IsNullOrEmpty(Context.Request["sEcho"]) ? 0 : Convert.ToInt32(Context.Request["sEcho"]);
        param.iDisplayStart += String.IsNullOrEmpty(Context.Request["iDisplayStart"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayStart"]);
        param.iDisplayLength = String.IsNullOrEmpty(Context.Request["iDisplayLength"]) ? 0 : Convert.ToInt32(Context.Request["iDisplayLength"]);
        var sortColumnIndex = Convert.ToInt32(Context.Request["iSortCol_0"]);
        var sortDirection = Context.Request["sSortDir_0"];

        param.sSearch = String.IsNullOrEmpty(Context.Request["sSearch"]) ? "" : Context.Request["sSearch"];

        // create filter paramters
        string[,] _params = {{"DisplayStart",param.iDisplayStart.ToString()},
                             {"DisplayLength", param.iDisplayLength.ToString()},
                             {"SearchParam", param.sSearch}, {"SortColumn", sortColumnIndex.ToString()},
                             {"SortDirection", sortDirection}, {"ClientID", SessionManager.Current.ID}};

        // get all of data.
        var _ds = new Select().SelectLists("ClientCars_SelectList4Sale", _params);

        // inhance data to be list.
        var rows = DataUtilities.ConvertDTToList(_ds.Tables[0]);

        var data = new
        {
            sEcho = param.sEcho,
            iTotalRecords = _ds.Tables[1].Rows[0][0],
            iTotalDisplayRecords = _ds.Tables[1].Rows[0][0],
            aaData = rows.ToList()
        };

        return data;
    }
    #endregion

    #region "Car Images"
    [WebMethod] // car images
    public static ArrayList ShowCarImages(string id)
    {
        var context = HttpContext.Current;
        var dir = new DirectoryInfo(context.Server.MapPath(string.Format("~/public/cars/{0}/", id)));
        var imgs = new ArrayList();

        if (dir.Exists)
        {
            var files = dir.GetFiles();
            for (int i = 0; i < files.Count(); i++)
            {
                imgs.Add(files[i].Name);
            }
        }
        return imgs;
    }

    #endregion

    #region "Search Cars"
    [WebMethod]
    public static string GetCarsList(string[] param, string[] values)
    {
        // get all of data.
        var _ds = new Select().SelectPagedList("SiteSearchCars", param, values);
        string compressedXML = TrimmerUtil.RemoveSpaces(_ds.GetXml());
        return compressedXML;
    }

    #endregion

    [WebMethod]
    public static string decryptPassword(string value)
    {
        string _pass = EncryptDecryptString.Decrypt(value, "Taj$$Key");
        return _pass;
    }

    [WebMethod]
    public static String InlineEdit(string name, string value, string pk, string table, string id)
    {
        // enhance value
        value = value.Replace("'", " ");
        var isNumeric = !string.IsNullOrEmpty(value) && value.Replace(".", "").All(Char.IsDigit);
        if (!isNumeric)
        {
            value = string.Format("'{0}'", value);
        }

        // genrate update sql string
        string sqlStr = string.Format("Update {0} SET {1}={2} WHERE {3}={4}", table, name, value, id, pk);
        var d = new Save().RunSQLString(sqlStr);

        //access params here
        return "Data saved successfully.";
    }


    #region "instance search select2"

    [WebMethod]
    [ScriptMethod(UseHttpGet = true)]
    public static object getSelect2()
    {
        HttpContext Context = HttpContext.Current;
        string pageNum = Context.Request["pageNum"],
               pageSize = Context.Request["pageSize"],
               searchTerm = Context.Request["searchTerm"],
               fnName = Context.Request["fnName"],
               names = Context.Request["names"],
               values = Context.Request["values"];

        // grid static parameters
        string[] defaultNames = { "pageNum", "pageSize", "key" },
                 defaultValues = { pageNum, pageSize, searchTerm },

        // get dynamic more parameters from user
        addtionNames = string.IsNullOrEmpty(names) ? new string[0] : names.Split('~'),
        addtionValues = string.IsNullOrEmpty(values) ? new string[0] : values.Split('~'),

        // merge all parameters (union)
        namesAll = defaultNames.Concat(addtionNames).ToArray(),
        valuesAll = defaultValues.Concat(addtionValues).ToArray();

        var _ds = new Select().SelectLists(fnName, namesAll, valuesAll);
        return LZStringUpdated.compressToUTF16(_ds.GetXml());
    }

    #endregion
}