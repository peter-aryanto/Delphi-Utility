unit Winapi.BCrypt;

interface

uses
  Windows;

{$IF not DECLARED(PVOID)}
type
  PVOID = Pointer;
  {$EXTERNALSYM PVOID}
{$IFEND}

{$IF not DECLARED(PWSTR)}
type
  PWSTR = PWideChar;
  {$EXTERNALSYM PWSTR}
{$IFEND}

{$REGION 'bcrypt.h'}

{$WARN SYMBOL_PLATFORM OFF}

{$IF not DECLARED(NTSTATUS)}
type
  NTSTATUS = Integer;
  {$EXTERNALSYM NTSTATUS}
{$IFEND}

{$IF not DECLARED(BCRYPT_SUCCESS)}
function BCRYPT_SUCCESS(Status: NTSTATUS): Boolean; inline;
{$EXTERNALSYM BCRYPT_SUCCESS}
{$IFEND}

//
//  Alignment macros
//

//
// BCRYPT_OBJECT_ALIGNMENT must be a power of 2
// We align all our internal data structures to 16 to
// allow fast XMM memory accesses.
// BCrypt callers do not need to take any alignment precautions.
//
const
  BCRYPT_OBJECT_ALIGNMENT   = 16;
  {$EXTERNALSYM BCRYPT_OBJECT_ALIGNMENT}

//
// BCRYPT_STRUCT_ALIGNMENT is an alignment macro that we no longer use.
// It used to align declspec(align(4)) on x86 and declspec(align(8)) on x64/ia64 but
// all structures that used it contained a pointer so they were already 4/8 aligned.
//
//#define BCRYPT_STRUCT_ALIGNMENT

//
// DeriveKey KDF Types
//
const
  BCRYPT_KDF_HASH                    = 'HASH';
  {$EXTERNALSYM BCRYPT_KDF_HASH}
  BCRYPT_KDF_HMAC                    = 'HMAC';
  {$EXTERNALSYM BCRYPT_KDF_HMAC}
  BCRYPT_KDF_TLS_PRF                 = 'TLS_PRF';
  {$EXTERNALSYM BCRYPT_KDF_TLS_PRF}
  BCRYPT_KDF_SP80056A_CONCAT         = 'SP800_56A_CONCAT';
  {$EXTERNALSYM BCRYPT_KDF_SP80056A_CONCAT}

//
// DeriveKey KDF BufferTypes
//
// For BCRYPT_KDF_HASH and BCRYPT_KDF_HMAC operations, there may be an arbitrary
// number of KDF_SECRET_PREPEND and KDF_SECRET_APPEND buffertypes in the
// parameter list.  The BufferTypes are processed in order of appearence
// within the parameter list.
//
const
  KDF_HASH_ALGORITHM     = $0;
  {$EXTERNALSYM KDF_HASH_ALGORITHM}
  KDF_SECRET_PREPEND     = $1;
  {$EXTERNALSYM KDF_SECRET_PREPEND}
  KDF_SECRET_APPEND      = $2;
  {$EXTERNALSYM KDF_SECRET_APPEND}
  KDF_HMAC_KEY           = $3;
  {$EXTERNALSYM KDF_HMAC_KEY}
  KDF_TLS_PRF_LABEL      = $4;
  {$EXTERNALSYM KDF_TLS_PRF_LABEL}
  KDF_TLS_PRF_SEED       = $5;
  {$EXTERNALSYM KDF_TLS_PRF_SEED}
  KDF_SECRET_HANDLE      = $6;
  {$EXTERNALSYM KDF_SECRET_HANDLE}
  KDF_TLS_PRF_PROTOCOL   = $7;
  {$EXTERNALSYM KDF_TLS_PRF_PROTOCOL}
  KDF_ALGORITHMID        = $8;
  {$EXTERNALSYM KDF_ALGORITHMID}
  KDF_PARTYUINFO         = $9;
  {$EXTERNALSYM KDF_PARTYUINFO}
  KDF_PARTYVINFO         = $A;
  {$EXTERNALSYM KDF_PARTYVINFO}
  KDF_SUPPPUBINFO        = $B;
  {$EXTERNALSYM KDF_SUPPPUBINFO}
  KDF_SUPPPRIVINFO       = $C;
  {$EXTERNALSYM KDF_SUPPPRIVINFO}
  KDF_LABEL              = $D;
  {$EXTERNALSYM KDF_LABEL}
  KDF_CONTEXT            = $E;
  {$EXTERNALSYM KDF_CONTEXT}
  KDF_SALT               = $F;
  {$EXTERNALSYM KDF_SALT}
  KDF_ITERATION_COUNT    = $10;
  {$EXTERNALSYM KDF_ITERATION_COUNT}
//
//
// Parameters for BCrypt(/NCrypt)KeyDerivation:
// Generic parameters:
// KDF_GENERIC_PARAMETER and KDF_HASH_ALGORITHM are the generic parameters that can be passed for the following KDF algorithms:
// BCRYPT/NCRYPT_SP800108_CTR_HMAC_ALGORITHM
//      KDF_GENERIC_PARAMETER = KDF_LABEL||0x00||KDF_CONTEXT
// BCRYPT/NCRYPT_SP80056A_CONCAT_ALGORITHM
//      KDF_GENERIC_PARAMETER = KDF_ALGORITHMID || KDF_PARTYUINFO || KDF_PARTYVINFO {|| KDF_SUPPPUBINFO } {|| KDF_SUPPPRIVINFO }
// BCRYPT/NCRYPT_PBKDF2_ALGORITHM
//      KDF_GENERIC_PARAMETER = KDF_SALT
// BCRYPT/NCRYPT_CAPI_KDF_ALGORITHM
//      KDF_GENERIC_PARAMETER = Not used
//
// KDF specific parameters:
// For BCRYPT/NCRYPT_SP800108_CTR_HMAC_ALGORITHM:
//      KDF_HASH_ALGORITHM, KDF_LABEL and KDF_CONTEXT are required
// For BCRYPT/NCRYPT_SP80056A_CONCAT_ALGORITHM:
//      KDF_HASH_ALGORITHM, KDF_ALGORITHMID, KDF_PARTYUINFO, KDF_PARTYVINFO are required
//      KDF_SUPPPUBINFO, KDF_SUPPPRIVINFO are optional
// For BCRYPT/NCRYPT_PBKDF2_ALGORITHM
//      KDF_HASH_ALGORITHM is required
//      KDF_ITERATION_COUNT, KDF_SALT are optional
//      Iteration count, (if not specified) will default to 10,000
// For BCRYPT/NCRYPT_CAPI_KDF_ALGORITHM
//      KDF_HASH_ALGORITHM is required
//
const
  KDF_GENERIC_PARAMETER = $11;
  {$EXTERNALSYM KDF_GENERIC_PARAMETER}

  KDF_KEYBITLENGTH      = $12;
  {$EXTERNALSYM KDF_KEYBITLENGTH}

//
// DeriveKey Flags:
//
// KDF_USE_SECRET_AS_HMAC_KEY_FLAG causes the secret agreement to serve also
// as the HMAC key.  If this flag is used, the KDF_HMAC_KEY parameter should
// NOT be specified.
//
const
  KDF_USE_SECRET_AS_HMAC_KEY_FLAG = $1;
  {$EXTERNALSYM KDF_USE_SECRET_AS_HMAC_KEY_FLAG}

//
// BCrypt structs
//
type
  PBCryptKeyLengthsStruct = ^TBCryptKeyLengthsStruct;
  __BCRYPT_KEY_LENGTHS_STRUCT = record
    dwMinLength: ULONG;
    dwMaxLength: ULONG;
    dwIncrement: ULONG;
  end;
  {$EXTERNALSYM __BCRYPT_KEY_LENGTHS_STRUCT}
  BCRYPT_KEY_LENGTHS_STRUCT = __BCRYPT_KEY_LENGTHS_STRUCT;
  {$EXTERNALSYM BCRYPT_KEY_LENGTHS_STRUCT}
  TBCryptKeyLengthsStruct = __BCRYPT_KEY_LENGTHS_STRUCT;

type
  PBCryptAuthTagLengthsStruct = ^TBCryptAuthTagLengthsStruct;
  BCRYPT_AUTH_TAG_LENGTHS_STRUCT = __BCRYPT_KEY_LENGTHS_STRUCT;
  {$EXTERNALSYM BCRYPT_AUTH_TAG_LENGTHS_STRUCT}
  TBCryptAuthTagLengthsStruct = __BCRYPT_KEY_LENGTHS_STRUCT;

type
  PBCryptOID = ^TBCryptOID;
  _BCRYPT_OID = record
    cbOID: ULONG;
    pbOID: PUCHAR;
  end;
  {$EXTERNALSYM _BCRYPT_OID}
  BCRYPT_OID = _BCRYPT_OID;
  {$EXTERNALSYM BCRYPT_OID}
  TBCryptOID = _BCRYPT_OID;

type
  PBCryptOIDList = ^TBCryptOIDList;
  _BCRYPT_OID_LIST = record
    dwOIDCount: ULONG;
    pOIDs: PBCryptOID;
  end;
  {$EXTERNALSYM _BCRYPT_OID_LIST}
  BCRYPT_OID_LIST = _BCRYPT_OID_LIST;
  {$EXTERNALSYM BCRYPT_OID_LIST}
  TBCryptOIDList = _BCRYPT_OID_LIST;

type
  PBCryptPKCS1PaddingInfo = ^TBCryptPKCS1PaddingInfo;
  _BCRYPT_PKCS1_PADDING_INFO = record
    pszAlgId: LPCWSTR;
  end;
  {$EXTERNALSYM _BCRYPT_PKCS1_PADDING_INFO}
  BCRYPT_PKCS1_PADDING_INFO = _BCRYPT_PKCS1_PADDING_INFO;
  {$EXTERNALSYM BCRYPT_PKCS1_PADDING_INFO}
  TBCryptPKCS1PaddingInfo = _BCRYPT_PKCS1_PADDING_INFO;

type
  PBCryptPSSPaddingInfo = ^TBCryptPSSPaddingInfo;
  _BCRYPT_PSS_PADDING_INFO = record
    pszAlgId: LPCWSTR;
    cbSalt: ULONG;
  end;
  {$EXTERNALSYM _BCRYPT_PSS_PADDING_INFO}
  BCRYPT_PSS_PADDING_INFO = _BCRYPT_PSS_PADDING_INFO;
  {$EXTERNALSYM BCRYPT_PSS_PADDING_INFO}
  TBCryptPSSPaddingInfo =  _BCRYPT_PSS_PADDING_INFO;

type
  PBCryptOAEPPaddingInfo = ^TBCryptOAEPPaddingInfo;
  _BCRYPT_OAEP_PADDING_INFO = record
    pszAlgId: LPCWSTR;
    pbLabel: PUCHAR;
    cbLabel: ULONG;
  end;
  {$EXTERNALSYM _BCRYPT_OAEP_PADDING_INFO}
  BCRYPT_OAEP_PADDING_INFO = _BCRYPT_OAEP_PADDING_INFO;
  {$EXTERNALSYM BCRYPT_OAEP_PADDING_INFO}
  TBCryptOAEPPaddingInfo = _BCRYPT_OAEP_PADDING_INFO;

