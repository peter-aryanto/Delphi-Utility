unit Winapi.NCrypt;

interface

uses
  Windows, Winapi.BCrypt;

{$IF not DECLARED(PVOID)}
type
  PVOID = Pointer;
  {$EXTERNALSYM PVOID}
{$IFEND}

{$IF not DECLARED(LPVOID)}
type
  LPVOID = Pointer;
  {$EXTERNALSYM LPVOID}
{$IFEND}

{$IF not DECLARED(SIZE_T)}
type
  SIZE_T = ULONG_PTR;
  {$EXTERNALSYM SIZE_T}
{$IFEND}

{$IF not DECLARED(LONG)}
type
  LONG = Integer;
  {$EXTERNALSYM LONG}
{$IFEND}

{$REGION 'ncrypt.h'}

{$MINENUMSIZE 4}
{$WARN SYMBOL_PLATFORM OFF}

{$HPPEMIT '#include <ncrypt.h>'}

{$IF not DECLARED(SECURITY_STATUS)}
type
  SECURITY_STATUS = LONG;
  {$EXTERNALSYM SECURITY_STATUS}
{$IFEND}

{$IF not DECLARED(HCRYPTPROV)}
type
  HCRYPTPROV = ULONG_PTR;
  {$EXTERNALSYM HCRYPTPROV}
  HCRYPTKEY = ULONG_PTR;
  {$EXTERNALSYM HCRYPTKEY}
  HCRYPTHASH = ULONG_PTR;
  {$EXTERNALSYM HCRYPTHASH}
{$IFEND}

//
// Maximum length of Key name, in characters
//
const
  NCRYPT_MAX_KEY_NAME_LENGTH     = 512;
  {$EXTERNALSYM NCRYPT_MAX_KEY_NAME_LENGTH}

//
// Maximum length of Algorithm name, in characters
//
const
  NCRYPT_MAX_ALG_ID_LENGTH       = 512;
  {$EXTERNALSYM NCRYPT_MAX_ALG_ID_LENGTH}

(****************************************************************************

  NCRYPT memory management routines for functions that require
  the caller to allocate memory

****************************************************************************)
type
  PFN_NCRYPT_ALLOC = function(
    cbSize: SIZE_T
    ): LPVOID; winapi;
  {$EXTERNALSYM PFN_NCRYPT_ALLOC}
  TFnNCryptAlloc = PFN_NCRYPT_ALLOC;

type
  PFN_NCRYPT_FREE = procedure(
    pv: LPVOID
    ); winapi;
  {$EXTERNALSYM PFN_NCRYPT_FREE}
  TFnNCryptFree = PFN_NCRYPT_FREE;

  PNCryptAllocPara = ^TNCryptAllocPara;
  NCRYPT_ALLOC_PARA = record
    cbSize: DWORD;                        // size of this structure
    pfnAlloc: TFnNCryptAlloc;
    pfnFree: TFnNCryptFree;
  end;
  {$EXTERNALSYM NCRYPT_ALLOC_PARA}
  TNCryptAllocPara = NCRYPT_ALLOC_PARA;

//
// Microsoft built-in providers.
//
const
  MS_KEY_STORAGE_PROVIDER            = 'Microsoft Software Key Storage Provider';
  {$EXTERNALSYM MS_KEY_STORAGE_PROVIDER}
  MS_SMART_CARD_KEY_STORAGE_PROVIDER = 'Microsoft Smart Card Key Storage Provider';
  {$EXTERNALSYM MS_SMART_CARD_KEY_STORAGE_PROVIDER}
  MS_PLATFORM_KEY_STORAGE_PROVIDER   = 'Microsoft Platform Crypto Provider';
  {$EXTERNALSYM MS_PLATFORM_KEY_STORAGE_PROVIDER}

//
// Common algorithm identifiers.
//
const
  NCRYPT_RSA_ALGORITHM           = BCRYPT_RSA_ALGORITHM;
  {$EXTERNALSYM NCRYPT_RSA_ALGORITHM}
  NCRYPT_RSA_SIGN_ALGORITHM      = BCRYPT_RSA_SIGN_ALGORITHM;
  {$EXTERNALSYM NCRYPT_RSA_SIGN_ALGORITHM}
  NCRYPT_DH_ALGORITHM            = BCRYPT_DH_ALGORITHM;
  {$EXTERNALSYM NCRYPT_DH_ALGORITHM}
  NCRYPT_DSA_ALGORITHM           = BCRYPT_DSA_ALGORITHM;
  {$EXTERNALSYM NCRYPT_DSA_ALGORITHM}
  NCRYPT_MD2_ALGORITHM           = BCRYPT_MD2_ALGORITHM;
  {$EXTERNALSYM NCRYPT_MD2_ALGORITHM}
  NCRYPT_MD4_ALGORITHM           = BCRYPT_MD4_ALGORITHM;
  {$EXTERNALSYM NCRYPT_MD4_ALGORITHM}
  NCRYPT_MD5_ALGORITHM           = BCRYPT_MD5_ALGORITHM;
  {$EXTERNALSYM NCRYPT_MD5_ALGORITHM}
  NCRYPT_SHA1_ALGORITHM          = BCRYPT_SHA1_ALGORITHM;
  {$EXTERNALSYM NCRYPT_SHA1_ALGORITHM}
  NCRYPT_SHA256_ALGORITHM        = BCRYPT_SHA256_ALGORITHM;
  {$EXTERNALSYM NCRYPT_SHA256_ALGORITHM}
  NCRYPT_SHA384_ALGORITHM        = BCRYPT_SHA384_ALGORITHM;
  {$EXTERNALSYM NCRYPT_SHA384_ALGORITHM}
  NCRYPT_SHA512_ALGORITHM        = BCRYPT_SHA512_ALGORITHM;
  {$EXTERNALSYM NCRYPT_SHA512_ALGORITHM}
  NCRYPT_ECDSA_P256_ALGORITHM    = BCRYPT_ECDSA_P256_ALGORITHM;
  {$EXTERNALSYM NCRYPT_ECDSA_P256_ALGORITHM}
  NCRYPT_ECDSA_P384_ALGORITHM    = BCRYPT_ECDSA_P384_ALGORITHM;
  {$EXTERNALSYM NCRYPT_ECDSA_P384_ALGORITHM}
  NCRYPT_ECDSA_P521_ALGORITHM    = BCRYPT_ECDSA_P521_ALGORITHM;
  {$EXTERNALSYM NCRYPT_ECDSA_P521_ALGORITHM}
  NCRYPT_ECDH_P256_ALGORITHM     = BCRYPT_ECDH_P256_ALGORITHM;
  {$EXTERNALSYM NCRYPT_ECDH_P256_ALGORITHM}
  NCRYPT_ECDH_P384_ALGORITHM     = BCRYPT_ECDH_P384_ALGORITHM;
  {$EXTERNALSYM NCRYPT_ECDH_P384_ALGORITHM}
  NCRYPT_ECDH_P521_ALGORITHM     = BCRYPT_ECDH_P521_ALGORITHM;
  {$EXTERNALSYM NCRYPT_ECDH_P521_ALGORITHM}

  NCRYPT_AES_ALGORITHM           = BCRYPT_AES_ALGORITHM;
  {$EXTERNALSYM NCRYPT_AES_ALGORITHM}
  NCRYPT_RC2_ALGORITHM           = BCRYPT_RC2_ALGORITHM;
  {$EXTERNALSYM NCRYPT_RC2_ALGORITHM}
  NCRYPT_3DES_ALGORITHM          = BCRYPT_3DES_ALGORITHM;
  {$EXTERNALSYM NCRYPT_3DES_ALGORITHM}
  NCRYPT_DES_ALGORITHM           = BCRYPT_DES_ALGORITHM;
  {$EXTERNALSYM NCRYPT_DES_ALGORITHM}
  NCRYPT_DESX_ALGORITHM          = BCRYPT_DESX_ALGORITHM;
  {$EXTERNALSYM NCRYPT_DESX_ALGORITHM}
  NCRYPT_3DES_112_ALGORITHM      = BCRYPT_3DES_112_ALGORITHM;
  {$EXTERNALSYM NCRYPT_3DES_112_ALGORITHM}

  NCRYPT_SP800108_CTR_HMAC_ALGORITHM = BCRYPT_SP800108_CTR_HMAC_ALGORITHM;
  {$EXTERNALSYM NCRYPT_SP800108_CTR_HMAC_ALGORITHM}
  NCRYPT_SP80056A_CONCAT_ALGORITHM   = BCRYPT_SP80056A_CONCAT_ALGORITHM;
  {$EXTERNALSYM NCRYPT_SP80056A_CONCAT_ALGORITHM}
  NCRYPT_PBKDF2_ALGORITHM            = BCRYPT_PBKDF2_ALGORITHM;
  {$EXTERNALSYM NCRYPT_PBKDF2_ALGORITHM}
  NCRYPT_CAPI_KDF_ALGORITHM          = BCRYPT_CAPI_KDF_ALGORITHM;
  {$EXTERNALSYM NCRYPT_CAPI_KDF_ALGORITHM}

  NCRYPT_KEY_STORAGE_ALGORITHM           = 'KEY_STORAGE';
  {$EXTERNALSYM NCRYPT_KEY_STORAGE_ALGORITHM}

