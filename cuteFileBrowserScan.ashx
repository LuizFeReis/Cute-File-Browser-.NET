<%@ WebHandler Language="C#" Class="cuteFileBrowserScan" %>

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;

public class cuteFileBrowserScan : IHttpHandler
{

    //Change this to the directory you want to browse.
    public string rootDirectory = "~/some_folder/root_folder_to_be_browsed";

    public void ProcessRequest(HttpContext context)
    {
        string json = ReturnJSONFiles();
        context.Response.ContentType = "text/json";
        context.Response.Write(json);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    public List<JSONResponse> Scan(DirectoryInfo directory, string currentPath)
    {
        List<JSONResponse> files = new List<JSONResponse>();

        if (directory.Exists)
        {
            int lastSplitIndex = directory.FullName.LastIndexOf("\\") + 1;
            string directoryConcatenation = directory.FullName.Substring(lastSplitIndex, (directory.FullName.Length - lastSplitIndex));
            directoryConcatenation = directoryConcatenation.Replace('\\', '/');
            if (!string.IsNullOrEmpty(currentPath))
            {
                directoryConcatenation = currentPath + "/" + directoryConcatenation;
            }

            foreach (DirectoryInfo subFolder in directory.GetDirectories())
            {
                string folderPath = (directoryConcatenation + "/" + subFolder.Name);
                files.Add(new JSONResponse { name = subFolder.Name, type = "folder", path = folderPath, items = Scan(subFolder, directoryConcatenation) });
            }

            foreach (FileInfo file in directory.GetFiles())
            {
                string filePath = (directoryConcatenation + "/" + file.Name);
                files.Add(new JSONResponse { name = file.Name, type = "file", path = filePath, size = file.Length.ToString() });
            }
        }
        return files;
    }

    public string ReturnJSONFiles()
    {
        string directory = HttpContext.Current.Server.MapPath(rootDirectory);
        int lastSplitIndex = directory.LastIndexOf("\\") + 1;
        string folderName = directory.Substring(lastSplitIndex, (directory.Length - lastSplitIndex));
        DirectoryInfo rootFolder = new DirectoryInfo(directory);
        List<JSONResponse> itens = Scan(rootFolder, "");
        JSONResponse jsonRoot = new JSONResponse { name = folderName, type = "folder", path = folderName, items = itens };
        var retorno = new JavaScriptSerializer().Serialize(jsonRoot);
        return retorno;
    }

    public class JSONResponse
    {
        public string name;
        public string type;
        public string path;
        public string size;
        public List<JSONResponse> items;
    }

}