const
  BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO_VERSION = 1;
  {$EXTERNALSYM BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO_VERSION}

  BCRYPT_AUTH_MODE_CHAIN_CALLS_FLAG  = $00000001;
  {$EXTERNALSYM BCRYPT_AUTH_MODE_CHAIN_CALLS_FLAG}
  BCRYPT_AUTH_MODE_IN_PROGRESS_FLAG  = $00000002;
  {$EXTERNALSYM BCRYPT_AUTH_MODE_IN_PROGRESS_FLAG}

type
  PBCryptAuthenticatedCipherModeInfo = ^TBCryptAuthenticatedCipherModeInfo;
  _BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO = record
    cbSize: ULONG;
    dwInfoVersion: ULONG;
    pbNonce: PUCHAR;
    cbNonce: ULONG;
    pbAuthData: PUCHAR;
    cbAuthData: ULONG;
    pbTag: PUCHAR;
    cbTag: ULONG;
    pbMacContext: PUCHAR;
    cbMacContext: ULONG;
    cbAAD: ULONG;
    cbData: ULONGLONG;
    dwFlags: ULONG;
  end;
  {$EXTERNALSYM _BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO}
  BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO = _BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO;
  {$EXTERNALSYM BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO}
  TBCryptAuthenticatedCipherModeInfo = _BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO;
  PBCRYPT_AUTHENTICATED_CIPHER_MODE_INFO = PBCryptAuthenticatedCipherModeInfo;
  {$EXTERNALSYM PBCRYPT_AUTHENTICATED_CIPHER_MODE_INFO}

procedure BCRYPT_INIT_AUTH_MODE_INFO(var _AUTH_INFO_STRUCT_: TBCryptAuthenticatedCipherModeInfo); inline;
{$EXTERNALSYM BCRYPT_INIT_AUTH_MODE_INFO}

//
// BCrypt String Properties
//

// BCrypt(Import/Export)Key BLOB types
const
  BCRYPT_OPAQUE_KEY_BLOB      = 'OpaqueKeyBlob';
  {$EXTERNALSYM BCRYPT_OPAQUE_KEY_BLOB}
  BCRYPT_KEY_DATA_BLOB        = 'KeyDataBlob';
  {$EXTERNALSYM BCRYPT_KEY_DATA_BLOB}
  BCRYPT_AES_WRAP_KEY_BLOB    = 'Rfc3565KeyWrapBlob';
  {$EXTERNALSYM BCRYPT_AES_WRAP_KEY_BLOB}

// BCryptGetProperty strings
const
  BCRYPT_OBJECT_LENGTH        = 'ObjectLength';
  {$EXTERNALSYM BCRYPT_OBJECT_LENGTH}
  BCRYPT_ALGORITHM_NAME       = 'AlgorithmName';
  {$EXTERNALSYM BCRYPT_ALGORITHM_NAME}
  BCRYPT_PROVIDER_HANDLE      = 'ProviderHandle';
  {$EXTERNALSYM BCRYPT_PROVIDER_HANDLE}
  BCRYPT_CHAINING_MODE        = 'ChainingMode';
  {$EXTERNALSYM BCRYPT_CHAINING_MODE}
  BCRYPT_BLOCK_LENGTH         = 'BlockLength';
  {$EXTERNALSYM BCRYPT_BLOCK_LENGTH}
  BCRYPT_KEY_LENGTH           = 'KeyLength';
  {$EXTERNALSYM BCRYPT_KEY_LENGTH}
  BCRYPT_KEY_OBJECT_LENGTH    = 'KeyObjectLength';
  {$EXTERNALSYM BCRYPT_KEY_OBJECT_LENGTH}
  BCRYPT_KEY_STRENGTH         = 'KeyStrength';
  {$EXTERNALSYM BCRYPT_KEY_STRENGTH}
  BCRYPT_KEY_LENGTHS          = 'KeyLengths';
  {$EXTERNALSYM BCRYPT_KEY_LENGTHS}
  BCRYPT_BLOCK_SIZE_LIST      = 'BlockSizeList';
  {$EXTERNALSYM BCRYPT_BLOCK_SIZE_LIST}
  BCRYPT_EFFECTIVE_KEY_LENGTH = 'EffectiveKeyLength';
  {$EXTERNALSYM BCRYPT_EFFECTIVE_KEY_LENGTH}
  BCRYPT_HASH_LENGTH          = 'HashDigestLength';
  {$EXTERNALSYM BCRYPT_HASH_LENGTH}
  BCRYPT_HASH_OID_LIST        = 'HashOIDList';
  {$EXTERNALSYM BCRYPT_HASH_OID_LIST}
  BCRYPT_PADDING_SCHEMES      = 'PaddingSchemes';
  {$EXTERNALSYM BCRYPT_PADDING_SCHEMES}
  BCRYPT_SIGNATURE_LENGTH     = 'SignatureLength';
  {$EXTERNALSYM BCRYPT_SIGNATURE_LENGTH}
  BCRYPT_HASH_BLOCK_LENGTH    = 'HashBlockLength';
  {$EXTERNALSYM BCRYPT_HASH_BLOCK_LENGTH}
  BCRYPT_AUTH_TAG_LENGTH      = 'AuthTagLength';
  {$EXTERNALSYM BCRYPT_AUTH_TAG_LENGTH}
  BCRYPT_PRIMITIVE_TYPE       = 'PrimitiveType';
  {$EXTERNALSYM BCRYPT_PRIMITIVE_TYPE}
  BCRYPT_IS_KEYED_HASH        = 'IsKeyedHash';
  {$EXTERNALSYM BCRYPT_IS_KEYED_HASH}
  BCRYPT_IS_REUSABLE_HASH     = 'IsReusableHash';
  {$EXTERNALSYM BCRYPT_IS_REUSABLE_HASH}
  BCRYPT_MESSAGE_BLOCK_LENGTH = 'MessageBlockLength';
  {$EXTERNALSYM BCRYPT_MESSAGE_BLOCK_LENGTH}

// Additional BCryptGetProperty strings for the RNG Platform Crypto Provider
const
  BCRYPT_PCP_PLATFORM_TYPE_PROPERTY    = 'PCP_PLATFORM_TYPE';
  {$EXTERNALSYM BCRYPT_PCP_PLATFORM_TYPE_PROPERTY}
  BCRYPT_PCP_PROVIDER_VERSION_PROPERTY = 'PCP_PROVIDER_VERSION';
  {$EXTERNALSYM BCRYPT_PCP_PROVIDER_VERSION_PROPERTY}

// BCryptSetProperty strings
const
  BCRYPT_INITIALIZATION_VECTOR   = 'IV';
  {$EXTERNALSYM BCRYPT_INITIALIZATION_VECTOR}

// Property Strings
const
  BCRYPT_CHAIN_MODE_NA       = 'ChainingModeN/A';
  {$EXTERNALSYM BCRYPT_CHAIN_MODE_NA}
  BCRYPT_CHAIN_MODE_CBC      = 'ChainingModeCBC';
  {$EXTERNALSYM BCRYPT_CHAIN_MODE_CBC}
  BCRYPT_CHAIN_MODE_ECB      = 'ChainingModeECB';
  {$EXTERNALSYM BCRYPT_CHAIN_MODE_ECB}
  BCRYPT_CHAIN_MODE_CFB      = 'ChainingModeCFB';
  {$EXTERNALSYM BCRYPT_CHAIN_MODE_CFB}
  BCRYPT_CHAIN_MODE_CCM      = 'ChainingModeCCM';
  {$EXTERNALSYM BCRYPT_CHAIN_MODE_CCM}
  BCRYPT_CHAIN_MODE_GCM      = 'ChainingModeGCM';
  {$EXTERNALSYM BCRYPT_CHAIN_MODE_GCM}

// Supported RSA Padding Types
const
  BCRYPT_SUPPORTED_PAD_ROUTER    = $00000001;
  {$EXTERNALSYM BCRYPT_SUPPORTED_PAD_ROUTER}
  BCRYPT_SUPPORTED_PAD_PKCS1_ENC = $00000002;
  {$EXTERNALSYM BCRYPT_SUPPORTED_PAD_PKCS1_ENC}
  BCRYPT_SUPPORTED_PAD_PKCS1_SIG = $00000004;
  {$EXTERNALSYM BCRYPT_SUPPORTED_PAD_PKCS1_SIG}
  BCRYPT_SUPPORTED_PAD_OAEP      = $00000008;
  {$EXTERNALSYM BCRYPT_SUPPORTED_PAD_OAEP}
  BCRYPT_SUPPORTED_PAD_PSS       = $00000010;
  {$EXTERNALSYM BCRYPT_SUPPORTED_PAD_PSS}

//
//      BCrypt Flags
//
const
  BCRYPT_PROV_DISPATCH       = $00000001;  // BCryptOpenAlgorithmProvider
  {$EXTERNALSYM BCRYPT_PROV_DISPATCH}

  BCRYPT_BLOCK_PADDING       = $00000001;  // BCryptEncrypt/Decrypt
  {$EXTERNALSYM BCRYPT_BLOCK_PADDING}

// RSA padding schemes
const
  BCRYPT_PAD_NONE            = $00000001;
  {$EXTERNALSYM BCRYPT_PAD_NONE}
  BCRYPT_PAD_PKCS1           = $00000002;  // BCryptEncrypt/Decrypt BCryptSignHash/VerifySignature
  {$EXTERNALSYM BCRYPT_PAD_PKCS1}
  BCRYPT_PAD_OAEP            = $00000004;  // BCryptEncrypt/Decrypt
  {$EXTERNALSYM BCRYPT_PAD_OAEP}
  BCRYPT_PAD_PSS             = $00000008;  // BCryptSignHash/VerifySignature
  {$EXTERNALSYM BCRYPT_PAD_PSS}


  BCRYPTBUFFER_VERSION       = 0;
  {$EXTERNALSYM BCRYPTBUFFER_VERSION}

type
  PBCryptBuffer = ^TBCryptBuffer;
  _BCryptBuffer = record
    cbBuffer: ULONG;                // Length of buffer, in bytes
    BufferType: ULONG;              // Buffer type
    pvBuffer: PVOID;                // Pointer to buffer
  end;
  {$EXTERNALSYM _BCryptBuffer}
  BCryptBuffer = _BCryptBuffer;
  {$EXTERNALSYM BCryptBuffer}
  TBCryptBuffer = _BCryptBuffer;

type
  PBCryptBufferDesc = ^TBCryptBufferDesc;
  _BCryptBufferDesc = record
    ulVersion: ULONG;               // Version number
    cBuffers: ULONG;                // Number of buffers
    pBuffers: PBCryptBuffer;        // Pointer to array of buffers
  end;
  {$EXTERNALSYM _BCryptBufferDesc}
  BCryptBufferDesc = _BCryptBufferDesc;
  {$EXTERNALSYM BCryptBufferDesc}
  TBCryptBufferDesc = _BCryptBufferDesc;