//
// Interfaces
//
const
  NCRYPT_CIPHER_INTERFACE                = BCRYPT_CIPHER_INTERFACE;
  {$EXTERNALSYM NCRYPT_CIPHER_INTERFACE}
  NCRYPT_HASH_INTERFACE                  = BCRYPT_HASH_INTERFACE;
  {$EXTERNALSYM NCRYPT_HASH_INTERFACE}
  NCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE = BCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE;
  {$EXTERNALSYM NCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE}
  NCRYPT_SECRET_AGREEMENT_INTERFACE      = BCRYPT_SECRET_AGREEMENT_INTERFACE;
  {$EXTERNALSYM NCRYPT_SECRET_AGREEMENT_INTERFACE}
  NCRYPT_SIGNATURE_INTERFACE             = BCRYPT_SIGNATURE_INTERFACE;
  {$EXTERNALSYM NCRYPT_SIGNATURE_INTERFACE}
  NCRYPT_KEY_DERIVATION_INTERFACE        = BCRYPT_KEY_DERIVATION_INTERFACE;
  {$EXTERNALSYM NCRYPT_KEY_DERIVATION_INTERFACE}

  NCRYPT_KEY_STORAGE_INTERFACE           = $00010001;
  {$EXTERNALSYM NCRYPT_KEY_STORAGE_INTERFACE}
  NCRYPT_SCHANNEL_INTERFACE              = $00010002;
  {$EXTERNALSYM NCRYPT_SCHANNEL_INTERFACE}
  NCRYPT_SCHANNEL_SIGNATURE_INTERFACE    = $00010003;
  {$EXTERNALSYM NCRYPT_SCHANNEL_SIGNATURE_INTERFACE}
  NCRYPT_KEY_PROTECTION_INTERFACE        = $00010004;
  {$EXTERNALSYM NCRYPT_KEY_PROTECTION_INTERFACE}

//
// algorithm groups.
//
const
  NCRYPT_RSA_ALGORITHM_GROUP             = NCRYPT_RSA_ALGORITHM;
  {$EXTERNALSYM NCRYPT_RSA_ALGORITHM_GROUP}
  NCRYPT_DH_ALGORITHM_GROUP              = NCRYPT_DH_ALGORITHM;
  {$EXTERNALSYM NCRYPT_DH_ALGORITHM_GROUP}
  NCRYPT_DSA_ALGORITHM_GROUP             = NCRYPT_DSA_ALGORITHM;
  {$EXTERNALSYM NCRYPT_DSA_ALGORITHM_GROUP}
  NCRYPT_ECDSA_ALGORITHM_GROUP           = 'ECDSA';
  {$EXTERNALSYM NCRYPT_ECDSA_ALGORITHM_GROUP}
  NCRYPT_ECDH_ALGORITHM_GROUP            = 'ECDH';
  {$EXTERNALSYM NCRYPT_ECDH_ALGORITHM_GROUP}

  NCRYPT_AES_ALGORITHM_GROUP             = NCRYPT_AES_ALGORITHM;
  {$EXTERNALSYM NCRYPT_AES_ALGORITHM_GROUP}
  NCRYPT_RC2_ALGORITHM_GROUP             = NCRYPT_RC2_ALGORITHM;
  {$EXTERNALSYM NCRYPT_RC2_ALGORITHM_GROUP}
  NCRYPT_DES_ALGORITHM_GROUP             = 'DES';
  {$EXTERNALSYM NCRYPT_DES_ALGORITHM_GROUP}
  NCRYPT_KEY_DERIVATION_GROUP            = 'KEY_DERIVATION';
  {$EXTERNALSYM NCRYPT_KEY_DERIVATION_GROUP}

//
// NCrypt generic memory descriptors
//
const
  NCRYPTBUFFER_VERSION                       = 0;
  {$EXTERNALSYM NCRYPTBUFFER_VERSION}

  NCRYPTBUFFER_EMPTY                         = 0;
  {$EXTERNALSYM NCRYPTBUFFER_EMPTY}
  NCRYPTBUFFER_DATA                          = 1;
  {$EXTERNALSYM NCRYPTBUFFER_DATA}
  NCRYPTBUFFER_PROTECTION_DESCRIPTOR_STRING  = 3;   // The buffer contains a null-terminated Unicode string that contains the Protection Descriptor.
  {$EXTERNALSYM NCRYPTBUFFER_PROTECTION_DESCRIPTOR_STRING}
  NCRYPTBUFFER_PROTECTION_FLAGS              = 4;   // DWORD flags to be passed to NCryptCreateProtectionDescriptor function.
  {$EXTERNALSYM NCRYPTBUFFER_PROTECTION_FLAGS}

  NCRYPTBUFFER_SSL_CLIENT_RANDOM             = 20;
  {$EXTERNALSYM NCRYPTBUFFER_SSL_CLIENT_RANDOM}
  NCRYPTBUFFER_SSL_SERVER_RANDOM             = 21;
  {$EXTERNALSYM NCRYPTBUFFER_SSL_SERVER_RANDOM }
  NCRYPTBUFFER_SSL_HIGHEST_VERSION           = 22;
  {$EXTERNALSYM NCRYPTBUFFER_SSL_HIGHEST_VERSION}
  NCRYPTBUFFER_SSL_CLEAR_KEY                 = 23;
  {$EXTERNALSYM NCRYPTBUFFER_SSL_CLEAR_KEY}
  NCRYPTBUFFER_SSL_KEY_ARG_DATA              = 24;
  {$EXTERNALSYM NCRYPTBUFFER_SSL_KEY_ARG_DATA}

  NCRYPTBUFFER_PKCS_OID                      = 40;
  {$EXTERNALSYM NCRYPTBUFFER_PKCS_OID}
  NCRYPTBUFFER_PKCS_ALG_OID                  = 41;
  {$EXTERNALSYM NCRYPTBUFFER_PKCS_ALG_OID}
  NCRYPTBUFFER_PKCS_ALG_PARAM                = 42;
  {$EXTERNALSYM NCRYPTBUFFER_PKCS_ALG_PARAM}
  NCRYPTBUFFER_PKCS_ALG_ID                   = 43;
  {$EXTERNALSYM NCRYPTBUFFER_PKCS_ALG_ID}
  NCRYPTBUFFER_PKCS_ATTRS                    = 44;
  {$EXTERNALSYM NCRYPTBUFFER_PKCS_ATTRS}
  NCRYPTBUFFER_PKCS_KEY_NAME                 = 45;
  {$EXTERNALSYM NCRYPTBUFFER_PKCS_KEY_NAME}
  NCRYPTBUFFER_PKCS_SECRET                   = 46;
  {$EXTERNALSYM NCRYPTBUFFER_PKCS_SECRET}

  NCRYPTBUFFER_CERT_BLOB                     = 47;
  {$EXTERNALSYM NCRYPTBUFFER_CERT_BLOB}


