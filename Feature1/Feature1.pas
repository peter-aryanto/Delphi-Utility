unit Feature1;

interface

uses
  System.Classes
  , Spring.Container.Common
  ;

type
  TComponentTypeSetting = (ctUnknown, ct2a, ct2b);

  ISampleSetting = interface
    ['{A467F885-FFA6-4EED-9870-AC8183E74E59}']
    function GetComponentType: TComponentTypeSetting;
    procedure SetComponentType(const AValue: TComponentTypeSetting);
    property ComponentType: TComponentTypeSetting read GetComponentType write SetComponentType;
  end;

  IPassiveFactoryMadeComponent = interface
    ['{61129346-224F-4D8B-BF1E-A2750BAB6E86}']
    function GetComponentName: string;
    property ComponentName: string read GetComponentName;
  end;

  IActiveFactoryMadeComponent = interface
    ['{B9D9BB5A-66A8-49B8-BC6D-3C21DA753508}']
    function GetComponentName: string;
    property ComponentName: string read GetComponentName;
  end;

  ISampleFactoryDependant = interface
    ['{5036F159-AE9E-4A51-8F89-6FEEFABF212A}']
    function GetOpeningText: string;
    function GetClosingText: string;
    function GetPassiveFactoryMadeComponent: IPassiveFactoryMadeComponent;
    function GetActiveFactoryMadeComponent: IActiveFactoryMadeComponent;
    property OpeningText: string read GetOpeningText;
    property ClosingText: string read GetClosingText;
    property PassiveFactoryMadeComponent: IPassiveFactoryMadeComponent
      read GetPassiveFactoryMadeComponent;
    property ActiveFactoryMadeComponent: IActiveFactoryMadeComponent
      read GetActiveFactoryMadeComponent;
  end;

  {$m+}
  // Passive Factory does not have an actual implementation.
  ISamplePassiveFactory = interface
    ['{22BB79E7-2005-45EB-946C-BF8EBC45C9DB}']
    // CreateStringList method demonstrate the use of Factory to create objects of  built-in types.
    function CreateStringList: TStringList;
    function CreateComponent: IPassiveFactoryMadeComponent;
  end;
  {$m-}

  ISampleActiveFactory = interface
    ['{8B78292C-8C2B-4265-88AF-AABF69780AEB}']
    function CreateComponent: IActiveFactoryMadeComponent;
  end;

  TSampleSetting = class(TInterfacedObject, ISampleSetting)
  private
    FComponentType: TComponentTypeSetting;
    function GetComponentType: TComponentTypeSetting;
    procedure SetComponentType(const AType: TComponentTypeSetting);
  end;

  TSampleFactoryDependant = class(TInterfacedObject, ISampleFactoryDependant)
  private
    FIntroTextList: TStringList;
    FPassiveFactoryMadeComponent: IPassiveFactoryMadeComponent;
    FActiveFactoryMadeComponent: IActiveFactoryMadeComponent;
    FClosingText: string;
    function GetOpeningText: string;
    function GetClosingText: string;
    function GetPassiveFactoryMadeComponent: IPassiveFactoryMadeComponent;
    function GetActiveFactoryMadeComponent: IActiveFactoryMadeComponent;
  public
    [Inject] constructor Create(
      const ASamplePassiveFactory: ISamplePassiveFactory;
      const ASampleActiveFactory: ISampleActiveFactory
    );
    destructor Destroy; override;
  end;

  TFactoryMadeComponent1 = class(TInterfacedObject, IPassiveFactoryMadeComponent)
  private const
    CName = 'Component 1';
  private
    function GetComponentName: string;
  end;

  TSampleActiveFactory = class(TInterfacedObject, ISampleActiveFactory)
  private
    FSetting: ISampleSetting;
    function CreateComponent: IActiveFactoryMadeComponent;
  public
    [Inject] constructor Create(const ASetting: ISampleSetting);
  end;

  TFactoryMadeComponent2a = class(TInterfacedObject, IActiveFactoryMadeComponent)
  private const
    CName = 'Component 2a';
  private
    function GetComponentName: string;
  end;

  TFactoryMadeComponent2b = class(TInterfacedObject, IActiveFactoryMadeComponent)
  private const
    CName = 'Component 2b';
  private
    function GetComponentName: string;
  end;

