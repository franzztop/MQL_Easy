//+------------------------------------------------------------------+
//|                                                    ErrorBase.mqh |
//|                           Copyright 2018, Dionisis Nikolopoulos. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Dionisis Nikolopoulos."
#property link      ""
#property version   "1.00"



#include "../../Printer/Printer.mqh"

//+------------------------------------------------------------------+
//|                     Error Class
//+------------------------------------------------------------------+
class CErrorBase
{
protected:
   int               Retcode;
   string            LastErrorCustom;
   int               LastErrorCode;
   CPrinter          Printer;

   
public:  
                     CErrorBase();
                    ~CErrorBase();       
   virtual string    ErrorDescr(int errorCodePar){return "";}
   virtual string    RetcodeDescr(int retcodePar){return "";}                 
   bool              CreateErrorCustom(string msgPar,bool printLastErrorPar = false, bool msgBoxPar = false, 
                                 string functionSigPar = NULL, int linePar = 0, string pathPar = NULL, int retcodePar = -1); 
   int               GetRetcode(){return this.Retcode;}                                                                
   string            GetLastErrorCustom(){return this.LastErrorCustom;}     
   bool              CheckLastError(bool printErrorPar = false, string functionSignaturePar = "");
   int               GetLastErrorCode(){return LastErrorCode;}     
   void              Copy(CErrorBase &errorPar);
   void              Reset();

};

//+------------------------------------------------------------------+
//|               Constructor                                        |
//+------------------------------------------------------------------+
CErrorBase::CErrorBase()
{
   this.Reset();
}
   
    
//+------------------------------------------------------------------+
//|               DeConstructor                                      |
//+------------------------------------------------------------------+
CErrorBase::~CErrorBase()
{
}


//+-----------------------------------------------+
//|    create a custom error  
//+-----------------------------------------------+
bool CErrorBase::CreateErrorCustom(string msgPar,bool printLastErrorPar = false, bool msgBoxPar = false, 
                                 string functionSigPar = NULL, int linePar = 0, string pathPar = NULL, int retcodePar = -1)
{
   this.Printer.SetTitle("ERROR");
   this.Printer.SetSeparatorKeyValue(" : ");
   this.Printer.Add("Message",msgPar);
   
   //-- Last Error Included
   if(printLastErrorPar){
      int errorTemp        = GetLastError();
      this.LastErrorCode   = errorTemp;
      this.Retcode         = retcodePar;
      this.Printer.Add("Error("+(string)errorTemp+")",this.ErrorDescr(errorTemp));
      if(retcodePar != -1){
         this.Printer.Add("Retcode Error("+(string)retcodePar+")",this.RetcodeDescr(retcodePar));
      }      
      ResetLastError();      
   }
   
   //-- Details Included
   if(functionSigPar != NULL)this.Printer.Add("Function",functionSigPar); 
   if(linePar != 0)this.Printer.Add("Line",(string)linePar);
   if(pathPar != NULL)this.Printer.Add("Path",pathPar);
   //--     
   //-- save to lastError 
   this.LastErrorCustom = this.Printer.GetContent();
   //-- Print
   this.Printer.PrintContent();
   //-- Message Box Included
   if(msgBoxPar)MessageBox(msgPar+"\n For more details go to expert tab. ","Error",MB_ICONINFORMATION);   
   //-- return
   return false;
} 
 


//+------------------------------------------------------------------+
//|    check if an error occurred
//+------------------------------------------------------------------+
bool CErrorBase::CheckLastError(bool printErrorPar = false, string functionSignature = "")
{  
   if(_LastError != 0){
      if(printErrorPar)this.CreateErrorCustom("An error occurred!",true,false,functionSignature);
      ResetLastError();
      return true;
   }
   return false;
}


//+------------------------------------------------------------------+
//|    copy the values of another CErrorBase object
//+------------------------------------------------------------------+
void CErrorBase::Copy(CErrorBase &errorPar)
{
   this.Retcode            = errorPar.GetRetcode();
   this.LastErrorCustom    = errorPar.GetLastErrorCustom();
   this.LastErrorCode      = errorPar.GetLastErrorCode();
}


//+------------------------------------------------------------------+
//|    reset the properties 
//+------------------------------------------------------------------+
void CErrorBase::Reset(void)
{
   this.LastErrorCode   = -1;
   this.LastErrorCustom = "";
   this.Retcode         = -1;   
}



  