// NCRYPT shares the same BCRYPT definitions
type
  NCryptBuffer = BCryptBuffer;
  {$EXTERNALSYM NCryptBuffer}
  PNCryptBuffer = ^BCryptBuffer;
  {$EXTERNALSYM PNCryptBuffer}
  NCryptBufferDesc = BCryptBufferDesc;
  {$EXTERNALSYM NCryptBufferDesc}
  PNCryptBufferDesc = ^BCryptBufferDesc;
  {$EXTERNALSYM PNCryptBufferDesc}

//
// NCrypt handles
//
type
  NCRYPT_HANDLE = ULONG_PTR;
  {$EXTERNALSYM NCRYPT_HANDLE}
  NCRYPT_PROV_HANDLE = ULONG_PTR;
  {$EXTERNALSYM NCRYPT_PROV_HANDLE}
  NCRYPT_KEY_HANDLE = ULONG_PTR;
  {$EXTERNALSYM NCRYPT_KEY_HANDLE}
  NCRYPT_HASH_HANDLE = ULONG_PTR;
  {$EXTERNALSYM NCRYPT_HASH_HANDLE}
  NCRYPT_SECRET_HANDLE = ULONG_PTR;
  {$EXTERNALSYM NCRYPT_SECRET_HANDLE}

//
// NCrypt API Flags
//
const
  NCRYPT_NO_PADDING_FLAG     = $00000001;          // NCryptEncrypt/Decrypt
  {$EXTERNALSYM NCRYPT_NO_PADDING_FLAG}
  NCRYPT_PAD_PKCS1_FLAG      = $00000002;          // NCryptEncrypt/Decrypt NCryptSignHash/VerifySignature
  {$EXTERNALSYM NCRYPT_PAD_PKCS1_FLAG}
  NCRYPT_PAD_OAEP_FLAG       = $00000004;          // BCryptEncrypt/Decrypt
  {$EXTERNALSYM NCRYPT_PAD_OAEP_FLAG}
  NCRYPT_PAD_PSS_FLAG        = $00000008;          // BCryptSignHash/VerifySignature
  {$EXTERNALSYM NCRYPT_PAD_PSS_FLAG}
  NCRYPT_PAD_CIPHER_FLAG     = $00000010;          // NCryptEncrypt/Decrypt
  {$EXTERNALSYM NCRYPT_PAD_CIPHER_FLAG}

type
  PNCryptCipherPaddingInfo = ^TNCryptCipherPaddingInfo;
  _NCRYPT_CIPHER_PADDING_INFO = record
    // size of this struct
    cbSize: ULONG;

    // See NCRYPT_CIPHER_ flag values
    dwFlags: DWORD;

    // [in, out, optional]
    // The address of a buffer that contains the initialization vector (IV) to use during encryption.
    // The cbIV parameter contains the size of this buffer. This function will modify the contents of this buffer.
    // If you need to reuse the IV later, make sure you make a copy of this buffer before calling this function.
    pbIV: PUCHAR;
    cbIV: ULONG;

    // [in, out, optional]
    // The address of a buffer that contains the algorithm specific info to use during encryption.
    // The cbOtherInfo parameter contains the size of this buffer. This function will modify the contents of this buffer.
    // If you need to reuse the buffer later, make sure you make a copy of this buffer before calling this function.
    //
    // For Microsoft providers, when an authenticated encryption mode is used,
    // this parameter must point to a serialized BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO structure.
    //
    // NOTE: All pointers inside a structure must be to a data allocated within pbOtherInfo buffer.
    //
    pbOtherInfo: PUCHAR;
    cbOtherInfo: ULONG;
  end;
  {$EXTERNALSYM _NCRYPT_CIPHER_PADDING_INFO}
  NCRYPT_CIPHER_PADDING_INFO = _NCRYPT_CIPHER_PADDING_INFO;
  {$EXTERNALSYM NCRYPT_CIPHER_PADDING_INFO}
  TNCryptCipherPaddingInfo = _NCRYPT_CIPHER_PADDING_INFO;
  PNCRYPT_CIPHER_PADDING_INFO = PNCryptCipherPaddingInfo;
  {$EXTERNALSYM PNCRYPT_CIPHER_PADDING_INFO}

//
// The following flags are used with NCRYPT_CIPHER_PADDING_INFO
//
const
  NCRYPT_CIPHER_NO_PADDING_FLAG          = $00000000;
  {$EXTERNALSYM NCRYPT_CIPHER_NO_PADDING_FLAG}
  NCRYPT_CIPHER_BLOCK_PADDING_FLAG       = $00000001;
  {$EXTERNALSYM NCRYPT_CIPHER_BLOCK_PADDING_FLAG}
  NCRYPT_CIPHER_OTHER_PADDING_FLAG       = $00000002;
  {$EXTERNALSYM NCRYPT_CIPHER_OTHER_PADDING_FLAG}

  NCRYPT_NO_KEY_VALIDATION               = BCRYPT_NO_KEY_VALIDATION;
  {$EXTERNALSYM NCRYPT_NO_KEY_VALIDATION}
  NCRYPT_MACHINE_KEY_FLAG                = $00000020;  // same as CAPI CRYPT_MACHINE_KEYSET
  {$EXTERNALSYM NCRYPT_MACHINE_KEY_FLAG}
  NCRYPT_SILENT_FLAG                     = $00000040;  // same as CAPI CRYPT_SILENT
  {$EXTERNALSYM NCRYPT_SILENT_FLAG}
  NCRYPT_OVERWRITE_KEY_FLAG              = $00000080;
  {$EXTERNALSYM NCRYPT_OVERWRITE_KEY_FLAG}
  NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG  = $00000200;
  {$EXTERNALSYM NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG}
  NCRYPT_DO_NOT_FINALIZE_FLAG            = $00000400;
  {$EXTERNALSYM NCRYPT_DO_NOT_FINALIZE_FLAG}
  NCRYPT_PERSIST_ONLY_FLAG               = $40000000;
  {$EXTERNALSYM NCRYPT_PERSIST_ONLY_FLAG}
  NCRYPT_PERSIST_FLAG                    = $80000000;
  {$EXTERNALSYM NCRYPT_PERSIST_FLAG}
  NCRYPT_REGISTER_NOTIFY_FLAG            = $00000001;
  {$EXTERNALSYM NCRYPT_REGISTER_NOTIFY_FLAG}
  NCRYPT_UNREGISTER_NOTIFY_FLAG          = $00000002;
  {$EXTERNALSYM NCRYPT_UNREGISTER_NOTIFY_FLAG}