//
// Primitive handles
//
type
  BCRYPT_HANDLE = PVOID;
  {$EXTERNALSYM BCRYPT_HANDLE}
  BCRYPT_ALG_HANDLE = PVOID;
  {$EXTERNALSYM BCRYPT_ALG_HANDLE}
  BCRYPT_KEY_HANDLE = PVOID;
  {$EXTERNALSYM BCRYPT_KEY_HANDLE}
  BCRYPT_HASH_HANDLE = PVOID;
  {$EXTERNALSYM BCRYPT_HASH_HANDLE}
  BCRYPT_SECRET_HANDLE = PVOID;
  {$EXTERNALSYM BCRYPT_SECRET_HANDLE}

//
// Structures used to represent key blobs.
//
const
  BCRYPT_PUBLIC_KEY_BLOB      = 'PUBLICBLOB';
  {$EXTERNALSYM BCRYPT_PUBLIC_KEY_BLOB}
  BCRYPT_PRIVATE_KEY_BLOB     = 'PRIVATEBLOB';
  {$EXTERNALSYM BCRYPT_PRIVATE_KEY_BLOB}

type
  PBCryptKeyBlob = ^TBCryptKeyBlob;
  _BCRYPT_KEY_BLOB = record
    Magic: ULONG;
  end;
  {$EXTERNALSYM _BCRYPT_KEY_BLOB}
  BCRYPT_KEY_BLOB = _BCRYPT_KEY_BLOB;
  {$EXTERNALSYM BCRYPT_KEY_BLOB}
  TBCryptKeyBlob = _BCRYPT_KEY_BLOB;

// The BCRYPT_RSAPUBLIC_BLOB and BCRYPT_RSAPRIVATE_BLOB blob types are used
// to transport plaintext RSA keys. These blob types will be supported by
// all RSA primitive providers.
// The BCRYPT_RSAPRIVATE_BLOB includes the following values:
// Public Exponent
// Modulus
// Prime1
// Prime2
const
  BCRYPT_RSAPUBLIC_BLOB      = 'RSAPUBLICBLOB';
  {$EXTERNALSYM BCRYPT_RSAPUBLIC_BLOB}
  BCRYPT_RSAPRIVATE_BLOB     = 'RSAPRIVATEBLOB';
  {$EXTERNALSYM BCRYPT_RSAPRIVATE_BLOB}
  LEGACY_RSAPUBLIC_BLOB      = 'CAPIPUBLICBLOB';
  {$EXTERNALSYM LEGACY_RSAPUBLIC_BLOB}
  LEGACY_RSAPRIVATE_BLOB     = 'CAPIPRIVATEBLOB';
  {$EXTERNALSYM LEGACY_RSAPRIVATE_BLOB}

  BCRYPT_RSAPUBLIC_MAGIC     = $31415352;  // RSA1
  {$EXTERNALSYM BCRYPT_RSAPUBLIC_MAGIC}
  BCRYPT_RSAPRIVATE_MAGIC    = $32415352;  // RSA2
  {$EXTERNALSYM BCRYPT_RSAPRIVATE_MAGIC}

type
  PBCryptRSAKeyBlob = ^TBCryptRSAKeyBlob;
  _BCRYPT_RSAKEY_BLOB = record
    Magic: ULONG;
    BitLength: ULONG;
    cbPublicExp: ULONG;
    cbModulus: ULONG;
    cbPrime1: ULONG;
    cbPrime2: ULONG;
  end;
  {$EXTERNALSYM _BCRYPT_RSAKEY_BLOB}
  BCRYPT_RSAKEY_BLOB = _BCRYPT_RSAKEY_BLOB;
  {$EXTERNALSYM BCRYPT_RSAKEY_BLOB}
  TBCryptRSAKeyBlob = _BCRYPT_RSAKEY_BLOB;

// The BCRYPT_RSAFULLPRIVATE_BLOB blob type is used to transport
// plaintext private RSA keys.  It includes the following values:
// Public Exponent
// Modulus
// Prime1
// Prime2
// Private Exponent mod (Prime1 - 1)
// Private Exponent mod (Prime2 - 1)
// Inverse of Prime2 mod Prime1
// PrivateExponent
const
  BCRYPT_RSAFULLPRIVATE_BLOB     = 'RSAFULLPRIVATEBLOB';
  {$EXTERNALSYM BCRYPT_RSAFULLPRIVATE_BLOB}

  BCRYPT_RSAFULLPRIVATE_MAGIC    = $33415352;  // RSA3
  {$EXTERNALSYM BCRYPT_RSAFULLPRIVATE_MAGIC}

//Properties of secret agreement algorithms
const
  BCRYPT_GLOBAL_PARAMETERS   = 'SecretAgreementParam';
  {$EXTERNALSYM BCRYPT_GLOBAL_PARAMETERS}
  BCRYPT_PRIVATE_KEY         = 'PrivKeyVal';
  {$EXTERNALSYM BCRYPT_PRIVATE_KEY}

// The BCRYPT_ECCPUBLIC_BLOB and BCRYPT_ECCPRIVATE_BLOB blob types are used
// to transport plaintext ECC keys. These blob types will be supported by
// all ECC primitive providers.
const
  BCRYPT_ECCPUBLIC_BLOB           = 'ECCPUBLICBLOB';
  {$EXTERNALSYM BCRYPT_ECCPUBLIC_BLOB}
  BCRYPT_ECCPRIVATE_BLOB          = 'ECCPRIVATEBLOB';
  {$EXTERNALSYM BCRYPT_ECCPRIVATE_BLOB}

  BCRYPT_ECDH_PUBLIC_P256_MAGIC   = $314B4345;  // ECK1
  {$EXTERNALSYM BCRYPT_ECDH_PUBLIC_P256_MAGIC}
  BCRYPT_ECDH_PRIVATE_P256_MAGIC  = $324B4345;  // ECK2
  {$EXTERNALSYM BCRYPT_ECDH_PRIVATE_P256_MAGIC}
  BCRYPT_ECDH_PUBLIC_P384_MAGIC   = $334B4345;  // ECK3
  {$EXTERNALSYM BCRYPT_ECDH_PUBLIC_P384_MAGIC}
  BCRYPT_ECDH_PRIVATE_P384_MAGIC  = $344B4345;  // ECK4
  {$EXTERNALSYM BCRYPT_ECDH_PRIVATE_P384_MAGIC}
  BCRYPT_ECDH_PUBLIC_P521_MAGIC   = $354B4345;  // ECK5
  {$EXTERNALSYM BCRYPT_ECDH_PUBLIC_P521_MAGIC}
  BCRYPT_ECDH_PRIVATE_P521_MAGIC  = $364B4345;  // ECK6
  {$EXTERNALSYM BCRYPT_ECDH_PRIVATE_P521_MAGIC}

  BCRYPT_ECDSA_PUBLIC_P256_MAGIC  = $31534345;  // ECS1
  {$EXTERNALSYM BCRYPT_ECDSA_PUBLIC_P256_MAGIC}
  BCRYPT_ECDSA_PRIVATE_P256_MAGIC = $32534345;  // ECS2
  {$EXTERNALSYM BCRYPT_ECDSA_PRIVATE_P256_MAGIC}
  BCRYPT_ECDSA_PUBLIC_P384_MAGIC  = $33534345;  // ECS3
  {$EXTERNALSYM BCRYPT_ECDSA_PUBLIC_P384_MAGIC}
  BCRYPT_ECDSA_PRIVATE_P384_MAGIC = $34534345;  // ECS4
  {$EXTERNALSYM BCRYPT_ECDSA_PRIVATE_P384_MAGIC}
  BCRYPT_ECDSA_PUBLIC_P521_MAGIC  = $35534345;  // ECS5
  {$EXTERNALSYM BCRYPT_ECDSA_PUBLIC_P521_MAGIC}
  BCRYPT_ECDSA_PRIVATE_P521_MAGIC = $36534345;  // ECS6
  {$EXTERNALSYM BCRYPT_ECDSA_PRIVATE_P521_MAGIC}

type
  PBCryptECCKeyBlob = ^TBCryptECCKeyBlob;
  _BCRYPT_ECCKEY_BLOB = record
    dwMagic: ULONG;
    cbKey: ULONG;
  end;
  {$EXTERNALSYM _BCRYPT_ECCKEY_BLOB}
  BCRYPT_ECCKEY_BLOB = _BCRYPT_ECCKEY_BLOB;
  {$EXTERNALSYM BCRYPT_ECCKEY_BLOB}
  TBCryptECCKeyBlob = _BCRYPT_ECCKEY_BLOB;
  PBCRYPT_ECCKEY_BLOB = PBCryptECCKeyBlob;
  {$EXTERNALSYM PBCRYPT_ECCKEY_BLOB}

// The BCRYPT_DH_PUBLIC_BLOB and BCRYPT_DH_PRIVATE_BLOB blob types are used
// to transport plaintext DH keys. These blob types will be supported by
// all DH primitive providers.
const
  BCRYPT_DH_PUBLIC_BLOB          = 'DHPUBLICBLOB';
  {$EXTERNALSYM BCRYPT_DH_PUBLIC_BLOB}
  BCRYPT_DH_PRIVATE_BLOB         = 'DHPRIVATEBLOB';
  {$EXTERNALSYM BCRYPT_DH_PRIVATE_BLOB}
  LEGACY_DH_PUBLIC_BLOB          = 'CAPIDHPUBLICBLOB';
  {$EXTERNALSYM LEGACY_DH_PUBLIC_BLOB}
  LEGACY_DH_PRIVATE_BLOB         = 'CAPIDHPRIVATEBLOB';
  {$EXTERNALSYM LEGACY_DH_PRIVATE_BLOB}

  BCRYPT_DH_PUBLIC_MAGIC         = $42504844;  // DHPB
  {$EXTERNALSYM BCRYPT_DH_PUBLIC_MAGIC}
  BCRYPT_DH_PRIVATE_MAGIC        = $56504844;  // DHPV
  {$EXTERNALSYM BCRYPT_DH_PRIVATE_MAGIC}

type
  PBCryptDHKeyBlob = ^TBCryptDHKeyBlob;
  _BCRYPT_DH_KEY_BLOB = record
    dwMagic: ULONG;
    cbKey: ULONG;
  end;
  {$EXTERNALSYM _BCRYPT_DH_KEY_BLOB}
  BCRYPT_DH_KEY_BLOB = _BCRYPT_DH_KEY_BLOB;
  {$EXTERNALSYM BCRYPT_DH_KEY_BLOB}
  TBCryptDHKeyBlob = _BCRYPT_DH_KEY_BLOB;
  PBCRYPT_DH_KEY_BLOB = PBCryptDHKeyBlob;
  {$EXTERNALSYM PBCRYPT_DH_KEY_BLOB}

// Property Strings for DH
const
  BCRYPT_DH_PARAMETERS           = 'DHParameters';
  {$EXTERNALSYM BCRYPT_DH_PARAMETERS}

  BCRYPT_DH_PARAMETERS_MAGIC     = $4d504844;  // DHPM
  {$EXTERNALSYM BCRYPT_DH_PARAMETERS_MAGIC}

