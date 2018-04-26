library(RODBC)

args = commandArgs(trailingOnly=TRUE)
servername = args[1]

connectionstring <- paste("driver=ODBC Driver 17 for SQL Server;server=",servername, ";Database=master;Trusted_Connection=yes", sep = "")

print("Hello world")

sql<-c("select name from sys.databases")
tryCatch({
  ch<-odbcDriverConnect(connectionstring)

  res<-sqlQuery(ch,sql)
  print("success")
  },error = function(e) {
  print(e)
    print(odbcGetErrMsg(ch))
      print("error")
  })
  
head(res, n = 20L)
  
odbcClose(ch)