//
// Functions used to manage persisted keys.
//
function NCryptOpenStorageProvider(
  out phProvider: NCRYPT_PROV_HANDLE;
  pszProviderName: LPCWSTR;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptOpenStorageProvider}

// AlgOperations flags for use with NCryptEnumAlgorithms()
const
  NCRYPT_CIPHER_OPERATION                = BCRYPT_CIPHER_OPERATION;
  {$EXTERNALSYM NCRYPT_CIPHER_OPERATION}
  NCRYPT_HASH_OPERATION                  = BCRYPT_HASH_OPERATION;
  {$EXTERNALSYM NCRYPT_HASH_OPERATION}
  NCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION = BCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION;
  {$EXTERNALSYM NCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION}
  NCRYPT_SECRET_AGREEMENT_OPERATION      = BCRYPT_SECRET_AGREEMENT_OPERATION;
  {$EXTERNALSYM NCRYPT_SECRET_AGREEMENT_OPERATION}
  NCRYPT_SIGNATURE_OPERATION             = BCRYPT_SIGNATURE_OPERATION;
  {$EXTERNALSYM NCRYPT_SIGNATURE_OPERATION}
  NCRYPT_RNG_OPERATION                   = BCRYPT_RNG_OPERATION;
  {$EXTERNALSYM NCRYPT_RNG_OPERATION}
  NCRYPT_KEY_DERIVATION_OPERATION        = BCRYPT_KEY_DERIVATION_OPERATION;
  {$EXTERNALSYM NCRYPT_KEY_DERIVATION_OPERATION}

// USE EXTREME CAUTION: editing comments that contain "certenrolls_*" tokens
// could break building CertEnroll idl files:
// certenrolls_begin -- NCryptAlgorithmName
type
  PNCryptAlgorithmName = ^TNCryptAlgorithmName;
  _NCryptAlgorithmName = record
    pszName: LPWSTR;
    dwClass: DWORD;               // the CNG interface that supports this algorithm
    dwAlgOperations: DWORD;       // the types of operations supported by this algorithm
    dwFlags: DWORD;
  end;
  {$EXTERNALSYM _NCryptAlgorithmName}
  NCryptAlgorithmName = _NCryptAlgorithmName;
  {$EXTERNALSYM NCryptAlgorithmName}
  TNCryptAlgorithmName = _NCryptAlgorithmName;
// certenrolls_end

function NCryptEnumAlgorithms(
  hProvider: NCRYPT_PROV_HANDLE;
  dwAlgOperations: DWORD;
  out pdwAlgCount: DWORD;
  out ppAlgList: PNCryptAlgorithmName;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptEnumAlgorithms}

function NCryptIsAlgSupported(
  hProvider: NCRYPT_PROV_HANDLE;
  pszAlgId: LPCWSTR;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptIsAlgSupported}

// NCryptEnumKeys flags
//const
//  NCRYPT_MACHINE_KEY_FLAG        = $00000020;
//  {$EXTERNALSYM NCRYPT_MACHINE_KEY_FLAG}

type
  PNCryptKeyName = ^TNCryptKeyName;
  NCryptKeyName = record
    pszName: LPWSTR;
    pszAlgid: LPWSTR;
    dwLegacyKeySpec: DWORD;
    dwFlags: DWORD;
  end;
  {$EXTERNALSYM NCryptKeyName}
  TNCryptKeyName = NCryptKeyName;

function NCryptEnumKeys(
  hProvider: NCRYPT_PROV_HANDLE;
  pszScope: LPCWSTR;
  out ppKeyName: PNCryptKeyName;
  var ppEnumState: PVOID;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptEnumKeys}

type
  PNCryptProviderName = ^TNCryptProviderName;
  NCryptProviderName = record
    pszName: LPWSTR;
    pszComment: LPWSTR;
  end;
  {$EXTERNALSYM NCryptProviderName}
  TNCryptProviderName = NCryptProviderName;

function NCryptEnumStorageProviders(
  out pdwProviderCount: DWORD;
  out ppProviderList: PNCryptProviderName;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptEnumStorageProviders}

function NCryptFreeBuffer(
  pvInput: PVOID): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptFreeBuffer}

// NCryptOpenKey flags
//const
//  NCRYPT_MACHINE_KEY_FLAG        = $00000020;
//  {$EXTERNALSYM NCRYPT_MACHINE_KEY_FLAG}
//  NCRYPT_SILENT_FLAG             = $00000040;
//  {$EXTERNALSYM NCRYPT_SILENT_FLAG}

function NCryptOpenKey(
  hProvider: NCRYPT_PROV_HANDLE;
  out phKey: NCRYPT_KEY_HANDLE;
  pszKeyName: LPCWSTR;
  dwLegacyKeySpec: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptOpenKey}

// NCryptCreatePersistedKey flags
//const
//  NCRYPT_MACHINE_KEY_FLAG        = $00000020;
//  {$EXTERNALSYM NCRYPT_MACHINE_KEY_FLAG}
//  NCRYPT_OVERWRITE_KEY_FLAG      = $00000080;
//  {$EXTERNALSYM NCRYPT_OVERWRITE_KEY_FLAG}

function NCryptCreatePersistedKey(
  hProvider: NCRYPT_PROV_HANDLE;
  out phKey: NCRYPT_KEY_HANDLE;
  pszAlgId: LPCWSTR;
  pszKeyName: LPCWSTR;
  dwLegacyKeySpec: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptCreatePersistedKey}