type
  PBCryptDHParameterHeader = ^TBCryptDHParameterHeader;
  _BCRYPT_DH_PARAMETER_HEADER = record
    cbLength: ULONG;
    dwMagic: ULONG;
    cbKeyLength: ULONG;
  end;
  {$EXTERNALSYM _BCRYPT_DH_PARAMETER_HEADER}
  BCRYPT_DH_PARAMETER_HEADER = _BCRYPT_DH_PARAMETER_HEADER;
  {$EXTERNALSYM BCRYPT_DH_PARAMETER_HEADER}
  TBCryptDHParameterHeader = _BCRYPT_DH_PARAMETER_HEADER;

// The BCRYPT_DSA_PUBLIC_BLOB and BCRYPT_DSA_PRIVATE_BLOB blob types are used
// to transport plaintext DSA keys. These blob types will be supported by
// all DSA primitive providers.
const
  BCRYPT_DSA_PUBLIC_BLOB         = 'DSAPUBLICBLOB';
  {$EXTERNALSYM BCRYPT_DSA_PUBLIC_BLOB}
  BCRYPT_DSA_PRIVATE_BLOB        = 'DSAPRIVATEBLOB';
  {$EXTERNALSYM BCRYPT_DSA_PRIVATE_BLOB}
  LEGACY_DSA_PUBLIC_BLOB         = 'CAPIDSAPUBLICBLOB';
  {$EXTERNALSYM LEGACY_DSA_PUBLIC_BLOB}
  LEGACY_DSA_PRIVATE_BLOB        = 'CAPIDSAPRIVATEBLOB';
  {$EXTERNALSYM LEGACY_DSA_PRIVATE_BLOB}
  LEGACY_DSA_V2_PUBLIC_BLOB      = 'V2CAPIDSAPUBLICBLOB';
  {$EXTERNALSYM LEGACY_DSA_V2_PUBLIC_BLOB}
  LEGACY_DSA_V2_PRIVATE_BLOB     = 'V2CAPIDSAPRIVATEBLOB';
  {$EXTERNALSYM LEGACY_DSA_V2_PRIVATE_BLOB}

  BCRYPT_DSA_PUBLIC_MAGIC        = $42505344;  // DSPB
  {$EXTERNALSYM BCRYPT_DSA_PUBLIC_MAGIC}
  BCRYPT_DSA_PRIVATE_MAGIC       = $56505344;  // DSPV
  {$EXTERNALSYM BCRYPT_DSA_PRIVATE_MAGIC}
  BCRYPT_DSA_PUBLIC_MAGIC_V2     = $32425044;  // DPB2
  {$EXTERNALSYM BCRYPT_DSA_PUBLIC_MAGIC_V2}
  BCRYPT_DSA_PRIVATE_MAGIC_V2    = $32565044;  // DPV2
  {$EXTERNALSYM BCRYPT_DSA_PRIVATE_MAGIC_V2}

type
  PBCryptDSAKeyBlob = ^TBCryptDSAKeyBlob;
  _BCRYPT_DSA_KEY_BLOB = record
    dwMagic: ULONG;
    cbKey: ULONG;
    Count: array [0..3] of UCHAR;
    Seed: array [0..19] of UCHAR;
    q: array [0..19] of UCHAR;
  end;
  {$EXTERNALSYM _BCRYPT_DSA_KEY_BLOB}
  BCRYPT_DSA_KEY_BLOB = _BCRYPT_DSA_KEY_BLOB;
  {$EXTERNALSYM BCRYPT_DSA_KEY_BLOB}
  TBCryptDSAKeyBlob = _BCRYPT_DSA_KEY_BLOB;
  PBCRYPT_DSA_KEY_BLOB = PBCryptDSAKeyBlob;
  {$EXTERNALSYM PBCRYPT_DSA_KEY_BLOB}

type
  PHashAlgorithmEnum = ^THashAlgorithmEnum;
  HASHALGORITHM_ENUM = (
    DSA_HASH_ALGORITHM_SHA1,
    DSA_HASH_ALGORITHM_SHA256,
    DSA_HASH_ALGORITHM_SHA512
  );
  {$EXTERNALSYM HASHALGORITHM_ENUM}
  THashAlgorithmEnum = HASHALGORITHM_ENUM;

type
  PDSAFipsVersionEnum = ^TDSAFipsVersionEnum;
  DSAFIPSVERSION_ENUM = (
    DSA_FIPS186_2,
    DSA_FIPS186_3
  );
  {$EXTERNALSYM DSAFIPSVERSION_ENUM}
  TDSAFipsVersionEnum = DSAFIPSVERSION_ENUM;

type
  PBCryptDSAKeyBlobV2 = ^TBCryptDSAKeyBlobV2;
  _BCRYPT_DSA_KEY_BLOB_V2 = record
    dwMagic: ULONG;
    cbKey: ULONG;
    hashAlgorithm: THashAlgorithmEnum;
    standardVersion: TDSAFipsVersionEnum;
    cbSeedLength: ULONG;
    cbGroupSize: ULONG;
    Count: array [0..3] of UCHAR;
  end;
  {$EXTERNALSYM _BCRYPT_DSA_KEY_BLOB_V2}
  BCRYPT_DSA_KEY_BLOB_V2 = _BCRYPT_DSA_KEY_BLOB_V2;
  {$EXTERNALSYM BCRYPT_DSA_KEY_BLOB_V2}
  TBCryptDSAKeyBlobV2 = _BCRYPT_DSA_KEY_BLOB_V2;
  PBCRYPT_DSA_KEY_BLOB_V2 = PBCryptDSAKeyBlobV2;
  {$EXTERNALSYM PBCRYPT_DSA_KEY_BLOB_V2}

type
  PBCryptKeyDataBlobHeader = ^TBCryptKeyDataBlobHeader;
  _BCRYPT_KEY_DATA_BLOB_HEADER = record
    dwMagic: ULONG;
    dwVersion: ULONG;
    cbKeyData: ULONG;
  end;
  {$EXTERNALSYM _BCRYPT_KEY_DATA_BLOB_HEADER}
  BCRYPT_KEY_DATA_BLOB_HEADER = _BCRYPT_KEY_DATA_BLOB_HEADER;
  {$EXTERNALSYM BCRYPT_KEY_DATA_BLOB_HEADER}
  TBCryptKeyDataBlobHeader = _BCRYPT_KEY_DATA_BLOB_HEADER;
  PBCRYPT_KEY_DATA_BLOB_HEADER = PBCryptKeyDataBlobHeader;
  {$EXTERNALSYM PBCRYPT_KEY_DATA_BLOB_HEADER}

const
  BCRYPT_KEY_DATA_BLOB_MAGIC      = $4d42444b; //Key Data Blob Magic (KDBM)
  {$EXTERNALSYM BCRYPT_KEY_DATA_BLOB_MAGIC}

  BCRYPT_KEY_DATA_BLOB_VERSION1   = $1;
  {$EXTERNALSYM BCRYPT_KEY_DATA_BLOB_VERSION1}

// Property Strings for DSA
const
  BCRYPT_DSA_PARAMETERS      = 'DSAParameters';
  {$EXTERNALSYM BCRYPT_DSA_PARAMETERS}

  BCRYPT_DSA_PARAMETERS_MAGIC       = $4d505344;  // DSPM
  {$EXTERNALSYM BCRYPT_DSA_PARAMETERS_MAGIC}

  BCRYPT_DSA_PARAMETERS_MAGIC_V2    = $324d5044;  // DPM2
  {$EXTERNALSYM BCRYPT_DSA_PARAMETERS_MAGIC_V2}

type
  PBCryptDSAParameterHeader = ^TBCryptDSAParameterHeader;
  _BCRYPT_DSA_PARAMETER_HEADER = record
    cbLength: ULONG;
    dwMagic: ULONG;
    cbKeyLength: ULONG;
    Count: array [0..3] of UCHAR;
    Seed: array [0..19] of UCHAR;
    q: array [0..19] of UCHAR;
  end;
  {$EXTERNALSYM _BCRYPT_DSA_PARAMETER_HEADER}
  BCRYPT_DSA_PARAMETER_HEADER = _BCRYPT_DSA_PARAMETER_HEADER;
  {$EXTERNALSYM BCRYPT_DSA_PARAMETER_HEADER}
  TBCryptDSAParameterHeader = _BCRYPT_DSA_PARAMETER_HEADER;

type
  PBCryptDSAParameterHeaderV2 = ^TBCryptDSAParameterHeaderV2;
  _BCRYPT_DSA_PARAMETER_HEADER_V2 = record
    cbLength: ULONG;
    dwMagic: ULONG;
    cbKeyLength: ULONG;
    hashAlgorithm: THashAlgorithmEnum;
    standardVersion: TDSAFipsVersionEnum;
    cbSeedLength: ULONG;
    cbGroupSize: ULONG;
    Count: array [0..3] of UCHAR;
  end;
  {$EXTERNALSYM _BCRYPT_DSA_PARAMETER_HEADER_V2}
  BCRYPT_DSA_PARAMETER_HEADER_V2 = _BCRYPT_DSA_PARAMETER_HEADER_V2;
  {$EXTERNALSYM BCRYPT_DSA_PARAMETER_HEADER_V2}
  TBCryptDSAParameterHeaderV2 = _BCRYPT_DSA_PARAMETER_HEADER_V2;

//
// Microsoft built-in providers.
//
const
  MS_PRIMITIVE_PROVIDER                  = 'Microsoft Primitive Provider';
  {$EXTERNALSYM MS_PRIMITIVE_PROVIDER}
  MS_PLATFORM_CRYPTO_PROVIDER            = 'Microsoft Platform Crypto Provider';
  {$EXTERNALSYM MS_PLATFORM_CRYPTO_PROVIDER}

