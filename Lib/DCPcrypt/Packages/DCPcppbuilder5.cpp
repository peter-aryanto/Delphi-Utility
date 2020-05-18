//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("DCPcppbuilder5.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("..\Source\DCPbase64.pas");
USEUNIT("..\Source\DCPblockciphers.pas");
USEUNIT("..\Source\DCPconst.pas");
USEUNIT("..\Source\DCPcrypt2.pas");
USEUNIT("..\Source\DCPreg.pas");
USEUNIT("..\Source\Ciphers\DCPblowfish.pas");
USEUNIT("..\Source\Ciphers\DCPcast128.pas");
USEUNIT("..\Source\Ciphers\DCPcast256.pas");
USEUNIT("..\Source\Ciphers\DCPdes.pas");
USEUNIT("..\Source\Ciphers\DCPgost.pas");
USEUNIT("..\Source\Ciphers\DCPice.pas");
USEUNIT("..\Source\Ciphers\DCPidea.pas");
USEUNIT("..\Source\Ciphers\DCPmars.pas");
USEUNIT("..\Source\Ciphers\DCPmisty1.pas");
USEUNIT("..\Source\Ciphers\DCPrc2.pas");
USEUNIT("..\Source\Ciphers\DCPrc4.pas");
USEUNIT("..\Source\Ciphers\DCPrc5.pas");
USEUNIT("..\Source\Ciphers\DCPrc6.pas");
USEUNIT("..\Source\Ciphers\DCPrijndael.pas");
USEUNIT("..\Source\Ciphers\DCPserpent.pas");
USEUNIT("..\Source\Ciphers\DCPtea.pas");
USEUNIT("..\Source\Ciphers\DCPtwofish.pas");
USEUNIT("..\Source\Hashes\DCPhaval.pas");
USEUNIT("..\Source\Hashes\DCPmd4.pas");
USEUNIT("..\Source\Hashes\DCPmd5.pas");
USEUNIT("..\Source\Hashes\DCPripemd128.pas");
USEUNIT("..\Source\Hashes\DCPripemd160.pas");
USEUNIT("..\Source\Hashes\DCPsha1.pas");
USEUNIT("..\Source\Hashes\DCPsha256.pas");
USEUNIT("..\Source\Hashes\DCPsha512.pas");
USEUNIT("..\Source\Hashes\DCPtiger.pas");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