// Standard property names.
const
  NCRYPT_NAME_PROPERTY                   = 'Name';
  {$EXTERNALSYM NCRYPT_NAME_PROPERTY}
  NCRYPT_UNIQUE_NAME_PROPERTY            = 'Unique Name';
  {$EXTERNALSYM NCRYPT_UNIQUE_NAME_PROPERTY}
  NCRYPT_ALGORITHM_PROPERTY              = 'Algorithm Name';
  {$EXTERNALSYM NCRYPT_ALGORITHM_PROPERTY}
  NCRYPT_LENGTH_PROPERTY                 = 'Length';
  {$EXTERNALSYM NCRYPT_LENGTH_PROPERTY}
  NCRYPT_LENGTHS_PROPERTY                = 'Lengths';
  {$EXTERNALSYM NCRYPT_LENGTHS_PROPERTY}
  NCRYPT_BLOCK_LENGTH_PROPERTY           = 'Block Length';
  {$EXTERNALSYM NCRYPT_BLOCK_LENGTH_PROPERTY}
  NCRYPT_CHAINING_MODE_PROPERTY          = 'Chaining Mode';
  {$EXTERNALSYM NCRYPT_CHAINING_MODE_PROPERTY}
  NCRYPT_AUTH_TAG_LENGTH                 = 'AuthTagLength';
  {$EXTERNALSYM NCRYPT_AUTH_TAG_LENGTH}
  NCRYPT_UI_POLICY_PROPERTY              = 'UI Policy';
  {$EXTERNALSYM NCRYPT_UI_POLICY_PROPERTY}
  NCRYPT_EXPORT_POLICY_PROPERTY          = 'Export Policy';
  {$EXTERNALSYM NCRYPT_EXPORT_POLICY_PROPERTY}
  NCRYPT_WINDOW_HANDLE_PROPERTY          = 'HWND Handle';
  {$EXTERNALSYM NCRYPT_WINDOW_HANDLE_PROPERTY}
  NCRYPT_USE_CONTEXT_PROPERTY            = 'Use Context';
  {$EXTERNALSYM NCRYPT_USE_CONTEXT_PROPERTY}
  NCRYPT_IMPL_TYPE_PROPERTY              = 'Impl Type';
  {$EXTERNALSYM NCRYPT_IMPL_TYPE_PROPERTY}
  NCRYPT_KEY_USAGE_PROPERTY              = 'Key Usage';
  {$EXTERNALSYM NCRYPT_KEY_USAGE_PROPERTY}
  NCRYPT_KEY_TYPE_PROPERTY               = 'Key Type';
  {$EXTERNALSYM NCRYPT_KEY_TYPE_PROPERTY}
  NCRYPT_VERSION_PROPERTY                = 'Version';
  {$EXTERNALSYM NCRYPT_VERSION_PROPERTY}
  NCRYPT_SECURITY_DESCR_SUPPORT_PROPERTY = 'Security Descr Support';
  {$EXTERNALSYM NCRYPT_SECURITY_DESCR_SUPPORT_PROPERTY}
  NCRYPT_SECURITY_DESCR_PROPERTY         = 'Security Descr';
  {$EXTERNALSYM NCRYPT_SECURITY_DESCR_PROPERTY}
  NCRYPT_USE_COUNT_ENABLED_PROPERTY      = 'Enabled Use Count';
  {$EXTERNALSYM NCRYPT_USE_COUNT_ENABLED_PROPERTY}
  NCRYPT_USE_COUNT_PROPERTY              = 'Use Count';
  {$EXTERNALSYM NCRYPT_USE_COUNT_PROPERTY}
  NCRYPT_LAST_MODIFIED_PROPERTY          = 'Modified';
  {$EXTERNALSYM NCRYPT_LAST_MODIFIED_PROPERTY}
  NCRYPT_MAX_NAME_LENGTH_PROPERTY        = 'Max Name Length';
  {$EXTERNALSYM NCRYPT_MAX_NAME_LENGTH_PROPERTY}
  NCRYPT_ALGORITHM_GROUP_PROPERTY        = 'Algorithm Group';
  {$EXTERNALSYM NCRYPT_ALGORITHM_GROUP_PROPERTY}
  NCRYPT_DH_PARAMETERS_PROPERTY          = BCRYPT_DH_PARAMETERS;
  {$EXTERNALSYM NCRYPT_DH_PARAMETERS_PROPERTY}
  NCRYPT_PROVIDER_HANDLE_PROPERTY        = 'Provider Handle';
  {$EXTERNALSYM NCRYPT_PROVIDER_HANDLE_PROPERTY}
  NCRYPT_PIN_PROPERTY                    = 'SmartCardPin';
  {$EXTERNALSYM NCRYPT_PIN_PROPERTY}
  NCRYPT_READER_PROPERTY                 = 'SmartCardReader';
  {$EXTERNALSYM NCRYPT_READER_PROPERTY}
  NCRYPT_SMARTCARD_GUID_PROPERTY         = 'SmartCardGuid';
  {$EXTERNALSYM NCRYPT_SMARTCARD_GUID_PROPERTY}
  NCRYPT_CERTIFICATE_PROPERTY            = 'SmartCardKeyCertificate';
  {$EXTERNALSYM NCRYPT_CERTIFICATE_PROPERTY}
  NCRYPT_PIN_PROMPT_PROPERTY             = 'SmartCardPinPrompt';
  {$EXTERNALSYM NCRYPT_PIN_PROMPT_PROPERTY}
  NCRYPT_USER_CERTSTORE_PROPERTY         = 'SmartCardUserCertStore';
  {$EXTERNALSYM NCRYPT_USER_CERTSTORE_PROPERTY}
  NCRYPT_ROOT_CERTSTORE_PROPERTY         = 'SmartcardRootCertStore';
  {$EXTERNALSYM NCRYPT_ROOT_CERTSTORE_PROPERTY}
  NCRYPT_SECURE_PIN_PROPERTY             = 'SmartCardSecurePin';
  {$EXTERNALSYM NCRYPT_SECURE_PIN_PROPERTY}
  NCRYPT_ASSOCIATED_ECDH_KEY             = 'SmartCardAssociatedECDHKey';
  {$EXTERNALSYM NCRYPT_ASSOCIATED_ECDH_KEY}
  NCRYPT_SCARD_PIN_ID                    = 'SmartCardPinId';
  {$EXTERNALSYM NCRYPT_SCARD_PIN_ID}
  NCRYPT_SCARD_PIN_INFO                  = 'SmartCardPinInfo';
  {$EXTERNALSYM NCRYPT_SCARD_PIN_INFO}
  NCRYPT_READER_ICON_PROPERTY            = 'SmartCardReaderIcon';
  {$EXTERNALSYM NCRYPT_READER_ICON_PROPERTY}
  NCRYPT_KDF_SECRET_VALUE                = 'KDFKeySecret';
  {$EXTERNALSYM NCRYPT_KDF_SECRET_VALUE}