//
// Common algorithm identifiers.
//
const
  BCRYPT_RSA_ALGORITHM                   = 'RSA';
  {$EXTERNALSYM BCRYPT_RSA_ALGORITHM}
  BCRYPT_RSA_SIGN_ALGORITHM              = 'RSA_SIGN';
  {$EXTERNALSYM BCRYPT_RSA_SIGN_ALGORITHM}
  BCRYPT_DH_ALGORITHM                    = 'DH';
  {$EXTERNALSYM BCRYPT_DH_ALGORITHM}
  BCRYPT_DSA_ALGORITHM                   = 'DSA';
  {$EXTERNALSYM BCRYPT_DSA_ALGORITHM}
  BCRYPT_RC2_ALGORITHM                   = 'RC2';
  {$EXTERNALSYM BCRYPT_RC2_ALGORITHM}
  BCRYPT_RC4_ALGORITHM                   = 'RC4';
  {$EXTERNALSYM BCRYPT_RC4_ALGORITHM}
  BCRYPT_AES_ALGORITHM                   = 'AES';
  {$EXTERNALSYM BCRYPT_AES_ALGORITHM}
  BCRYPT_DES_ALGORITHM                   = 'DES';
  {$EXTERNALSYM BCRYPT_DES_ALGORITHM}
  BCRYPT_DESX_ALGORITHM                  = 'DESX';
  {$EXTERNALSYM BCRYPT_DESX_ALGORITHM}
  BCRYPT_3DES_ALGORITHM                  = '3DES';
  {$EXTERNALSYM BCRYPT_3DES_ALGORITHM}
  BCRYPT_3DES_112_ALGORITHM              = '3DES_112';
  {$EXTERNALSYM BCRYPT_3DES_112_ALGORITHM}
  BCRYPT_MD2_ALGORITHM                   = 'MD2';
  {$EXTERNALSYM BCRYPT_MD2_ALGORITHM}
  BCRYPT_MD4_ALGORITHM                   = 'MD4';
  {$EXTERNALSYM BCRYPT_MD4_ALGORITHM}
  BCRYPT_MD5_ALGORITHM                   = 'MD5';
  {$EXTERNALSYM BCRYPT_MD5_ALGORITHM}
  BCRYPT_SHA1_ALGORITHM                  = 'SHA1';
  {$EXTERNALSYM BCRYPT_SHA1_ALGORITHM}
  BCRYPT_SHA256_ALGORITHM                = 'SHA256';
  {$EXTERNALSYM BCRYPT_SHA256_ALGORITHM}
  BCRYPT_SHA384_ALGORITHM                = 'SHA384';
  {$EXTERNALSYM BCRYPT_SHA384_ALGORITHM}
  BCRYPT_SHA512_ALGORITHM                = 'SHA512';
  {$EXTERNALSYM BCRYPT_SHA512_ALGORITHM}
  BCRYPT_AES_GMAC_ALGORITHM              = 'AES-GMAC';
  {$EXTERNALSYM BCRYPT_AES_GMAC_ALGORITHM}
  BCRYPT_AES_CMAC_ALGORITHM              = 'AES-CMAC';
  {$EXTERNALSYM BCRYPT_AES_CMAC_ALGORITHM}
  BCRYPT_ECDSA_P256_ALGORITHM            = 'ECDSA_P256';
  {$EXTERNALSYM BCRYPT_ECDSA_P256_ALGORITHM}
  BCRYPT_ECDSA_P384_ALGORITHM            = 'ECDSA_P384';
  {$EXTERNALSYM BCRYPT_ECDSA_P384_ALGORITHM}
  BCRYPT_ECDSA_P521_ALGORITHM            = 'ECDSA_P521';
  {$EXTERNALSYM BCRYPT_ECDSA_P521_ALGORITHM}
  BCRYPT_ECDH_P256_ALGORITHM             = 'ECDH_P256';
  {$EXTERNALSYM BCRYPT_ECDH_P256_ALGORITHM}
  BCRYPT_ECDH_P384_ALGORITHM             = 'ECDH_P384';
  {$EXTERNALSYM BCRYPT_ECDH_P384_ALGORITHM}
  BCRYPT_ECDH_P521_ALGORITHM             = 'ECDH_P521';
  {$EXTERNALSYM BCRYPT_ECDH_P521_ALGORITHM}
  BCRYPT_RNG_ALGORITHM                   = 'RNG';
  {$EXTERNALSYM BCRYPT_RNG_ALGORITHM}
  BCRYPT_RNG_FIPS186_DSA_ALGORITHM       = 'FIPS186DSARNG';
  {$EXTERNALSYM BCRYPT_RNG_FIPS186_DSA_ALGORITHM}
  BCRYPT_RNG_DUAL_EC_ALGORITHM           = 'DUALECRNG';
  {$EXTERNALSYM BCRYPT_RNG_DUAL_EC_ALGORITHM}
  BCRYPT_SP800108_CTR_HMAC_ALGORITHM     = 'SP800_108_CTR_HMAC';
  {$EXTERNALSYM BCRYPT_SP800108_CTR_HMAC_ALGORITHM}
  BCRYPT_SP80056A_CONCAT_ALGORITHM       = 'SP800_56A_CONCAT';
  {$EXTERNALSYM BCRYPT_SP80056A_CONCAT_ALGORITHM}
  BCRYPT_PBKDF2_ALGORITHM                = 'PBKDF2';
  {$EXTERNALSYM BCRYPT_PBKDF2_ALGORITHM}
  BCRYPT_CAPI_KDF_ALGORITHM              = 'CAPI_KDF';
  {$EXTERNALSYM BCRYPT_CAPI_KDF_ALGORITHM}

//
// Interfaces
//
const
  BCRYPT_CIPHER_INTERFACE                = $00000001;
  {$EXTERNALSYM BCRYPT_CIPHER_INTERFACE}
  BCRYPT_HASH_INTERFACE                  = $00000002;
  {$EXTERNALSYM BCRYPT_HASH_INTERFACE}
  BCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE = $00000003;
  {$EXTERNALSYM BCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE}
  BCRYPT_SECRET_AGREEMENT_INTERFACE      = $00000004;
  {$EXTERNALSYM BCRYPT_SECRET_AGREEMENT_INTERFACE}
  BCRYPT_SIGNATURE_INTERFACE             = $00000005;
  {$EXTERNALSYM BCRYPT_SIGNATURE_INTERFACE}
  BCRYPT_RNG_INTERFACE                   = $00000006;
  {$EXTERNALSYM BCRYPT_RNG_INTERFACE}
  BCRYPT_KEY_DERIVATION_INTERFACE        = $00000007;
  {$EXTERNALSYM BCRYPT_KEY_DERIVATION_INTERFACE}


//
// Primitive algorithm provider functions.
//
const
  BCRYPT_ALG_HANDLE_HMAC_FLAG    = $00000008;
  {$EXTERNALSYM BCRYPT_ALG_HANDLE_HMAC_FLAG}
  BCRYPT_CAPI_AES_FLAG           = $00000010;
  {$EXTERNALSYM BCRYPT_CAPI_AES_FLAG}
  BCRYPT_HASH_REUSABLE_FLAG      = $00000020;
  {$EXTERNALSYM BCRYPT_HASH_REUSABLE_FLAG}

//
// The BUFFERS_LOCKED flag used in BCryptEncrypt/BCryptDecrypt signals that
// the pbInput and pbOutput buffers have been locked (see MmProbeAndLockPages)
// and CNG may not lock the buffers again.
// This flag applies only to kernel mode, it is ignored in user mode.
//
const
  BCRYPT_BUFFERS_LOCKED_FLAG     = $00000040;
  {$EXTERNALSYM BCRYPT_BUFFERS_LOCKED_FLAG}

function BCryptOpenAlgorithmProvider(
  out phAlgorithm: BCRYPT_ALG_HANDLE;
  pszAlgId: LPCWSTR;
  pszImplementation: LPCWSTR;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptOpenAlgorithmProvider}

// AlgOperations flags for use with BCryptEnumAlgorithms()
const
  BCRYPT_CIPHER_OPERATION                = $00000001;
  {$EXTERNALSYM BCRYPT_CIPHER_OPERATION}
  BCRYPT_HASH_OPERATION                  = $00000002;
  {$EXTERNALSYM BCRYPT_HASH_OPERATION}
  BCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION = $00000004;
  {$EXTERNALSYM BCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION}
  BCRYPT_SECRET_AGREEMENT_OPERATION      = $00000008;
  {$EXTERNALSYM BCRYPT_SECRET_AGREEMENT_OPERATION}
  BCRYPT_SIGNATURE_OPERATION             = $00000010;
  {$EXTERNALSYM BCRYPT_SIGNATURE_OPERATION}
  BCRYPT_RNG_OPERATION                   = $00000020;
  {$EXTERNALSYM BCRYPT_RNG_OPERATION}
  BCRYPT_KEY_DERIVATION_OPERATION        = $00000040;
  {$EXTERNALSYM BCRYPT_KEY_DERIVATION_OPERATION}

// USE EXTREME CAUTION: editing comments that contain "certenrolls_*" tokens
// could break building CertEnroll idl files:
// certenrolls_begin -- BCRYPT_ALGORITHM_IDENTIFIER
type
  PBCryptAlgorithmIdentifier = ^TBCryptAlgorithmIdentifier;
  _BCRYPT_ALGORITHM_IDENTIFIER = record
    pszName: LPWSTR;
    dwClass: ULONG;
    dwFlags: ULONG;
  end;
  {$EXTERNALSYM _BCRYPT_ALGORITHM_IDENTIFIER}
  BCRYPT_ALGORITHM_IDENTIFIER = _BCRYPT_ALGORITHM_IDENTIFIER;
  {$EXTERNALSYM BCRYPT_ALGORITHM_IDENTIFIER}
  TBCryptAlgorithmIdentifier = _BCRYPT_ALGORITHM_IDENTIFIER;
// certenrolls_end

function BCryptEnumAlgorithms(
  dwAlgOperations: ULONG;
  out pAlgCount: ULONG;
  out ppAlgList: PBCryptAlgorithmIdentifier;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptEnumAlgorithms}

type
  PBCryptProviderName = ^TBCryptProviderName;
  _BCRYPT_PROVIDER_NAME = record
    pszProviderName: LPWSTR;
  end;
  {$EXTERNALSYM _BCRYPT_PROVIDER_NAME}
  BCRYPT_PROVIDER_NAME = _BCRYPT_PROVIDER_NAME;
  {$EXTERNALSYM BCRYPT_PROVIDER_NAME}
  TBCryptProviderName = _BCRYPT_PROVIDER_NAME;

function BCryptEnumProviders(
  pszAlgId: LPCWSTR;
  out pImplCount: ULONG;
  out ppImplList: PBCryptProviderName;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptEnumProviders}

// Flags for use with BCryptGetProperty and BCryptSetProperty
const
  BCRYPT_PUBLIC_KEY_FLAG                 = $00000001;
  {$EXTERNALSYM BCRYPT_PUBLIC_KEY_FLAG}
  BCRYPT_PRIVATE_KEY_FLAG                = $00000002;
  {$EXTERNALSYM BCRYPT_PRIVATE_KEY_FLAG}

function BCryptGetProperty(
  hObject: BCRYPT_HANDLE;
  pszProperty: LPCWSTR;
  pbOutput: PUCHAR;
  cbOutput: ULONG;
  out pcbResult: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptGetProperty}

function BCryptSetProperty(
  hObject: BCRYPT_HANDLE;
  pszProperty: LPCWSTR;
  pbInput: PUCHAR;
  cbInput: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptSetProperty}

function BCryptCloseAlgorithmProvider(
  hAlgorithm: BCRYPT_ALG_HANDLE;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptCloseAlgorithmProvider}

procedure BCryptFreeBuffer(
  pvBuffer: PVOID); winapi;
{$EXTERNALSYM BCryptFreeBuffer}

//
// Primitive encryption functions.
//
function BCryptGenerateSymmetricKey(
  hAlgorithm: BCRYPT_ALG_HANDLE;
  out phKey: BCRYPT_KEY_HANDLE;
  pbKeyObject: PUCHAR;
  cbKeyObject: ULONG;
  pbSecret: PUCHAR;
  cbSecret: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptGenerateSymmetricKey}

function BCryptGenerateKeyPair(
  hAlgorithm: BCRYPT_ALG_HANDLE;
  out phKey: BCRYPT_KEY_HANDLE;
  dwLength: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptGenerateKeyPair}

