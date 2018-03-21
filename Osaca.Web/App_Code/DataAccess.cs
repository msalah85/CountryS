using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Configuration;

/// <summary>
/// Summary description for DataAccess
/// </summary>
public class DataAccess
{
    public static SqlCommand CreateCommand()
    {
        string connnectionString = ConfigurationManager.ConnectionStrings["Aliraqcars.Domain.Properties.Settings.AliraqCarsConnectionString"].ConnectionString;
        SqlConnection connection = new SqlConnection(connnectionString);

        SqlCommand command = connection.CreateCommand();
        command.CommandType = CommandType.StoredProcedure;
        return command;
    }

    public static SqlCommand CreateCommandText()
    {
        string connnectionString = ConfigurationManager.ConnectionStrings["Aliraqcars.Domain.Properties.Settings.AliraqCarsConnectionString"].ConnectionString;
        SqlConnection connection = new SqlConnection(connnectionString);

        SqlCommand command = connection.CreateCommand();
        command.CommandType = CommandType.Text;
        return command;
    }
}