//
// Additional property strings specific for the Platform Crypto Provider
//
const
  NCRYPT_PCP_PLATFORM_TYPE_PROPERTY                  = 'PCP_PLATFORM_TYPE';
  {$EXTERNALSYM NCRYPT_PCP_PLATFORM_TYPE_PROPERTY}
  NCRYPT_PCP_PROVIDER_VERSION_PROPERTY               = 'PCP_PROVIDER_VERSION';
  {$EXTERNALSYM NCRYPT_PCP_PROVIDER_VERSION_PROPERTY}
  NCRYPT_PCP_EKPUB_PROPERTY                          = 'PCP_EKPUB';
  {$EXTERNALSYM NCRYPT_PCP_EKPUB_PROPERTY}
  NCRYPT_PCP_EKCERT_PROPERTY                         = 'PCP_EKCERT';
  {$EXTERNALSYM NCRYPT_PCP_EKCERT_PROPERTY}
  NCRYPT_PCP_EKNVCERT_PROPERTY                       = 'PCP_EKNVCERT';
  {$EXTERNALSYM NCRYPT_PCP_EKNVCERT_PROPERTY}
  NCRYPT_PCP_SRKPUB_PROPERTY                         = 'PCP_SRKPUB';
  {$EXTERNALSYM NCRYPT_PCP_SRKPUB_PROPERTY}
  NCRYPT_PCP_PCRTABLE_PROPERTY                       = 'PCP_PCRTABLE';
  {$EXTERNALSYM NCRYPT_PCP_PCRTABLE_PROPERTY}
  NCRYPT_PCP_CHANGEPASSWORD_PROPERTY                 = 'PCP_CHANGEPASSWORD';
  {$EXTERNALSYM NCRYPT_PCP_CHANGEPASSWORD_PROPERTY}
  NCRYPT_PCP_PASSWORD_REQUIRED_PROPERTY              = 'PCP_PASSWORD_REQUIRED';
  {$EXTERNALSYM NCRYPT_PCP_PASSWORD_REQUIRED_PROPERTY}
  NCRYPT_PCP_USAGEAUTH_PROPERTY                      = 'PCP_USAGEAUTH';
  {$EXTERNALSYM NCRYPT_PCP_USAGEAUTH_PROPERTY}
  NCRYPT_PCP_MIGRATIONPASSWORD_PROPERTY              = 'PCP_MIGRATIONPASSWORD';
  {$EXTERNALSYM NCRYPT_PCP_MIGRATIONPASSWORD_PROPERTY}
  NCRYPT_PCP_EXPORT_ALLOWED_PROPERTY                 = 'PCP_EXPORT_ALLOWED';
  {$EXTERNALSYM NCRYPT_PCP_EXPORT_ALLOWED_PROPERTY}
  NCRYPT_PCP_STORAGEPARENT_PROPERTY                  = 'PCP_STORAGEPARENT';
  {$EXTERNALSYM NCRYPT_PCP_STORAGEPARENT_PROPERTY}
  NCRYPT_PCP_PROVIDERHANDLE_PROPERTY                 = 'PCP_PROVIDERMHANDLE';
  {$EXTERNALSYM NCRYPT_PCP_PROVIDERHANDLE_PROPERTY}
  NCRYPT_PCP_PLATFORMHANDLE_PROPERTY                 = 'PCP_PLATFORMHANDLE';
  {$EXTERNALSYM NCRYPT_PCP_PLATFORMHANDLE_PROPERTY}
  NCRYPT_PCP_PLATFORM_BINDING_PCRMASK_PROPERTY       = 'PCP_PLATFORM_BINDING_PCRMASK';
  {$EXTERNALSYM NCRYPT_PCP_PLATFORM_BINDING_PCRMASK_PROPERTY}
  NCRYPT_PCP_PLATFORM_BINDING_PCRDIGESTLIST_PROPERTY = 'PCP_PLATFORM_BINDING_PCRDIGESTLIST';
  {$EXTERNALSYM NCRYPT_PCP_PLATFORM_BINDING_PCRDIGESTLIST_PROPERTY}
  NCRYPT_PCP_PLATFORM_BINDING_PCRDIGEST_PROPERTY     = 'PCP_PLATFORM_BINDING_PCRDIGEST';
  {$EXTERNALSYM NCRYPT_PCP_PLATFORM_BINDING_PCRDIGEST_PROPERTY}
  NCRYPT_PCP_KEY_USAGE_POLICY_PROPERTY               = 'PCP_KEY_USAGE_POLICY';
  {$EXTERNALSYM NCRYPT_PCP_KEY_USAGE_POLICY_PROPERTY}
  NCRYPT_PCP_TPM12_IDBINDING_PROPERTY                = 'PCP_TPM12_IDBINDING';
  {$EXTERNALSYM NCRYPT_PCP_TPM12_IDBINDING_PROPERTY}
  NCRYPT_PCP_TPM12_IDACTIVATION_PROPERTY             = 'PCP_TPM12_IDACTIVATION';
  {$EXTERNALSYM NCRYPT_PCP_TPM12_IDACTIVATION_PROPERTY}
  NCRYPT_PCP_KEYATTESTATION_PROPERTY                 = 'PCP_TPM12_KEYATTESTATION';
  {$EXTERNALSYM NCRYPT_PCP_KEYATTESTATION_PROPERTY}
  NCRYPT_PCP_ALTERNATE_KEY_STORAGE_LOCATION_PROPERTY = 'PCP_ALTERNATE_KEY_STORAGE_LOCATION';
  {$EXTERNALSYM NCRYPT_PCP_ALTERNATE_KEY_STORAGE_LOCATION_PROPERTY}
//
// BCRYPT_PCP_KEY_USAGE_POLICY values
//
const
  NCRYPT_TPM12_PROVIDER                 = ($00010000);
  {$EXTERNALSYM NCRYPT_TPM12_PROVIDER}
  NCRYPT_PCP_SIGNATURE_KEY              = ($00000001);
  {$EXTERNALSYM NCRYPT_PCP_SIGNATURE_KEY}
  NCRYPT_PCP_ENCRYPTION_KEY             = ($00000002);
  {$EXTERNALSYM NCRYPT_PCP_ENCRYPTION_KEY}
  NCRYPT_PCP_GENERIC_KEY                = (NCRYPT_PCP_SIGNATURE_KEY or NCRYPT_PCP_ENCRYPTION_KEY);
  {$EXTERNALSYM NCRYPT_PCP_GENERIC_KEY}
  NCRYPT_PCP_STORAGE_KEY                = ($00000004);
  {$EXTERNALSYM NCRYPT_PCP_STORAGE_KEY}
  NCRYPT_PCP_IDENTITY_KEY               = ($00000008);
  {$EXTERNALSYM NCRYPT_PCP_IDENTITY_KEY}

//
// Used to set IV for block ciphers, before calling NCryptEncrypt/NCryptDecrypt
//
const
  NCRYPT_INITIALIZATION_VECTOR           = BCRYPT_INITIALIZATION_VECTOR;
  {$EXTERNALSYM NCRYPT_INITIALIZATION_VECTOR}

// Maximum length of property name (in characters)
const
  NCRYPT_MAX_PROPERTY_NAME        = 64;
  {$EXTERNALSYM NCRYPT_MAX_PROPERTY_NAME}

// Maximum length of property data (in bytes)
const
  NCRYPT_MAX_PROPERTY_DATA        = $100000;
  {$EXTERNALSYM NCRYPT_MAX_PROPERTY_DATA}

// NCRYPT_EXPORT_POLICY_PROPERTY property flags.
const
  NCRYPT_ALLOW_EXPORT_FLAG               = $00000001;
  {$EXTERNALSYM NCRYPT_ALLOW_EXPORT_FLAG}
  NCRYPT_ALLOW_PLAINTEXT_EXPORT_FLAG     = $00000002;
  {$EXTERNALSYM NCRYPT_ALLOW_PLAINTEXT_EXPORT_FLAG}
  NCRYPT_ALLOW_ARCHIVING_FLAG            = $00000004;
  {$EXTERNALSYM NCRYPT_ALLOW_ARCHIVING_FLAG}
  NCRYPT_ALLOW_PLAINTEXT_ARCHIVING_FLAG  = $00000008;
  {$EXTERNALSYM NCRYPT_ALLOW_PLAINTEXT_ARCHIVING_FLAG}

// NCRYPT_IMPL_TYPE_PROPERTY property flags.
const
  NCRYPT_IMPL_HARDWARE_FLAG              = $00000001;
  {$EXTERNALSYM NCRYPT_IMPL_HARDWARE_FLAG}
  NCRYPT_IMPL_SOFTWARE_FLAG              = $00000002;
  {$EXTERNALSYM NCRYPT_IMPL_SOFTWARE_FLAG}
  NCRYPT_IMPL_REMOVABLE_FLAG             = $00000008;
  {$EXTERNALSYM NCRYPT_IMPL_REMOVABLE_FLAG}
  NCRYPT_IMPL_HARDWARE_RNG_FLAG          = $00000010;
  {$EXTERNALSYM NCRYPT_IMPL_HARDWARE_RNG_FLAG}