implementation

uses
  Spring.Container
  ;

{ TSampleFactoryDependant }

constructor TSampleFactoryDependant.Create(
  const ASamplePassiveFactory: ISamplePassiveFactory;
  const ASampleActiveFactory: ISampleActiveFactory
);
begin
  FIntroTextList := ASamplePassiveFactory.CreateStringList;
  FIntroTextList.Add('Hello;');
  FIntroTextList.Add('World;');

  FPassiveFactoryMadeComponent := ASamplePassiveFactory.CreateComponent;

  FActiveFactoryMadeComponent := ASampleActiveFactory.CreateComponent;
  if FActiveFactoryMadeComponent <> nil then
    FClosingText := FActiveFactoryMadeComponent.ComponentName + '.'
  else
    FClosingText := 'No Component 2.';
end;

destructor TSampleFactoryDependant.Destroy;
begin
  FIntroTextList.Free;
  inherited;
end;

function TSampleFactoryDependant.GetOpeningText: string;
begin
  Result := FIntroTextList.Text;
end;

function TSampleFactoryDependant.GetClosingText: string;
begin
  Result := FClosingText;
end;

function TSampleFactoryDependant.GetPassiveFactoryMadeComponent: IPassiveFactoryMadeComponent;
begin
  Result := FPassiveFactoryMadeComponent;
end;

function TSampleFactoryDependant.GetActiveFactoryMadeComponent: IActiveFactoryMadeComponent;
begin
  Result := FActiveFactoryMadeComponent;
end;

{ TSampleSetting }

function TSampleSetting.GetComponentType: TComponentTypeSetting;
begin
  Result := FComponentType;
end;

procedure TSampleSetting.SetComponentType(const AType: TComponentTypeSetting);
begin
  FComponentType := AType;
end;

{ TFactoryMadeComponent1 }

function TFactoryMadeComponent1.GetComponentName: string;
begin
  Result := CName;
end;

{ TSampleActiveFactory }

constructor TSampleActiveFactory.Create(const ASetting: ISampleSetting);
begin
  FSetting := ASetting;
end;

function TSampleActiveFactory.CreateComponent: IActiveFactoryMadeComponent;
begin
  case FSetting.ComponentType of
    ct2a:
    begin
      Result := TFactoryMadeComponent2a.Create;
    end;

    ct2b:
    begin
      Result := TFactoryMadeComponent2b.Create;
    end;

    else
    begin
      Result := nil;
    end;
  end;
end;

{ TFactoryMadeComponent2a }

function TFactoryMadeComponent2a.GetComponentName: string;
begin
  Result := CName;
end;

{ TFactoryMadeComponent2b }

function TFactoryMadeComponent2b.GetComponentName: string;
begin
  Result := CName;
end;

initialization
  GlobalContainer.RegisterType<TSampleFactoryDependant>.Implements<ISampleFactoryDependant>;

  GlobalContainer.RegisterFactory<ISamplePassiveFactory>.AsSingleton;
  GlobalContainer.RegisterType<TStringList>;
  GlobalContainer.RegisterType<TFactoryMadeComponent1>.Implements<IPassiveFactoryMadeComponent>;

//  GlobalContainer.RegisterFactory<ISampleActiveFactory>.AsSingleton;
  GlobalContainer.RegisterType<TSampleActiveFactory>.Implements<ISampleActiveFactory>
    .AsSingleton;
  GlobalContainer.RegisterType<TFactoryMadeComponent2a>.Implements<IActiveFactoryMadeComponent>;
  GlobalContainer.RegisterType<TFactoryMadeComponent2b>.Implements<IActiveFactoryMadeComponent>;
  GlobalContainer.RegisterType<TSampleSetting>.AsSingleton;
end.