function BCryptEncrypt(
  hKey: BCRYPT_KEY_HANDLE;
  pbInput: PUCHAR;
  cbInput: ULONG;
  pPaddingInfo: Pointer;
  pbIV: PUCHAR;
  cbIV: ULONG;
  pbOutput: PUCHAR;
  cbOutput: ULONG;
  out pcbResult: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptEncrypt}

function BCryptDecrypt(
  hKey: BCRYPT_KEY_HANDLE;
  pbInput: PUCHAR;
  cbInput: ULONG;
  pPaddingInfo: Pointer;
  pbIV: PUCHAR;
  cbIV: ULONG;
  pbOutput: PUCHAR;
  cbOutput: ULONG;
  out pcbResult: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptDecrypt}

function BCryptExportKey(
  hKey: BCRYPT_KEY_HANDLE;
  hExportKey: BCRYPT_KEY_HANDLE;
  pszBlobType: LPCWSTR;
  pbOutput: PUCHAR;
  cbOutput: ULONG;
  out pcbResult: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptExportKey}

function BCryptImportKey(
  hAlgorithm: BCRYPT_ALG_HANDLE;
  hImportKey: BCRYPT_KEY_HANDLE;
  pszBlobType: LPCWSTR;
  out phKey: BCRYPT_KEY_HANDLE;
  pbKeyObject: PUCHAR;
  cbKeyObject: ULONG;
  pbInput: PUCHAR;
  cbInput: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptImportKey}

const
  BCRYPT_NO_KEY_VALIDATION   = $00000008;
  {$EXTERNALSYM BCRYPT_NO_KEY_VALIDATION}