// NCRYPT_KEY_USAGE_PROPERTY property flags.
const
  NCRYPT_ALLOW_DECRYPT_FLAG              = $00000001;
  {$EXTERNALSYM NCRYPT_ALLOW_DECRYPT_FLAG}
  NCRYPT_ALLOW_SIGNING_FLAG              = $00000002;
  {$EXTERNALSYM NCRYPT_ALLOW_SIGNING_FLAG}
  NCRYPT_ALLOW_KEY_AGREEMENT_FLAG        = $00000004;
  {$EXTERNALSYM NCRYPT_ALLOW_KEY_AGREEMENT_FLAG}
  NCRYPT_ALLOW_ALL_USAGES                = $00ffffff;
  {$EXTERNALSYM NCRYPT_ALLOW_ALL_USAGES}

// NCRYPT_UI_POLICY_PROPERTY property flags and structure
const
  NCRYPT_UI_PROTECT_KEY_FLAG             = $00000001;
  {$EXTERNALSYM NCRYPT_UI_PROTECT_KEY_FLAG}
  NCRYPT_UI_FORCE_HIGH_PROTECTION_FLAG   = $00000002;
  {$EXTERNALSYM NCRYPT_UI_FORCE_HIGH_PROTECTION_FLAG}

type
  PNCryptUIPolicy = ^TNCryptUIPolicy;
  __NCRYPT_UI_POLICY = record
    dwVersion: DWORD;
    dwFlags: DWORD;
    pszCreationTitle: LPCWSTR;
    pszFriendlyName: LPCWSTR;
    pszDescription: LPCWSTR;
  end;
  {$EXTERNALSYM __NCRYPT_UI_POLICY}
  NCRYPT_UI_POLICY = __NCRYPT_UI_POLICY;
  {$EXTERNALSYM NCRYPT_UI_POLICY}
  TNCryptUIPolicy = __NCRYPT_UI_POLICY;

// NCRYPT_LENGTHS_PROPERTY property structure.
type
  PNCryptSupportedLengths = ^TNCryptSupportedLengths;
  __NCRYPT_SUPPORTED_LENGTHS = record
    dwMinLength: DWORD;
    dwMaxLength: DWORD;
    dwIncrement: DWORD;
    dwDefaultLength: DWORD;
  end;
  {$EXTERNALSYM __NCRYPT_SUPPORTED_LENGTHS}
  NCRYPT_SUPPORTED_LENGTHS = __NCRYPT_SUPPORTED_LENGTHS;
  {$EXTERNALSYM NCRYPT_SUPPORTED_LENGTHS}
  TNCryptSupportedLengths = NCRYPT_SUPPORTED_LENGTHS;

// NCryptGetProperty flags
//const
//  NCRYPT_PERSIST_ONLY_FLAG       = $40000000;
//  {$EXTERNALSYM NCRYPT_PERSIST_ONLY_FLAG}

function NCryptGetProperty(
  hObject: NCRYPT_HANDLE;
  pszProperty: LPCWSTR;
  pbOutput: PBYTE;
  cbOutput: DWORD;
  out pcbResult: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptGetProperty}

// NCryptSetProperty flags
//const
//  NCRYPT_PERSIST_FLAG            = $80000000;
//  {$EXTERNALSYM NCRYPT_PERSIST_FLAG}
//  NCRYPT_PERSIST_ONLY_FLAG       = $40000000;
//  {$EXTERNALSYM NCRYPT_PERSIST_ONLY_FLAG}

function NCryptSetProperty(
  hObject: NCRYPT_HANDLE;
  pszProperty: LPCWSTR;
  pbInput: PBYTE;
  cbInput: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptSetProperty}

//const
//  NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG  = $00000200;
//  {$EXTERNALSYM NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG}

function NCryptFinalizeKey(
  hKey: NCRYPT_KEY_HANDLE;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptFinalizeKey}

function NCryptEncrypt(
  hKey: NCRYPT_KEY_HANDLE;
  pbInput: PBYTE;
  cbInput: DWORD;
  pPaddingInfo: Pointer;
  pbOutput: PBYTE;
  cbOutput: DWORD;
  out pcbResult: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptEncrypt}

function NCryptDecrypt(
  hKey: NCRYPT_KEY_HANDLE;
  pbInput: PBYTE;
  cbInput: DWORD;
  pPaddingInfo: Pointer;
  pbOutput: PBYTE;
  cbOutput: DWORD;
  out pcbResult: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptDecrypt}

type
  PNCryptKeyBlobHeader = ^TNCryptKeyBlobHeader;
  _NCRYPT_KEY_BLOB_HEADER = record
    cbSize: ULONG;                // size of this structure
    dwMagic: ULONG;
    cbAlgName: ULONG;             // size of the algorithm, in bytes, including terminating 0
    cbKeyData: ULONG;
  end;
  {$EXTERNALSYM _NCRYPT_KEY_BLOB_HEADER}
  NCRYPT_KEY_BLOB_HEADER = _NCRYPT_KEY_BLOB_HEADER;
  {$EXTERNALSYM NCRYPT_KEY_BLOB_HEADER}
  TNCryptKeyBlobHeader = _NCRYPT_KEY_BLOB_HEADER;
  PNCRYPT_KEY_BLOB_HEADER = PNCryptKeyBlobHeader;
  {$EXTERNALSYM PNCRYPT_KEY_BLOB_HEADER}

const
  NCRYPT_CIPHER_KEY_BLOB_MAGIC    = $52485043;      // CPHR
  {$EXTERNALSYM NCRYPT_CIPHER_KEY_BLOB_MAGIC}
  NCRYPT_PROTECTED_KEY_BLOB_MAGIC = $4B545250;      // PRTK
  {$EXTERNALSYM NCRYPT_PROTECTED_KEY_BLOB_MAGIC}

  NCRYPT_CIPHER_KEY_BLOB          = 'CipherKeyBlob';
  {$EXTERNALSYM NCRYPT_CIPHER_KEY_BLOB}
  NCRYPT_PROTECTED_KEY_BLOB       = 'ProtectedKeyBlob';
  {$EXTERNALSYM NCRYPT_PROTECTED_KEY_BLOB}

  NCRYPT_PKCS7_ENVELOPE_BLOB      = 'PKCS7_ENVELOPE';
  {$EXTERNALSYM NCRYPT_PKCS7_ENVELOPE_BLOB}
  NCRYPT_PKCS8_PRIVATE_KEY_BLOB   = 'PKCS8_PRIVATEKEY';
  {$EXTERNALSYM NCRYPT_PKCS8_PRIVATE_KEY_BLOB}
  NCRYPT_OPAQUETRANSPORT_BLOB     = 'OpaqueTransport';
  {$EXTERNALSYM NCRYPT_OPAQUETRANSPORT_BLOB}

