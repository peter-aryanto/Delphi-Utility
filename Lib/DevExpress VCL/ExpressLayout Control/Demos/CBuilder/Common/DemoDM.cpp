//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "DemoDM.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "dxmdaset"
#pragma resource "*.dfm"
TdmDemo *dmDemo;
//---------------------------------------------------------------------------
__fastcall TdmDemo::TdmDemo(TComponent* Owner)
	: TDataModule(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TdmDemo::DataModuleCreate(TObject* Sender)
{
   mdOrders->LoadFromBinaryFile(ExtractFilePath(Application->ExeName) + "..\\..\\Data\\OrdersCarsCustomers.dat");
}