function BCryptImportKeyPair(
  hAlgorithm: BCRYPT_ALG_HANDLE;
  hImportKey: BCRYPT_KEY_HANDLE;
  pszBlobType: LPCWSTR;
  out phKey: BCRYPT_KEY_HANDLE;
  pbInput: PUCHAR;
  cbInput: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi
{$EXTERNALSYM BCryptImportKeyPair}

function BCryptDuplicateKey(
  hKey: BCRYPT_KEY_HANDLE;
  out phNewKey: BCRYPT_KEY_HANDLE;
  pbKeyObject: PUCHAR;
  cbKeyObject: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptDuplicateKey}

function BCryptFinalizeKeyPair(
  hKey: BCRYPT_KEY_HANDLE;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptFinalizeKeyPair}

function BCryptDestroyKey(
  hKey: BCRYPT_KEY_HANDLE): NTSTATUS; winapi;
{$EXTERNALSYM BCryptDestroyKey}

function BCryptDestroySecret(
  hSecret: BCRYPT_SECRET_HANDLE): NTSTATUS; winapi;
{$EXTERNALSYM BCryptDestroySecret}

function BCryptSignHash(
  hKey: BCRYPT_KEY_HANDLE;
  pPaddingInfo: Pointer;
  pbInput: PUCHAR;
  cbInput: ULONG;
  pbOutput: PUCHAR;
  cbOutput: ULONG;
  out pcbResult: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptSignHash}

function BCryptVerifySignature(
  hKey: BCRYPT_KEY_HANDLE;
  pPaddingInfo: Pointer;
  pbHash: PUCHAR;
  cbHash: ULONG;
  pbSignature: PUCHAR;
  cbSignature: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptVerifySignature}

function BCryptSecretAgreement(
  hPrivKey: BCRYPT_KEY_HANDLE;
  hPubKey: BCRYPT_KEY_HANDLE;
  out phAgreedSecret: BCRYPT_SECRET_HANDLE;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptSecretAgreement}

function BCryptDeriveKey(
  hSharedSecret: BCRYPT_SECRET_HANDLE;
  pwszKDF: LPCWSTR;
  pParameterList: PBCryptBufferDesc;
  pbDerivedKey: PUCHAR;
  cbDerivedKey: ULONG;
  out pcbResult: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptDeriveKey}

function BCryptKeyDerivation(
  hKey: BCRYPT_KEY_HANDLE;
  pParameterList: PBCryptBufferDesc;
  pbDerivedKey: PUCHAR;
  cbDerivedKey: ULONG;
  out pcbResult: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptKeyDerivation}

//
// Primitive hashing functions.
//
function BCryptCreateHash(
  hAlgorithm: BCRYPT_ALG_HANDLE;
  out phHash: BCRYPT_HASH_HANDLE;
  pbHashObject: PUCHAR;
  cbHashObject: ULONG;
  pbSecret: PUCHAR;     // optional
  cbSecret: ULONG;      // optional
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptCreateHash}

function BCryptHashData(
  hHash: BCRYPT_HASH_HANDLE;
  pbInput: PUCHAR;
  cbInput: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptHashData}

function BCryptFinishHash(
  hHash: BCRYPT_HASH_HANDLE;
  pbOutput: PUCHAR;
  cbOutput: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptFinishHash}

function BCryptDuplicateHash(
  hHash: BCRYPT_HASH_HANDLE;
  out phNewHash: BCRYPT_HASH_HANDLE;
  pbHashObject: PUCHAR;
  cbHashObject: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptDuplicateHash}

function BCryptDestroyHash(
  hHash: BCRYPT_HASH_HANDLE): NTSTATUS; winapi;
{$EXTERNALSYM BCryptDestroyHash}

//
// Primitive random number generation.
//

// Flags to BCryptGenRandom
const
  BCRYPT_RNG_USE_ENTROPY_IN_BUFFER   = $00000001;
  {$EXTERNALSYM BCRYPT_RNG_USE_ENTROPY_IN_BUFFER}
  BCRYPT_USE_SYSTEM_PREFERRED_RNG    = $00000002;
  {$EXTERNALSYM BCRYPT_USE_SYSTEM_PREFERRED_RNG}

function BCryptGenRandom(
  hAlgorithm: BCRYPT_ALG_HANDLE;
  pbBuffer: PUCHAR;
  cbBuffer: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptGenRandom}

//
// Primitive key derivation functions.
//
function BCryptDeriveKeyCapi(
  hHash: BCRYPT_HASH_HANDLE;
  hTargetAlg: BCRYPT_ALG_HANDLE;
  pbDerivedKey: PUCHAR;
  cbDerivedKey: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptDeriveKeyCapi}

function BCryptDeriveKeyPBKDF2(
  hPrf: BCRYPT_ALG_HANDLE;
  pbPassword: PUCHAR;
  cbPassword: ULONG;
  pbSalt: PUCHAR;
  cbSalt: ULONG;
  cIterations: ULONGLONG;
  pbDerivedKey: PUCHAR;
  cbDerivedKey: ULONG;
  dwFlags: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptDeriveKeyPBKDF2}

//
// Interface version control...
//
type
  PBCryptInterfaceVersion = ^TBCryptInterfaceVersion;
  _BCRYPT_INTERFACE_VERSION = record

    MajorVersion: USHORT;
    MinorVersion: USHORT;

  end;
  {$EXTERNALSYM _BCRYPT_INTERFACE_VERSION}
  BCRYPT_INTERFACE_VERSION = _BCRYPT_INTERFACE_VERSION;
  {$EXTERNALSYM BCRYPT_INTERFACE_VERSION}
  TBCryptInterfaceVersion = _BCRYPT_INTERFACE_VERSION;
  PBCRYPT_INTERFACE_VERSION = PBCryptInterfaceVersion;
  {$EXTERNALSYM PBCRYPT_INTERFACE_VERSION}

//#define BCRYPT_MAKE_INTERFACE_VERSION(major,minor) {(USHORT)major, (USHORT)minor}

//#define BCRYPT_IS_INTERFACE_VERSION_COMPATIBLE(loader, provider)    \
//    ((loader).MajorVersion <= (provider).MajorVersion)

//
// Primitive provider interfaces.
//
const
  BCRYPT_CIPHER_INTERFACE_VERSION_1: TBCryptInterfaceVersion =
    (MajorVersion:1; MinorVersion:0);
  {$EXTERNALSYM BCRYPT_CIPHER_INTERFACE_VERSION_1}

  BCRYPT_HASH_INTERFACE_VERSION_1: TBCryptInterfaceVersion =
    (MajorVersion:1; MinorVersion:0);
  {$EXTERNALSYM BCRYPT_HASH_INTERFACE_VERSION_1}

  BCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE_VERSION_1: TBCryptInterfaceVersion =
    (MajorVersion:1; MinorVersion:0);
  {$EXTERNALSYM BCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE_VERSION_1}

  BCRYPT_SECRET_AGREEMENT_INTERFACE_VERSION_1: TBCryptInterfaceVersion =
    (MajorVersion:1; MinorVersion:0);
  {$EXTERNALSYM BCRYPT_SECRET_AGREEMENT_INTERFACE_VERSION_1}

  BCRYPT_SIGNATURE_INTERFACE_VERSION_1: TBCryptInterfaceVersion =
    (MajorVersion:1; MinorVersion:0);
  {$EXTERNALSYM BCRYPT_SIGNATURE_INTERFACE_VERSION_1}

  BCRYPT_RNG_INTERFACE_VERSION_1: TBCryptInterfaceVersion =
    (MajorVersion:1; MinorVersion:0);
  {$EXTERNALSYM BCRYPT_RNG_INTERFACE_VERSION_1}

//////////////////////////////////////////////////////////////////////////////
// CryptoConfig Definitions //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

// Interface registration flags
const
  CRYPT_MIN_DEPENDENCIES     = ($00000001);
  {$EXTERNALSYM CRYPT_MIN_DEPENDENCIES}
  CRYPT_PROCESS_ISOLATE      = ($00010000); // User-mode only
  {$EXTERNALSYM CRYPT_PROCESS_ISOLATE}

// Processor modes supported by a provider
//
// (Valid for BCryptQueryProviderRegistration and BCryptResolveProviders):
//
const
  CRYPT_UM                   = ($00000001);    // User mode only
  {$EXTERNALSYM CRYPT_UM}
  CRYPT_KM                   = ($00000002);    // Kernel mode only
  {$EXTERNALSYM CRYPT_KM}
  CRYPT_MM                   = ($00000003);    // Multi-mode: Must support BOTH UM and KM
  {$EXTERNALSYM CRYPT_MM}
//
// (Valid only for BCryptQueryProviderRegistration):
//
const
  CRYPT_ANY                  = ($00000004);    // Wildcard: Either UM, or KM, or both
  {$EXTERNALSYM CRYPT_ANY}


// Write behavior flags
const
  CRYPT_OVERWRITE            = ($00000001);
  {$EXTERNALSYM CRYPT_OVERWRITE}

// Configuration tables
const
  CRYPT_LOCAL                = ($00000001);
  {$EXTERNALSYM CRYPT_LOCAL}
  CRYPT_DOMAIN               = ($00000002);
  {$EXTERNALSYM CRYPT_DOMAIN}

// Context configuration flags
const
  CRYPT_EXCLUSIVE            = ($00000001);
  {$EXTERNALSYM CRYPT_EXCLUSIVE}
  CRYPT_OVERRIDE             = ($00010000); // Enterprise table only
  {$EXTERNALSYM CRYPT_OVERRIDE}

// Resolution and enumeration flags
const
  CRYPT_ALL_FUNCTIONS        = ($00000001);
  {$EXTERNALSYM CRYPT_ALL_FUNCTIONS}
  CRYPT_ALL_PROVIDERS        = ($00000002);
  {$EXTERNALSYM CRYPT_ALL_PROVIDERS}

// Priority list positions
const
  CRYPT_PRIORITY_TOP         = ($00000000);
  {$EXTERNALSYM CRYPT_PRIORITY_TOP}
  CRYPT_PRIORITY_BOTTOM      = ($FFFFFFFF);
  {$EXTERNALSYM CRYPT_PRIORITY_BOTTOM}

// Default system-wide context
const
  CRYPT_DEFAULT_CONTEXT      = 'Default';
  {$EXTERNALSYM CRYPT_DEFAULT_CONTEXT}

//////////////////////////////////////////////////////////////////////////////
// CryptoConfig Structures ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//
// Provider Registration Structures
//
type
  PPCryptInterfaceReg = ^PCryptInterfaceReg;
  PCryptInterfaceReg = ^TCryptInterfaceReg;
  _CRYPT_INTERFACE_REG = record
    dwInterface: ULONG;
    dwFlags: ULONG;

    cFunctions: ULONG;
    rgpszFunctions: ^PWSTR;
  end;
  {$EXTERNALSYM _CRYPT_INTERFACE_REG}
  CRYPT_INTERFACE_REG = _CRYPT_INTERFACE_REG;
  {$EXTERNALSYM CRYPT_INTERFACE_REG}
  TCryptInterfaceReg = _CRYPT_INTERFACE_REG;
  PCRYPT_INTERFACE_REG = PCryptInterfaceReg;
  {$EXTERNALSYM PCRYPT_INTERFACE_REG}

type
  PPCryptImageReg = ^PCryptImageReg;
  PCryptImageReg = ^TCryptImageReg;
  _CRYPT_IMAGE_REG = record
    pszImage: PWSTR;

    cInterfaces: ULONG;
    rgpInterfaces: PPCryptInterfaceReg;
  end;
  {$EXTERNALSYM _CRYPT_IMAGE_REG}
  CRYPT_IMAGE_REG = _CRYPT_IMAGE_REG;
  {$EXTERNALSYM CRYPT_IMAGE_REG}
  TCryptImageReg = _CRYPT_IMAGE_REG;
  PCRYPT_IMAGE_REG = PCryptImageReg;
  {$EXTERNALSYM PCRYPT_IMAGE_REG}

type
  PPCryptProviderReg = ^PCryptProviderReg;
  PCryptProviderReg = ^TCryptProviderReg;
  _CRYPT_PROVIDER_REG = record
    cAliases: ULONG;
    rgpszAliases: ^PWSTR;

    pUM: PCryptImageReg;
    pKM: PCryptImageReg;
  end;
  {$EXTERNALSYM _CRYPT_PROVIDER_REG}
  CRYPT_PROVIDER_REG = _CRYPT_PROVIDER_REG;
  {$EXTERNALSYM CRYPT_PROVIDER_REG}
  TCryptProviderReg = _CRYPT_PROVIDER_REG;
  PCRYPT_PROVIDER_REG = PCryptProviderReg;
  {$EXTERNALSYM PCRYPT_PROVIDER_REG}

type
  PPCryptProviders = ^PCryptProviders;
  PCryptProviders = ^TCryptProviders;
  _CRYPT_PROVIDERS = record
    cProviders: ULONG;
    rgpszProviders: ^PWSTR;
  end;
  {$EXTERNALSYM _CRYPT_PROVIDERS}
  CRYPT_PROVIDERS = _CRYPT_PROVIDERS;
  {$EXTERNALSYM CRYPT_PROVIDERS}
  TCryptProviders = _CRYPT_PROVIDERS;
  PCRYPT_PROVIDERS = PCryptProviders;
  {$EXTERNALSYM PCRYPT_PROVIDERS}

//
// Context Configuration Structures
//
type
  PPCryptContextConfig = ^PCryptContextConfig;
  PCryptContextConfig = ^TCryptContextConfig;
  _CRYPT_CONTEXT_CONFIG = record
    dwFlags: ULONG;
    dwReserved: ULONG;
  end;
  {$EXTERNALSYM _CRYPT_CONTEXT_CONFIG}
  CRYPT_CONTEXT_CONFIG = _CRYPT_CONTEXT_CONFIG;
  {$EXTERNALSYM CRYPT_CONTEXT_CONFIG}
  TCryptContextConfig = _CRYPT_CONTEXT_CONFIG;
  PCRYPT_CONTEXT_CONFIG = PCryptContextConfig;
  {$EXTERNALSYM PCRYPT_CONTEXT_CONFIG}

type
  PPCryptContextFunctionConfig = ^PCryptContextFunctionConfig;
  PCryptContextFunctionConfig = ^TCryptContextFunctionConfig;
  _CRYPT_CONTEXT_FUNCTION_CONFIG = record
    dwFlags: ULONG;
    dwReserved: ULONG;
  end;
  {$EXTERNALSYM _CRYPT_CONTEXT_FUNCTION_CONFIG}
  CRYPT_CONTEXT_FUNCTION_CONFIG = _CRYPT_CONTEXT_FUNCTION_CONFIG;
  {$EXTERNALSYM CRYPT_CONTEXT_FUNCTION_CONFIG}
  TCryptContextFunctionConfig = _CRYPT_CONTEXT_FUNCTION_CONFIG;
  PCRYPT_CONTEXT_FUNCTION_CONFIG = PCryptContextFunctionConfig;
  {$EXTERNALSYM PCRYPT_CONTEXT_FUNCTION_CONFIG}

type
  PPCryptContexts = ^PCryptContexts;
  PCryptContexts = ^TCryptContexts;
  _CRYPT_CONTEXTS = record
    cContexts: ULONG;
    rgpszContexts: ^PWSTR;
  end;
  {$EXTERNALSYM _CRYPT_CONTEXTS}
  CRYPT_CONTEXTS = _CRYPT_CONTEXTS;
  {$EXTERNALSYM CRYPT_CONTEXTS}
  TCryptContexts = _CRYPT_CONTEXTS;
  PCRYPT_CONTEXTS = PCryptContexts;
  {$EXTERNALSYM PCRYPT_CONTEXTS}

type
  PPCryptContextFunctions = ^PCryptContextFunctions;
  PCryptContextFunctions = ^TCryptContextFunctions;
  _CRYPT_CONTEXT_FUNCTIONS = record
    cFunctions: ULONG;
    rgpszFunctions: ^PWSTR;
  end;
  {$EXTERNALSYM _CRYPT_CONTEXT_FUNCTIONS}
  CRYPT_CONTEXT_FUNCTIONS = _CRYPT_CONTEXT_FUNCTIONS;
  {$EXTERNALSYM CRYPT_CONTEXT_FUNCTIONS}
  TCryptContextFunctions = _CRYPT_CONTEXT_FUNCTIONS;
  PCRYPT_CONTEXT_FUNCTIONS = PCryptContextFunctions;
  {$EXTERNALSYM PCRYPT_CONTEXT_FUNCTIONS}

type
  PPCryptContextFunctionProviders = ^PCryptContextFunctionProviders;
  PCryptContextFunctionProviders = ^TCryptContextFunctionProviders;
  _CRYPT_CONTEXT_FUNCTION_PROVIDERS = record
    cProviders: ULONG;
    rgpszProviders: ^PWSTR;
  end;
  {$EXTERNALSYM _CRYPT_CONTEXT_FUNCTION_PROVIDERS}
  CRYPT_CONTEXT_FUNCTION_PROVIDERS = _CRYPT_CONTEXT_FUNCTION_PROVIDERS;
  {$EXTERNALSYM CRYPT_CONTEXT_FUNCTION_PROVIDERS}
  TCryptContextFunctionProviders = _CRYPT_CONTEXT_FUNCTION_PROVIDERS;
  PCRYPT_CONTEXT_FUNCTION_PROVIDERS = PCryptContextFunctionProviders;
  {$EXTERNALSYM PCRYPT_CONTEXT_FUNCTION_PROVIDERS}

//
// Provider Resolution Structures
//
type
  PPCryptPropertyRef = ^PCryptPropertyRef;
  PCryptPropertyRef = ^TCryptPropertyRef;
  _CRYPT_PROPERTY_REF = record
    pszProperty: PWSTR;

    cbValue: ULONG;
    pbValue: PUCHAR;
  end;
  {$EXTERNALSYM _CRYPT_PROPERTY_REF}
  CRYPT_PROPERTY_REF = _CRYPT_PROPERTY_REF;
  {$EXTERNALSYM CRYPT_PROPERTY_REF}
  TCryptPropertyRef = _CRYPT_PROPERTY_REF;
  PCRYPT_PROPERTY_REF = PCryptPropertyRef;
  {$EXTERNALSYM PCRYPT_PROPERTY_REF}

type
  PPCryptImageRef = ^PCryptImageRef;
  PCryptImageRef = ^TCryptImageRef;
  _CRYPT_IMAGE_REF = record
    pszImage: PWSTR;
    dwFlags: ULONG;
  end;
  {$EXTERNALSYM _CRYPT_IMAGE_REF}
  CRYPT_IMAGE_REF = _CRYPT_IMAGE_REF;
  {$EXTERNALSYM CRYPT_IMAGE_REF}
  TCryptImageRef = _CRYPT_IMAGE_REF;
  PCRYPT_IMAGE_REF = PCryptImageRef;
  {$EXTERNALSYM PCRYPT_IMAGE_REF}

type
  PPCryptProviderRef = ^PCryptProviderRef;
  PCryptProviderRef = ^TCryptProviderRef;
  _CRYPT_PROVIDER_REF = record
    dwInterface: ULONG;
    pszFunction: PWSTR;
    pszProvider: PWSTR;

    cProperties: ULONG;
    rgpProperties: PPCryptPropertyRef;

    pUM: PCryptImageRef;
    pKM: PCryptImageRef;
  end;
  {$EXTERNALSYM _CRYPT_PROVIDER_REF}
  CRYPT_PROVIDER_REF = _CRYPT_PROVIDER_REF;
  {$EXTERNALSYM CRYPT_PROVIDER_REF}
  TCryptProviderRef = _CRYPT_PROVIDER_REF;
  PCRYPT_PROVIDER_REF = PCryptProviderRef;
  {$EXTERNALSYM PCRYPT_PROVIDER_REF}

type
  PPCryptProviderRefs = ^PCryptProviderRefs;
  PCryptProviderRefs = ^TCryptProviderRefs;
  _CRYPT_PROVIDER_REFS = record
    cProviders: ULONG;
    rgpProviders: PPCryptProviderRef;
  end;
  {$EXTERNALSYM _CRYPT_PROVIDER_REFS}
  CRYPT_PROVIDER_REFS = _CRYPT_PROVIDER_REFS;
  {$EXTERNALSYM CRYPT_PROVIDER_REFS}
  TCryptProviderRefs = _CRYPT_PROVIDER_REFS;
  PCRYPT_PROVIDER_REFS = PCryptProviderRefs;
  {$EXTERNALSYM PCRYPT_PROVIDER_REFS}

//////////////////////////////////////////////////////////////////////////////
// CryptoConfig Functions ////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

function BCryptQueryProviderRegistration(
  pszProvider: LPCWSTR;
  dwMode: ULONG;
  dwInterface: ULONG;
  var pcbBuffer: ULONG;
  ppBuffer: PPCryptProviderReg): NTSTATUS; winapi;
{$EXTERNALSYM BCryptQueryProviderRegistration}

function BCryptEnumRegisteredProviders(
  var pcbBuffer: ULONG;
  ppBuffer: PPCryptProviders): NTSTATUS; winapi;
{$EXTERNALSYM BCryptEnumRegisteredProviders}

//
// Context Configuration Functions
//
function BCryptCreateContext(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  pConfig: PCryptContextConfig): NTSTATUS; winapi;
{$EXTERNALSYM BCryptCreateContext}

function BCryptDeleteContext(
  dwTable: ULONG;
  pszContext: LPCWSTR): NTSTATUS; winapi;
{$EXTERNALSYM BCryptDeleteContext}

function BCryptEnumContexts(
  dwTable: ULONG;
  var pcbBuffer: ULONG;
  ppBuffer: PPCryptContexts): NTSTATUS; winapi;
{$EXTERNALSYM BCryptEnumContexts}

function BCryptConfigureContext(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  pConfig: PCryptContextConfig): NTSTATUS; winapi;
{$EXTERNALSYM BCryptConfigureContext}

function BCryptQueryContextConfiguration(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  var pcbBuffer: ULONG;
  ppBuffer: PPCryptContextConfig): NTSTATUS; winapi;
{$EXTERNALSYM BCryptQueryContextConfiguration}

function BCryptAddContextFunction(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  dwInterface: ULONG;
  pszFunction: LPCWSTR;
  dwPosition: ULONG): NTSTATUS; winapi;
{$EXTERNALSYM BCryptAddContextFunction}

function BCryptRemoveContextFunction(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  dwInterface: ULONG;
  pszFunction: LPCWSTR): NTSTATUS; winapi;
{$EXTERNALSYM BCryptRemoveContextFunction}

function BCryptEnumContextFunctions(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  dwInterface: ULONG;
  var pcbBuffer: ULONG;
  ppBuffer: PPCryptContextFunctions): NTSTATUS; winapi;
{$EXTERNALSYM BCryptEnumContextFunctions}

function BCryptConfigureContextFunction(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  dwInterface: ULONG;
  pszFunction: LPCWSTR;
  pConfig: PCryptContextFunctionConfig): NTSTATUS; winapi;
{$EXTERNALSYM BCryptConfigureContextFunction}

function BCryptQueryContextFunctionConfiguration(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  dwInterface: ULONG;
  pszFunction: LPCWSTR;
  var pcbBuffer: ULONG;
  ppBuffer: PPCryptContextFunctionConfig): NTSTATUS; winapi;
{$EXTERNALSYM BCryptQueryContextFunctionConfiguration}

function BCryptEnumContextFunctionProviders(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  dwInterface: ULONG;
  pszFunction: LPCWSTR;
  var pcbBuffer: ULONG;
  ppBuffer: PPCryptContextFunctionProviders): NTSTATUS; winapi;
{$EXTERNALSYM BCryptEnumContextFunctionProviders}

function BCryptSetContextFunctionProperty(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  dwInterface: ULONG;
  pszFunction: LPCWSTR;
  pszProperty: LPCWSTR;
  cbValue: ULONG;
  pbValue: PUCHAR): NTSTATUS; winapi;
{$EXTERNALSYM BCryptSetContextFunctionProperty}

function BCryptQueryContextFunctionProperty(
  dwTable: ULONG;
  pszContext: LPCWSTR;
  dwInterface: ULONG;
  pszFunction: LPCWSTR;
  pszProperty: LPCWSTR;
  var pcbValue: ULONG;
  out ppbValue: PUCHAR): NTSTATUS; winapi;
{$EXTERNALSYM BCryptQueryContextFunctionProperty}

//
// Configuration Change Notification Functions
//

function BCryptRegisterConfigChangeNotify(
  out phEvent: THandle): NTSTATUS; winapi;
{$EXTERNALSYM BCryptRegisterConfigChangeNotify}

function BCryptUnregisterConfigChangeNotify(
  hEvent: THandle): NTSTATUS; winapi;
{$EXTERNALSYM BCryptUnregisterConfigChangeNotify}

//
// Provider Resolution Functions
//
function BCryptResolveProviders(
  pszContext: LPCWSTR;
  dwInterface: ULONG;
  pszFunction: LPCWSTR;
  pszProvider: LPCWSTR;
  dwMode: ULONG;
  dwFlags: ULONG;
  var pcbBuffer: ULONG;
  ppBuffer: PPCryptProviderRefs): NTSTATUS; winapi;
{$EXTERNALSYM BCryptResolveProviders}

//
// Miscellaneous queries about the crypto environment
//
function BCryptGetFipsAlgorithmMode(
  out pfEnabled: ByteBool): NTSTATUS; winapi;
{$EXTERNALSYM BCryptGetFipsAlgorithmMode}

{$ENDREGION}

implementation

const
  BCryptDll = 'bcrypt.dll';

{$REGION 'bcrypt.h'}
function BCryptOpenAlgorithmProvider; external BCryptDll name 'BCryptOpenAlgorithmProvider' delayed;
function BCryptEnumAlgorithms; external BCryptDll name 'BCryptEnumAlgorithms' delayed;
function BCryptEnumProviders; external BCryptDll name 'BCryptEnumProviders' delayed;
function BCryptGetProperty; external BCryptDll name 'BCryptGetProperty' delayed;
function BCryptSetProperty; external BCryptDll name 'BCryptSetProperty' delayed;
function BCryptCloseAlgorithmProvider; external BCryptDll name 'BCryptCloseAlgorithmProvider' delayed;
procedure BCryptFreeBuffer; external BCryptDll name 'BCryptFreeBuffer' delayed;
function BCryptGenerateSymmetricKey; external BCryptDll name 'BCryptGenerateSymmetricKey' delayed;
function BCryptGenerateKeyPair; external BCryptDll name 'BCryptGenerateKeyPair' delayed;
function BCryptEncrypt; external BCryptDll name 'BCryptEncrypt' delayed;
function BCryptDecrypt; external BCryptDll name 'BCryptDecrypt' delayed;
function BCryptExportKey; external BCryptDll name 'BCryptExportKey' delayed;
function BCryptImportKey; external BCryptDll name 'BCryptImportKey' delayed;
function BCryptImportKeyPair; external BCryptDll name 'BCryptImportKeyPair' delayed;
function BCryptDuplicateKey; external BCryptDll name 'BCryptDuplicateKey' delayed;
function BCryptFinalizeKeyPair; external BCryptDll name 'BCryptFinalizeKeyPair' delayed;
function BCryptDestroyKey; external BCryptDll name 'BCryptDestroyKey' delayed;
function BCryptDestroySecret; external BCryptDll name 'BCryptDestroySecret' delayed;
function BCryptSignHash; external BCryptDll name 'BCryptSignHash' delayed;
function BCryptVerifySignature; external BCryptDll name 'BCryptVerifySignature' delayed;
function BCryptSecretAgreement; external BCryptDll name 'BCryptSecretAgreement' delayed;
function BCryptDeriveKey; external BCryptDll name 'BCryptDeriveKey' delayed;
function BCryptKeyDerivation; external BCryptDll name 'BCryptKeyDerivation' delayed;
function BCryptCreateHash; external BCryptDll name 'BCryptCreateHash' delayed;
function BCryptHashData; external BCryptDll name 'BCryptHashData' delayed;
function BCryptFinishHash; external BCryptDll name 'BCryptFinishHash' delayed;
function BCryptDuplicateHash; external BCryptDll name 'BCryptDuplicateHash' delayed;
function BCryptDestroyHash; external BCryptDll name 'BCryptDestroyHash' delayed;
function BCryptGenRandom; external BCryptDll name 'BCryptGenRandom' delayed;
function BCryptDeriveKeyCapi; external BCryptDll name 'BCryptDeriveKeyCapi' delayed;
function BCryptDeriveKeyPBKDF2; external BCryptDll name 'BCryptDeriveKeyPBKDF2' delayed;
function BCryptQueryProviderRegistration; external BCryptDll name 'BCryptQueryProviderRegistration' delayed;
function BCryptEnumRegisteredProviders; external BCryptDll name 'BCryptEnumRegisteredProviders' delayed;
function BCryptCreateContext; external BCryptDll name 'BCryptCreateContext' delayed;
function BCryptDeleteContext; external BCryptDll name 'BCryptDeleteContext' delayed;
function BCryptEnumContexts; external BCryptDll name 'BCryptEnumContexts' delayed;
function BCryptConfigureContext; external BCryptDll name 'BCryptConfigureContext' delayed;
function BCryptQueryContextConfiguration; external BCryptDll name 'BCryptQueryContextConfiguration' delayed;
function BCryptAddContextFunction; external BCryptDll name 'BCryptAddContextFunction' delayed;
function BCryptRemoveContextFunction; external BCryptDll name 'BCryptRemoveContextFunction' delayed;
function BCryptEnumContextFunctions; external BCryptDll name 'BCryptEnumContextFunctions' delayed;
function BCryptConfigureContextFunction; external BCryptDll name 'BCryptConfigureContextFunction' delayed;
function BCryptQueryContextFunctionConfiguration; external BCryptDll name 'BCryptQueryContextFunctionConfiguration' delayed;
function BCryptEnumContextFunctionProviders; external BCryptDll name 'BCryptEnumContextFunctionProviders' delayed;
function BCryptSetContextFunctionProperty; external BCryptDll name 'BCryptSetContextFunctionProperty' delayed;
function BCryptQueryContextFunctionProperty; external BCryptDll name 'BCryptQueryContextFunctionProperty' delayed;
function BCryptRegisterConfigChangeNotify; external BCryptDll name 'BCryptRegisterConfigChangeNotify' delayed;
function BCryptUnregisterConfigChangeNotify; external BCryptDll name 'BCryptUnregisterConfigChangeNotify' delayed;
function BCryptResolveProviders; external BCryptDll name 'BCryptResolveProviders' delayed;
function BCryptGetFipsAlgorithmMode; external BCryptDll name 'BCryptGetFipsAlgorithmMode' delayed;

function BCRYPT_SUCCESS(Status: NTSTATUS): Boolean; inline;
begin
  Result := Status >= 0;
end;

procedure BCRYPT_INIT_AUTH_MODE_INFO(var _AUTH_INFO_STRUCT_: TBCryptAuthenticatedCipherModeInfo); inline;
begin
  FillChar(_AUTH_INFO_STRUCT_, SizeOf(TBCryptAuthenticatedCipherModeInfo), $00);
  _AUTH_INFO_STRUCT_.cbSize := SizeOf(TBCryptAuthenticatedCipherModeInfo);
  _AUTH_INFO_STRUCT_.dwInfoVersion := BCRYPT_AUTHENTICATED_CIPHER_MODE_INFO_VERSION;
end;

{$ENDREGION}

end.