//  NCRYPT_MACHINE_KEY_FLAG         = $00000020;
//  {$EXTERNALSYM NCRYPT_MACHINE_KEY_FLAG}
//  NCRYPT_DO_NOT_FINALIZE_FLAG     = $00000400;
//  {$EXTERNALSYM NCRYPT_DO_NOT_FINALIZE_FLAG}
  NCRYPT_EXPORT_LEGACY_FLAG       = $00000800;
  {$EXTERNALSYM NCRYPT_EXPORT_LEGACY_FLAG}

function NCryptImportKey(
  hProvider: NCRYPT_PROV_HANDLE;
  hImportKey: NCRYPT_KEY_HANDLE;
  pszBlobType: LPCWSTR;
  pParameterList: PNCryptBufferDesc;
  out phKey: NCRYPT_KEY_HANDLE;
  pbData: PBYTE;
  cbData: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptImportKey}

function NCryptExportKey(
  hKey: NCRYPT_KEY_HANDLE;
  hExportKey: NCRYPT_KEY_HANDLE;
  pszBlobType: LPCWSTR;
  pParameterList: PNCryptBufferDesc;
  pbOutput: PBYTE;
  cbOutput: DWORD;
  out pcbResult: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptExportKey}

function NCryptSignHash(
  hKey: NCRYPT_KEY_HANDLE;
  pPaddingInfo: Pointer;
  pbHashValue: PBYTE;
  cbHashValue: DWORD;
  pbSignature: PBYTE;
  cbSignature: DWORD;
  out pcbResult: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptSignHash}

function NCryptVerifySignature(
  hKey: NCRYPT_KEY_HANDLE;
  pPaddingInfo: Pointer;
  pbHashValue: PBYTE;
  cbHashValue: DWORD;
  pbSignature: PBYTE;
  cbSignature: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptVerifySignature}

function NCryptDeleteKey(
  hKey: NCRYPT_KEY_HANDLE;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptDeleteKey}

function NCryptFreeObject(
  hObject: NCRYPT_HANDLE): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptFreeObject}

function NCryptIsKeyHandle(
  hKey: NCRYPT_KEY_HANDLE): BOOL; winapi;
{$EXTERNALSYM NCryptIsKeyHandle}

function NCryptTranslateHandle(
  out phProvider: NCRYPT_PROV_HANDLE;
  out phKey: NCRYPT_KEY_HANDLE;
  hLegacyProv: HCRYPTPROV;
  hLegacyKey: HCRYPTKEY;
  dwLegacyKeySpec: DWORD;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptTranslateHandle}

// NCryptNotifyChangeKey flags
//const
//  NCRYPT_REGISTER_NOTIFY_FLAG    = $00000001;
//  {$EXTERNALSYM NCRYPT_REGISTER_NOTIFY_FLAG}
//  NCRYPT_UNREGISTER_NOTIFY_FLAG  = $00000002;
//  {$EXTERNALSYM NCRYPT_UNREGISTER_NOTIFY_FLAG}
//  NCRYPT_MACHINE_KEY_FLAG        = $00000020;
//  {$EXTERNALSYM NCRYPT_MACHINE_KEY_FLAG}

function NCryptNotifyChangeKey(
  hProvider: NCRYPT_PROV_HANDLE;
  var phEvent: THandle;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptNotifyChangeKey}

function NCryptSecretAgreement(
  hPrivKey: NCRYPT_KEY_HANDLE;
  hPubKey: NCRYPT_KEY_HANDLE;
  out phAgreedSecret: NCRYPT_SECRET_HANDLE;
  dwFlags: DWORD): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptSecretAgreement}

function NCryptDeriveKey(
  hSharedSecret: NCRYPT_SECRET_HANDLE;
  pwszKDF: LPCWSTR;
  pParameterList: PNCryptBufferDesc;
  pbDerivedKey: PBYTE;
  cbDerivedKey: DWORD;
  out pcbResult: DWORD;
  dwFlags: ULONG): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptDeriveKey}

function NCryptKeyDerivation(
  hKey: NCRYPT_KEY_HANDLE;
  pParameterList: PNCryptBufferDesc;
  pbDerivedKey: PUCHAR;
  cbDerivedKey: DWORD;
  out pcbResult: DWORD;
  dwFlags: ULONG): SECURITY_STATUS; winapi;
{$EXTERNALSYM NCryptKeyDerivation}

const
  NCRYPT_KEY_STORAGE_INTERFACE_VERSION: TBCryptInterfaceVersion =
    (MajorVersion:1; MinorVersion:0);
  {$EXTERNALSYM NCRYPT_KEY_STORAGE_INTERFACE_VERSION}
  NCRYPT_KEY_STORAGE_INTERFACE_VERSION_2: TBCryptInterfaceVersion =
    (MajorVersion:2; MinorVersion:0);
  {$EXTERNALSYM NCRYPT_KEY_STORAGE_INTERFACE_VERSION_2}

{$ENDREGION}

implementation

const
  NCryptDll = 'ncrypt.dll';

{$REGION 'ncrypt.h'}
function NCryptOpenStorageProvider; external NCryptDll name 'NCryptOpenStorageProvider' delayed;
function NCryptEnumAlgorithms; external NCryptDll name 'NCryptEnumAlgorithms' delayed;
function NCryptIsAlgSupported; external NCryptDll name 'NCryptIsAlgSupported' delayed;
function NCryptEnumKeys; external NCryptDll name 'NCryptEnumKeys' delayed;
function NCryptEnumStorageProviders; external NCryptDll name 'NCryptEnumStorageProviders' delayed;
function NCryptFreeBuffer; external NCryptDll name 'NCryptFreeBuffer' delayed;
function NCryptOpenKey; external NCryptDll name 'NCryptOpenKey' delayed;
function NCryptCreatePersistedKey; external NCryptDll name 'NCryptCreatePersistedKey' delayed;
function NCryptGetProperty; external NCryptDll name 'NCryptGetProperty' delayed;
function NCryptSetProperty; external NCryptDll name 'NCryptSetProperty' delayed;
function NCryptFinalizeKey; external NCryptDll name 'NCryptFinalizeKey' delayed;
function NCryptEncrypt; external NCryptDll name 'NCryptEncrypt' delayed;
function NCryptDecrypt; external NCryptDll name 'NCryptDecrypt' delayed;
function NCryptImportKey; external NCryptDll name 'NCryptImportKey' delayed;
function NCryptExportKey; external NCryptDll name 'NCryptExportKey' delayed;
function NCryptSignHash; external NCryptDll name 'NCryptSignHash' delayed;
function NCryptVerifySignature; external NCryptDll name 'NCryptVerifySignature' delayed;
function NCryptDeleteKey; external NCryptDll name 'NCryptDeleteKey' delayed;
function NCryptFreeObject; external NCryptDll name 'NCryptFreeObject' delayed;
function NCryptIsKeyHandle; external NCryptDll name 'NCryptIsKeyHandle' delayed;
function NCryptTranslateHandle; external NCryptDll name 'NCryptTranslateHandle' delayed;
function NCryptNotifyChangeKey; external NCryptDll name 'NCryptNotifyChangeKey' delayed;
function NCryptSecretAgreement; external NCryptDll name 'NCryptSecretAgreement' delayed;
function NCryptDeriveKey; external NCryptDll name 'NCryptDeriveKey' delayed;
function NCryptKeyDerivation; external NCryptDll name 'NCryptKeyDerivation' delayed;
{$ENDREGION}

end.
