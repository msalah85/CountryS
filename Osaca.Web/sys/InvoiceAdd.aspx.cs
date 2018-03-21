using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Services;
using System.Web.Services;
using System.Xml;

public partial class sys_InvoiceAdd : System.Web.UI.Page
{
    [WebMethod]
    [ScriptMethod(UseHttpGet = false)]
    public static object SaveDataMasterDetails(string[] fieldsMaster, string[] valuesMaster, string[] fieldsDetails, string[] valuesDetails)
    {
        XmlDocument xmldoc = new XmlDocument();
        XmlElement doc = xmldoc.CreateElement("doc");
        xmldoc.AppendChild(doc);
        XmlElement xmlelement = xmldoc.CreateElement("Master");
        doc.AppendChild(xmlelement);

        for (int i = 0; i < valuesMaster.Length; i++)
        {
            xmlelement.SetAttribute(fieldsMaster[i], valuesMaster[i]);
        }

        for (int i = 0; i < valuesDetails.Length; i++)
        {
            XmlElement xmlelementDetails = xmldoc.CreateElement("Details");
            doc.AppendChild(xmlelementDetails);
            xmlelementDetails.SetAttribute(fieldsMaster[0], valuesMaster[0]);

            if (valuesDetails[0].Contains("لاتوجــد بيانات متاحة"))
            {
                for (int j = 0; j < fieldsDetails.Length; j++)
                {
                    xmlelementDetails.SetAttribute(fieldsDetails[j], "");
                }
            }
            else
            {
                for (int j = 0; j < fieldsDetails.Length; j++)
                {
                    string[] dataes = valuesDetails[i].Split(',');
                    xmlelementDetails.SetAttribute(fieldsDetails[j], dataes[j]);
                }
            }
        }

        object data = new { };

        SqlCommand command = DataAccess.CreateCommand();

        try
        {
            command.CommandText = "Invoices_Save";
            command.Parameters.AddWithValue("@doc", xmldoc.OuterXml);
            var returnParameter = command.Parameters.Add("RetVal", SqlDbType.Int);
            returnParameter.Direction = ParameterDirection.ReturnValue;
            
            int result = -1;
            command.Connection.Open();
            result = command.ExecuteNonQuery();
            if (result > -1)
            {
                data = new
                {
                    ID = returnParameter.Value,
                    Status = true,
                    message = "Data saved."
                };
            }
            else
            {
                data = new
                {
                    ID = -1,
                    Status = true,
                    message = "saving Error, contact administrator."
                };
            }
        }
        catch (Exception ex)
        {
            data = new { ID = 0, status = false, message = ex.Message };
        }
        finally
        {
            command.Connection.Close();
        }
        return data;
    }

}