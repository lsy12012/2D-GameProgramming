unit Engine;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes,
  FMX.Graphics, FMX.Types, FMX.Dialogs, FMX.Objects, FMX.Media, System.IOUtils;

const
  TimerInterval     = 50;                {게임속도   ? / 1000 sec                                              }
  BoysMoveLow       = 2;                 {천천히 걸어가는 속도(픽셀)                                           }
  BoysMoveHigh      = 4;                 {빨리 걸어가는 속도(픽셀)                                             }
  BoyPause          = 2;                 {다음 액션을 선택할때의 랜덤비율   BoyPause : BoyMove : BoyShootSnow  }
  BoyMove           = 3;                 {                                      2    :    3    :    6          }
  BoyShootSnow      = 6;
  BoyGoIn           = 160;               {레벨시작시 걸어들어오기전의 위치                                     }
  BoyMouseUpMax     = 15;                {마우스업의 최대스텝                                                  }
  BoyHitAreaHeight  = 10;                {Boy의 충돌영역 세로높이                                              }
  BoyHitAreaWidth   = 22;                {Boy의 충돌영역 가로폭                                                }
  BoyMouseUpDefStep = 10;                {마우스업이될때의 CurrStep시작값                                      }
  SnowShootTop      = 10;                {Boy.Top에서 Snow.Top까지의 세로거리                                  }
  SnowShadowTop     = 25;                {눈과 눈그림자사이의 세로거리                                         }
  SnowLeft          = 23;                {눈이 던져질때(생성) Boy의 Left에서 눈까지의 가로거리                 }
  ShootStep         = 10;                {눈이 던져질 시기                                                     }
  SnowHoriSpeed     = 20;                {눈이 날아갈때 가로로 움직이는 픽셀                                   }
  SnowVertSpeed     = 10;                {눈이 날아갈때 세로로 움직이는 픽셀                                   }
  SnowDeadMax       = 6;                 {눈이 어딘가에 부딪힐때의 최대스텝                                    }
  SnowShootMax      = 5;                 {눈던지기의 최대스텝                                                  }
  BunkerDown        = 9;                 {벙커가 눈에 몇 번 맞아야 없어지는가                                  }
  ShootSnowMax      = 15;                {눈을 던질때의 최대스텝                                               }
  baHit1Max         = 3;                 {첫번째 맞을때의 최대스텝                                             }
  baHit2Max         = 20;                {두번째 맞을때의 최대스텝                                             }
  baHit3Max         = 2;                 {마지막 맞을때의 최대스텝                                             }
  MeDeadRight       = 10;                {아군이 죽을때 나가떨어지는 거리(우)                                  }
  MeDeadBottom      = 22;                {아군이 죽을때 나가떨어지는 거리(하)                                  }
  YouDeadLeft       = 20;                {적군이 죽을때 나가떨어지는 거리(좌)                                  }
  YouDeadTop        = 6;                 {적군이 죽을때 나가떨어지는 거리(상)                                  }
  MoveSideCount     = 8;                 {이동방향종류(TMoveSide)의 갯수                                       }
  PauseRandom       = 10;                {멍하니 있을때의 최대스텝                                             }
  MoveSpeedRandom   = 5;                 {이동속도를 느리게할거나 빠르게할거냐를 정하는 랜덤(느:빠 = ?:1)      }
  MoveMaxRandom     = 10;                {이동할때의 최대스텝 랜덤                                             }
  DelayMax          = 20;                {눈 맞고 나서 멍하니 있을때의 최대스텝                                }
  PowerRandom       = 18;                {눈을 던질때 랜덤으로 던지는 세기를 지정                              }

  LogoAngleStart    = -150;              {로고화면 처음 시작 각도                                              }
  LogoRotateDelay   = 30;                {로고화면 각도0위치에서 돌지않고 정지해 있는 시간                     }
  IntroInterval     = 15;                {게임시작시 처음 딜레이시간                                           }
  StageIntroMax     = 50;
  StageOverMax      = 20;

  PowerLevelLeft    = 14;                {Boy.Left에서 파워레벨까지의 가로거리(픽셀)                           }
  PowerLevelTop     = -35;
  FocusLeft         = -15;               {Boy.Left에서 포커스까지의 가로거리                                   }
  FocusTop          = 24;                {Boy.Top에서 포커스까지의 세로거리                                    }
  ShootLevelCount   = 10;                {던지기 파워레벨 단계 수                                              }
  ShootLevels: array[1..ShootLevelCount] of Integer = ( 1, 2, 3 ,4 , 5, 6, 8, 10, 13, 17 );{레벨별 던지기세기}
  clFont            = TAlphaColor( $FF4284AD ); {기본글꼴색                                                           }
  CaretToggleMax    = 8;                 {케럿이 깜빡거리는 속도                                               }
  MsgFontName       = '굴림';            {텍스트메세지 글꼴이름                                                }
  MsgFontSize       = 12;                {텍스트메세지 글꼴크기                                                }
  MsgFontColor      = clFont;            {텍스트메세지 글꼴색                                                  }
  MsgFontStyle      = [TFontStyle.fsBold];          {텍스트메세지 글꼴스타일                                              }

  Message_SystemLowSpeed = '시스템속도가 느려서 게임을 진행할 수 없습니다';

type

{ TCharacter }

  TCharacterCollection = class;
  TCharacterList = class;
  TTeam = (tmTeam1, tmTeam2);

  TCharacter = class(TCollectionItem)
  private
    FOwner: TCharacterCollection;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FTeam: TTeam;
    FMaxStep: Integer;
    FCurrStep: Integer;
    FIsOut: Boolean;
    FMediaPlayer: TMediaPlayer;
    function GetBounds: TRect;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure DrawShadow(const Canvas: TCanvas); virtual; abstract;
    procedure Draw(const Canvas: TCanvas); virtual; abstract;
    procedure ProcessStep; virtual; abstract;
    procedure SetHitAction; virtual; abstract;
    procedure SetNextAction; virtual; abstract;
    procedure IncLeft(Value: Integer);
    procedure IncTop(Value: Integer);
    procedure DecLeft(Value: Integer);
    procedure DecTop(Value: Integer);
    function IsHit(const SnowRect: TRect): Boolean; virtual;
    function IsLive: Boolean; virtual;
    function CanHitAction: Boolean; virtual;
    procedure Sound(const ResName: String);
    property Left: Integer read FLeft write FLeft;
    property Top: Integer read FTop write FTop;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property Bounds: TRect read GetBounds;
    property Team: TTeam read FTeam;
    property MaxStep: Integer read FMaxStep write FMaxStep;
    property CurrStep: Integer read FCurrStep write FCurrStep;
    property IsOut: Boolean read FIsOut write FIsOut;
  end;

{ TBoy }

  TBoyAction = (baGoIn, baPause, baMove, baShootSnow, baMakeBunker, baHit1, baDelay, baHit2, baHit3, baDead, baFocused, baMouseDown, baMouseUp);
  TMoveSide = (msFront, msBack, msLeft, msRight, msFrontLeft, msFrontRight, msBackLeft, msBackRight);

  TBoy = class(TCharacter)
  private
    FHitCount: Integer;
    FAction: TBoyAction;
    FMoveSide: TMoveSide;
    FPowerLevel: Integer;
    FMovePixel: Integer;
    FMakeBunker: TCharacter;
    procedure ShootSnow(Power: Integer);
    function IsDead: Boolean;
    function CanFocusAction: Boolean;
    function CanMouseEvent: Boolean;
  public
    destructor Destroy; override;
    procedure DrawShadow(const Canvas: TCanvas); override;
    procedure Draw(const Canvas: TCanvas); override;
    procedure ProcessStep; override;
    procedure SetHitAction; override;
    procedure SetNextAction; override;
    function CanHitAction: Boolean; override;
    function IsHit(const SnowRect: TRect): Boolean; override;
    function IsLive: Boolean; override;
    function Focused: Boolean;
    property Action: TBoyAction read FAction write FAction default baPause;
  end;

{ TSnow }

  TSnowAction = (saShoot, saDown, saDead);

  TSnow = class(TCharacter)
  private
    FAction: TSnowAction;
    FShadowTop: Integer;
    function ShadowBounds: TRect;
  public
    procedure DrawShadow(const Canvas: TCanvas); override;
    procedure Draw(const Canvas: TCanvas); override;
    procedure ProcessStep; override;
    procedure SetHitAction; override;
    procedure SetNextAction; override;
    property Action: TSnowAction read FAction write FAction default saShoot;
    property ShadowTop: Integer read FShadowTop write FShadowTop;
  end;

{ TBunker }

  TBunkerAction = (kaNormal, kaDead);

  TBunker = class(TCharacter)
  private
    FAction: TBunkerAction;
    FHitCount: Integer;
  public
    procedure DrawShadow(const Canvas: TCanvas); override;
    procedure Draw(const Canvas: TCanvas); override;
    procedure ProcessStep; override;
    procedure SetHitAction; override;
    procedure SetNextAction; override;
    function CheckPoint(X, Y: Integer): Boolean;
    function IsHit(const SnowRect: TRect): Boolean; override;
    property Action: TBunkerAction read FAction write FAction default kaNormal;
  end;

{ TCharacterList }

  TCharacterList = class(TCollection)
  private
    FOwner: TCharacterCollection;
    FTeam: TTeam;
    function GetCharacters(Index: Integer): TCharacter;
  protected
    procedure Added(var Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TCharacterCollection; ItemClass: TCollectionItemClass; ATeam: TTeam);
    function IndexOf(const Character: TCharacter): Integer;
    procedure MoveToFirst(Index: Integer);
    function LiveCount: Integer;
    property Characters[ Index: Integer ]: TCharacter read GetCharacters; default;
  end;

{ TCharacterCollection }

  TGameAction = (gaReady, gaStageIntro, gaStageStart, gaStageOver, gaGameOver);
  TImageType = (itBack1, itBack4, itFocus);
  TSysImageType = (siLogo);
  TGetImage = function (ImageType: TImageType): TBitmap of object;
  TGetBoyImage = function (Team: TTeam; BoyAction: TBoyAction; Step: Integer; IsShadow: Boolean): TBitmap of object;
  TGetSnowImage = function (SnowAction: TSnowAction; Step: Integer; IsShadow: Boolean): TBitmap of object;
  TGetBoyPowerLevelImage = function (Stage: Integer): TBitmap of object;
  TGetBunkerImage = function (Team: TTeam; BunkerAction: TBunkerAction; Step: Integer): TBitmap of object;
  TGetSystemImage = function (SysImageType: TSysImageType): TBitmap of object;

  TCharacterCollection = class
  private
    FYouBoyList: TCharacterList;
    FYouSnowList: TCharacterList;
    FYouBunkerList: TCharacterList;
    FMeBoyList: TCharacterList;
    FMeSnowList: TCharacterList;
    FMeBunkerList: TCharacterList;

    FActive: Boolean;
    FTimer: TTimer;
    FPaintBox: TPaintBox;
    FCanvasWidth: Integer;
    FCanvasHeight: Integer;

    FStage: Integer;
    FGameAction: TGameAction;
    FMaxStep: Integer;
    FCurrStep: Integer;
    FToggleBoyAction: Boolean;
    FFocusBoy: TBoy;
    FMouseDown: Boolean;
    FMouseDownPoint: TPoint;
    FMouseLeft: Boolean;
    FMediaPlayer: TMediaPlayer;

    procedure CharactersClear;
    procedure SetStageIntro;
    procedure SetStageStart(Stage: Integer);
    procedure SetStageOver;
    procedure SetGameOver;
    procedure LoadStageData(AStage: Integer);

    procedure OnTimer(Sender: TObject);
    procedure SetNextAction;

    procedure ProcessStageIntro;
    procedure ProcessStageStart;
    procedure ProcessStageOver;

    procedure DrawReady(const Canvas: TCanvas);
    procedure DrawStageIntro(const Canvas: TCanvas);
    procedure DrawStageStart(const Canvas: TCanvas);
    procedure DrawStageOver(const Canvas: TCanvas);

    procedure ShowTextCenter(const Canvas: TCanvas; const Text: String);
    procedure ShowText(const Canvas: TCanvas; const Text: String; X, Y: Single; Color: TAlphaColor);
    function BunkerFromRect(Team: TTeam; const ARect: TRect): TBunker;
  protected
    property GameAction: TGameAction read FGameAction;
    property YouBoyList: TCharacterList read FYouBoyList;
    property YouSnowList: TCharacterList read FYouSnowList;
    property YouBunkerList: TCharacterList read FYouBunkerList;
    property MeBoyList: TCharacterList read FMeBoyList;
    property MeSnowList: TCharacterList read FMeSnowList;
    property MeBunkerList: TCharacterList read FMeBunkerList;
    property CanvasWidth: Integer read FCanvasWidth;
    property CanvasHeight: Integer read FCanvasHeight;
  public
    Image_YouStop: TBitmap;
    Image_YouMove1: TBitmap;
    Image_YouMove2: TBitmap;
    Image_YouShoot1: TBitmap;
    Image_YouShoot2: TBitmap;
    Image_YouShoot3: TBitmap;
    Image_YouHit: TBitmap;
    Image_YouDelay1: TBitmap;
    Image_YouDelay2: TBitmap;
    Image_YouDown: TBitmap;
    Image_YouDead2: TBitmap;
    Image_YouDead1: TBitmap;
    Image_MeShadow: TBitmap;
    Image_MeStop: TBitmap;
    Image_MeMove1: TBitmap;
    Image_MeMove2: TBitmap;
    Image_MeShoot1: TBitmap;
    Image_MeShoot2: TBitmap;
    Image_MeShoot3: TBitmap;
    Image_MeHit: TBitmap;
    Image_MeDelay1: TBitmap;
    Image_MeDelay2: TBitmap;
    Image_MeDown: TBitmap;
    Image_MeDead: TBitmap;
    Image_YouShadow: TBitmap;
    Image_Snow: TBitmap;
    Image_SnowShadow: TBitmap;
    Image_SnowDead1: TBitmap;
    Image_SnowDead2: TBitmap;
    Image_Focus: TBitmap;
    Image_BunkerMe1: TBitmap;
    Image_BunkerMe2: TBitmap;
    Image_BunkerMe3: TBitmap;
    Image_BunkerMe4: TBitmap;
    Image_BunkerYou1: TBitmap;
    Image_BunkerYou2: TBitmap;
    Image_BunkerYou3: TBitmap;
    Image_BunkerYou4: TBitmap;
    Image_Back1: TBitmap;
    Image_Back4: TBitmap;
    Image_Logo: TBitmap;
    Image_Power1: TBitmap;
    Image_Power2: TBitmap;
    Image_Power3: TBitmap;
    Image_Power4: TBitmap;
    Image_Power5: TBitmap;
    Image_Power6: TBitmap;
    Image_Power7: TBitmap;
    Image_Power8: TBitmap;
    Image_Power9: TBitmap;
    Image_Power10: TBitmap;
  public
    constructor Create(const PaintBox: TPaintBox);
    destructor Destroy; override;
    procedure StartGame;
    procedure StopGame;
    procedure Pause;
    procedure Restart;
    procedure MouseDown(X, Y: Integer; IsLeft: Boolean = True);
    procedure MouseMove(X, Y: Integer);
    procedure MouseUp(X, Y: Integer);
    procedure Draw(const Canvas: TCanvas);
    procedure Sound(const ResName: String);
    property Active: Boolean read FActive;

    function GetImage(ImageType: TImageType): TBitmap;
    function GetBoyImage(Team: TTeam; BoyAction: TBoyAction; Step: Integer; IsShadow: Boolean): TBitmap;
    function GetSnowImage(SnowAction: TSnowAction; Step: Integer; IsShadow: Boolean): TBitmap;
    function GetBoyPowerLevelImage(Level: Integer): TBitmap;
    function GetBunkerImage(Team: TTeam; BunkerAction: TBunkerAction; Step: Integer): TBitmap;
    function GetSystemImage(SysImageType: TSysImageType): TBitmap;
  end;

implementation

uses
  Data, Sound;

{ Utils }

procedure DrawBitmap(const Canvas: TCanvas; Left, Top: Single; Bitmap: TBitmap);
var
  SrcRect, DestRect: TRectF;
begin
  if Bitmap = nil then Exit;

  SrcRect.Left := 0;
  SrcRect.Top := 0;
  SrcRect.Width := Bitmap.Width;
  SrcRect.Height := Bitmap.Height;

  DestRect.Left := Left;
  DestRect.Top := Top;
  DestRect.Width := Bitmap.Width;
  DestRect.Height := Bitmap.Height;

  Canvas.DrawBitmap( Bitmap, SrcRect, DestRect, 1 );
end;

procedure ReverseMoveSide(var AMoveSide: TMoveSide);
const
  AReverseMoveSide: array[TMoveSide] of TMoveSide = ( msBack, msFront, msRight, msLeft, msBackRight, msBackLeft, msFrontRight, msFrontLeft );
begin
  AMoveSide := AReverseMoveSide[ AMoveSide ];
end;

procedure CharacterProcessStep(const CharacterList: TCharacterList);
var
  i: Integer;
begin
  if CharacterList.Count > 0 then
   for i := 0 to CharacterList.Count - 1 do
    CharacterList[ i ].ProcessStep;
end;

procedure DrawShadows(const Canvas: TCanvas; CharacterList: TCharacterList);
var
  i: Integer;
begin
  if CharacterList.Count > 0 then
   for i := 0 to CharacterList.Count - 1 do
    CharacterList[ i ].DrawShadow( Canvas );
end;

procedure DrawCharacters(const Canvas: TCanvas; CharacterList: TCharacterList);
var
  i: Integer;
begin
  if CharacterList.Count > 0 then
   for i := 0 to CharacterList.Count - 1 do
    CharacterList[ i ].Draw( Canvas );
end;

procedure DeleteOutedCharacters(const CharacterList: TCharacterList);
var
  i: Integer;
begin
  if CharacterList.Count > 0 then
   for i := CharacterList.Count - 1 downto 0 do
    if CharacterList[ i ].IsOut then
     CharacterList.Delete( i );
end;

procedure HitChecking(const BoyOrBunker, Snows: TCharacterList);
var
  i, j: Integer;
begin
  if ( BoyOrBunker.Count > 0 ) and ( Snows.Count > 0 ) then
   begin
     for i := 0 to BoyOrBunker.Count - 1 do
      for j := 0 to Snows.Count - 1 do
       if ( not Snows[ j ].IsOut ) and
          ( TSnow( Snows[ j ] ).Action = saShoot ) and
          ( BoyOrBunker[ i ].CanHitAction ) and
          ( BoyOrBunker[ i ].IsHit( TSnow( Snows[ j ] ).ShadowBounds ) ) then
        begin
          Snows[ j ].SetHitAction;
          BoyOrBunker[ i ].SetHitAction;
        end;
   end;
end;

function GetMousePosBoy(const Boys: TCharacterList; X, Y: Integer; IsClick: Boolean): TBoy;
var
  i: Integer;
begin
  Result := nil;

  if Boys.Count > 0 then
   for i := Boys.Count - 1 downto 0 do
    begin
      with TBoy( Boys[ i ] ) do
       begin
         if PtInRect( Bounds, Point( X, Y ) ) and
            not IsDead and
            not( ( Action = baMouseUp ) and ( CurrStep < ShootStep ) ) and
            ( IsClick or ( not IsClick and ( Action <> baMakeBunker ) ) ) then
          begin
            if CanFocusAction then
             Action := baFocused;
            Result := TBoy( Boys[ i ] );
          end;
       end;
     end;
end;

function GetMouseDownPoint(const Boy: TCharacter; X, Y: Integer): TPoint;
begin
  Result.X := X - Boy.Left;
  Result.Y := Y - Boy.Top;
end;

procedure MoveBoyToMousePoint(const Boy: TBoy; MouseDownPoint: TPoint; X, Y, Width, Height: Integer);
var
  P: Integer;
begin
  Boy.Left := X - MouseDownPoint.X;;
  Boy.Top := Y - MouseDownPoint.Y;

  X := Boy.Left;
  P := Round( Width - ( Width * ( Y / Height ) ) );
  if X < P then X := X + ( P - X ) div 2;
  Boy.Left := X;


  Y := Boy.Top;
  P := Round( Height - ( Height * ( X / Width ) ) );
  if Y < P then Y := Y + ( P - Y ) div 2;
  Boy.Top := Y;
end;

{ TCharacter }

constructor TCharacter.Create(Collection: TCollection);
begin
  inherited Create( Collection );

  FMediaPlayer := TMediaPlayer.Create( nil );
end;

destructor TCharacter.Destroy;
begin
  FMediaPlayer.Free;

  inherited Destroy;
end;

function TCharacter.GetBounds: TRect;
begin
  Result := Rect( Left, Top, Left + Width, Top + Height );
end;

function TCharacter.IsHit(const SnowRect: TRect): Boolean;
begin
  Result := False;
end;

function TCharacter.IsLive: Boolean;
begin
  Result := True;
end;

procedure TCharacter.Sound(const ResName: String);
var
  FileName, TempFile: String;
  ResStream: TResourceStream;
begin
  FileName := ResName + '_tmp.mp3';
  TempFile := TPath.Combine( TPath.GetTempPath, FileName );

  if not FileExists( TempFile ) then
   begin
     ResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
     try
       ResStream.SaveToFile( TempFile );
     finally
       ResStream.Free;
     end;
   end;
  FMediaPlayer.Stop;
  FMediaPlayer.Clear;
  FMediaPlayer.FileName := TempFile;
  FMediaPlayer.Play;
end;

function TCharacter.CanHitAction: Boolean;
begin
  Result := True;
end;

procedure TCharacter.IncLeft(Value: Integer);
begin
  Inc( FLeft, Value );
end;

procedure TCharacter.IncTop(Value: Integer);
begin
  Inc( FTop, Value );
end;

procedure TCharacter.DecLeft(Value: Integer);
begin
  Dec( FLeft, Value );
end;

procedure TCharacter.DecTop(Value: Integer);
begin
  Dec( FTop, Value );
end;

{ TBoy }

destructor TBoy.Destroy;
begin
  if FOwner.FFocusBoy = Self then
   begin
     FOwner.FFocusBoy := nil;
     FOwner.FMouseDown := False;
   end;
  inherited Destroy;
end;

procedure TBoy.DrawShadow(const Canvas: TCanvas);
begin
  if Action <> baDead then
   DrawBitmap( Canvas, Left, Top, FOwner.GetBoyImage( Team, Action, FCurrStep, True ) );
end;

function TBoy.Focused: Boolean;
begin
  Result := FOwner.FFocusBoy = Self;
end;

procedure TBoy.Draw(const Canvas: TCanvas);
begin
  DrawBitmap( Canvas, Left, Top, FOwner.GetBoyImage( Team, Action, FCurrStep, False ) );
end;

procedure TBoy.ProcessStep;
procedure CheckPosiotion;
  var
    P: Integer;
  begin
    case FTeam of
     tmTeam1: begin
                P := Round( FOwner.FCanvasWidth - ( FOwner.FCanvasWidth * ( Top / FOwner.FCanvasHeight ) ) );
                if Left < P then Left := Left + ( P - Left ) div 2;

                P := Round( FOwner.FCanvasHeight - ( FOwner.FCanvasHeight * ( Left / FOwner.FCanvasWidth ) ) );
                if Top < P then Top := Top + ( P - Top ) div 2;
              end;
     tmTeam2: begin
                P := Round( FOwner.FCanvasWidth - ( FOwner.FCanvasWidth * ( Top / FOwner.FCanvasHeight ) ) );
                if Left > P then Left := Left - ( Left - P ) div 2;

                P := Round( FOwner.FCanvasHeight - ( FOwner.FCanvasHeight * ( Left / FOwner.FCanvasWidth ) ) );
                if Top > P then Top := Top - ( Top - Top ) div 2;
              end;
     end;
  end;
procedure GoToTop;
  begin
    DecTop( FMovePixel );
    if Top < 0 then
     begin
       Top := 0;
       ReverseMoveSide( FMoveSide );
     end;
  end;
procedure GoToBottom;
  begin
    IncTop( FMovePixel );
    if Top + Height > FOwner.CanvasHeight then
     begin
       Top := FOwner.CanvasHeight - Height;
       ReverseMoveSide( FMoveSide );
     end;
  end;
procedure GoToLeft;
  begin
    DecLeft( FMovePixel );
    if Left < 0 then
     begin
       Left := 0;
       ReverseMoveSide( FMoveSide );
     end;
  end;
procedure GoToRight;
  begin
    IncLeft( FMovePixel );
    if Left + Width > FOwner.CanvasWidth then
     begin
       Left := FOwner.CanvasWidth - Width;
       ReverseMoveSide( FMoveSide );
     end;
  end;
begin
  if Action in [ baMouseDown, baDead ] then
   begin
     Inc( FCurrStep );
     Exit;
   end;

  if ( FCurrStep >= FMaxStep ) or ( Action = baFocused ) then SetNextAction
                                                         else Inc( FCurrStep );

  case Action of
  baPause    : ;
  baGoIn     : begin
                 case Team of
                 tmTeam1: begin
                            DecLeft( BoysMoveHigh );
                            DecTop( BoysMoveHigh );
                          end;
                 tmTeam2: begin
                            IncLeft( BoysMoveHigh );
                            IncTop( BoysMoveHigh );
                          end;
                 end;
               end;
  baMove     : begin
                 case FMoveSide of
                 msFront    : GoToBottom;
                 msBack     : GoToTop;
                 msLeft     : GoToLeft;
                 msRight    : GoToRight;
                 msFrontLeft : begin
                                GoToBottom;
                                GoToLeft;
                              end;
                 msFrontRight: begin
                                GoToBottom;
                                GoToRight;
                              end;
                 msBackLeft : begin
                                GoToTop;
                                GoToLeft;
                              end;
                 msBackRight: begin
                                GoToTop;
                                GoToRight;
                              end;
                 end;

                 CheckPosiotion;
               end;
  baShootSnow : begin
                  if CurrStep = ShootStep then ShootSnow( 0 );
                end;
  baMakeBunker: begin
                  if FMakeBunker <> nil then
                   begin
                     Inc( TBunker( FMakeBunker ).FCurrStep );
                     if TBunker( FMakeBunker ).Action = kaNormal then SetNextAction
                   end
                  else
                   SetNextAction;
                end;
  end;
end;

procedure TBoy.SetHitAction;
begin
  if CanHitAction then
   begin
     case FHitCount of
     0: begin
          Action := baHit1;
          FMaxStep := baHit1Max;
        end;
     1: begin
          Action := baHit2;
          FMaxStep := baHit2Max;
        end;
     2: begin
          Action := baHit3;
          FMaxStep := baHit3Max;
        end;
     end;

     if FOwner.FFocusBoy = Self then
      begin
        FOwner.FFocusBoy := nil;
        FOwner.FMouseDown := False;
      end;

     FCurrStep := 0;
     Inc( FHitCount );
   end;
end;

procedure TBoy.SetNextAction;
var
  RandomAction: Integer;
procedure GetRandomAction;
  begin
    RandomAction := Random( BoyPause + BoyMove + BoyShootSnow );
    case RandomAction of
                     0 .. BoyPause - 1                         : Action := baPause;
              BoyPause .. BoyPause + BoyMove - 1               : Action := baMove;
    BoyPause + BoyMove .. BoyPause + BoyMove + BoyShootSnow - 1: Action := baShootSnow;
    end;
  end;
begin
  case Action of
  baHit1: begin
            Sound( 'oops4' );
            Action := baDelay;
          end;
  baHit2: begin
            Sound( 'oops4' );
            Action := baDelay;
            FCurrStep := 0;
            FMaxStep := baHit2Max;
            Exit;
          end;
  baHit3: begin
             case Team of
             tmTeam1: begin
                        Sound( 'oops1' );

                        Inc( FLeft, MeDeadRight );
                        Inc( FTop, MeDeadBottom );
                        FOwner.MeBoyList.MoveToFirst( FOwner.MeBoyList.IndexOf( Self ) );
                      end;
             tmTeam2: begin
                        if Random( 2 ) = 0 then Sound( 'oops2' )
                                           else Sound( 'oops3' );

                        Dec( FLeft, YouDeadLeft );
                        Dec( FTop, YouDeadTop );
                        FOwner.YouBoyList.MoveToFirst( FOwner.YouBoyList.IndexOf( Self ) );
                      end;
             end;
             Action := baDead;

          end;
  baFocused: begin
               if not Focused then GetRandomAction;
             end;
  else    begin
            if not Focused then GetRandomAction;
          end;
  end;

  FCurrStep := 0;

  case Action of
  baPause    : begin
                 FMaxStep := Random( PauseRandom ) + 1;
                 FMoveSide := TMoveSide( Random( MoveSideCount ) );
               end;
  baMove     : begin
                 Sound( 'foot' );

                 case Random( MoveSpeedRandom ) of
                 0..MoveSpeedRandom-2: FMovePixel := BoysMoveLow;
                    MoveSpeedRandom-1: FMovePixel := BoysMoveHigh;
                 end;
                 FMaxStep := Random( MoveMaxRandom ) + 5;
               end;
  baShootSnow: begin
                 FMaxStep := ShootSnowMax;
               end;
  baDelay    : begin
                 FMaxStep := DelayMax;
               end;
  end;
end;

procedure TBoy.ShootSnow(Power: Integer);
var
  Snow: TSnow;
begin
  case Team of
  tmTeam1: Snow := TSnow(FOwner.FMeSnowList.Add);
  tmTeam2: Snow := TSnow(FOwner.FYouSnowList.Add);
  else Exit;
  end;

  Snow.Action := saShoot;
  Snow.Left := Left + SnowLeft;
  Snow.Top := Top + SnowShootTop;
  Snow.Width := FOwner.GetSnowImage( saShoot, 0, False ).Width;
  Snow.Height := FOwner.GetSnowImage( saShoot, 0, False ).Height;
  Snow.ShadowTop := Top + SnowShadowTop;
  Snow.CurrStep := 0;
  if Power = 0 then Snow.MaxStep := Random( PowerRandom ) + 10
               else Snow.MaxStep := ShootLevels[ Power ];

  if Power < 5 then PlaySound( 'shoot2' )
               else PlaySound( 'shoot1' );
end;

function TBoy.IsDead: Boolean;
begin
  Result := Action = baDead;
end;

function TBoy.CanHitAction: Boolean;
begin
  Result := not( Action in [ baHit1, baHit2, baHit3, baDead ] );
end;

function TBoy.CanFocusAction: Boolean;
begin
  Result := not ( Action in [baHit1, baHit2, baHit3, baDelay, baDead] );
end;

function TBoy.CanMouseEvent: Boolean;
begin
  Result := not IsDead and CanFocusAction;
end;

function TBoy.IsHit(const SnowRect: TRect): Boolean;
function CheckPoint(X, Y: Integer): Boolean;
  var
    L: Integer;
  begin
    Result := False;
    if ( Y < Top + Height ) and ( Y >= Top + Height - BoyHitAreaHeight ) then
     begin
       L := ( Y - (Top + Height - BoyHitAreaHeight ) ) * 2;
       if ( X >= Left + L ) and ( X < Left + L + BoyHitAreaWidth ) then
        Result := True;
     end;
{
1  z
2  z
3  z
4  z
5  z x   Top = 5
6    x
7    x
8    x
9    x
10   vv   Y = 10
11     vv
12       vv
13         vv
14           vv
               vv
                 vv
                   vv
                     vv
                       vv Height = 15

             Top + Height = 20 }
  end;
begin
  Result := CheckPoint( SnowRect.Left, SnowRect.Top ) or
            CheckPoint( SnowRect.Right, SnowRect.Bottom ) or
            CheckPoint( SnowRect.Right, SnowRect.Top ) or
            CheckPoint( SnowRect.Left, SnowRect.Bottom );
end;

function TBoy.IsLive: Boolean;
begin
  Result := FAction <> baDead;
end;

{ TSnow }

procedure TSnow.DrawShadow(const Canvas: TCanvas);
begin
  DrawBitmap( Canvas, Left, ShadowTop, FOwner.GetSnowImage( Action, CurrStep, True ) );
end;

procedure TSnow.Draw(const Canvas: TCanvas);
begin
  DrawBitmap( Canvas, Left, Top, FOwner.GetSnowImage( Action, CurrStep, False ) );
end;

procedure TSnow.ProcessStep;
begin
  Inc( FCurrStep );

  case FTeam of
  tmTeam2: case Action of
           saShoot : begin
                       if CurrStep = 0 then
                        begin
                          if MaxStep > 10 then Sound( 'shoot1' )
                                          else Sound( 'shoot2' );
                        end;

                       Left := Left + SnowHoriSpeed;
                       Top := Top + SnowVertSpeed;
                       ShadowTop := ShadowTop + SnowVertSpeed;
                       if CurrStep >= MaxStep then
                        SetNextAction;
                     end;
           saDown  : case CurrStep of
                     0: begin
                          IncLeft( 10 );
                          IncTop( 5 );
                          Inc( FShadowTop, 5 );
                        end;
                     1: begin
                          IncLeft( 10 );
                          IncTop( 8 );
                          Inc( FShadowTop, 5 );
                        end;
                     2: begin
                          IncLeft( 10 );
                          IncTop( 10 );
                          Inc( FShadowTop, 5 );
                        end;
                     3: begin
                          IncLeft( 10 );
                          IncTop( 13 );
                          Inc( FShadowTop, 5 );
                        end;
                     4: begin
                          IncLeft( 15 );
                          IncTop( 15 );
                          Top := ShadowTop;
                        end;
                     5: begin
                          //IsOut := True;
                          SetNextAction;
                        end;
                     end;
           saDead  : if CurrStep >= MaxStep then IsOut := True;
           end;
  tmTeam1: case Action of
           saShoot : begin
                       Dec( FLeft, SnowHoriSpeed );
                       Dec( FTop, SnowVertSpeed );
                       Dec( FShadowTop, SnowVertSpeed );
                       if CurrStep >= MaxStep then
                        SetNextAction;
                     end;
           saDown  : case CurrStep of
                     0: begin
                          DecLeft( 10 );
                          DecTop( 2 );
                          Dec( FShadowTop, 5 );
                        end;
                     1: begin
                          DecLeft( 10 );
                          DecTop( 0 );
                          Dec( FShadowTop, 5 );
                        end;
                     2: begin
                          DecLeft( 10 );
                          IncTop( 1 );
                          Dec( FShadowTop, 5 );
                        end;
                     3: begin
                          DecLeft( 10 );
                          IncTop( 0 );
                          Dec( FShadowTop, 5 );
                        end;
                     4: begin
                          DecLeft( 15 );
                          Dec( FShadowTop, 10 );
                          Top := ShadowTop;
                        end;
                     5: begin
                          //IsOut := True;
                          SetNextAction;
                        end;
                     end;

           saDead  : if CurrStep >= MaxStep then IsOut := True;
           end;
  end;
end;

procedure TSnow.SetHitAction;
begin
  Action := saDead;
  MaxStep := SnowDeadMax;
  CurrStep := 0;
end;

procedure TSnow.SetNextAction;
begin
  case Action of
  saShoot : begin
              Action := saDown;
              CurrStep := 0;
              MaxStep := SnowShootMax;
            end;
  saDown  : begin
              Action := saDead;
              CurrStep := 0;
              MaxStep := SnowDeadMax;
            end;
  end;
end;

function TSnow.ShadowBounds: TRect;
begin
  Result := Rect( Left, ShadowTop, Left + Width, ShadowTop + Height );
end;

{ TBunker }

procedure TBunker.DrawShadow(const Canvas: TCanvas);
begin
end;

procedure TBunker.Draw(const Canvas: TCanvas);
begin
  DrawBitmap( Canvas, Left, Top, FOwner.GetBunkerImage( Team, Action, FHitCount ) );
end;

procedure TBunker.ProcessStep;
begin
end;

procedure TBunker.SetHitAction;
begin
  Inc( FHitCount );

  if FHitCount = BunkerDown then
   begin
     Action := kaDead;
     CurrStep := 0;
     MaxStep := 3;
   end;
end;

procedure TBunker.SetNextAction;
begin
//  case Action of
//  kaDown  : begin
//              Action := kaDead;
//              CurrStep := 0;
//            end;
//  end;
end;

function TBunker.CheckPoint(X, Y: Integer): Boolean;
begin
  Result := False;
  if ( X < Left + 28 + ( ( Y - Top ) * 2 ) ) and
     ( X > Left - 52 + ( ( Y - Top ) * 2 ) ) and
     ( Y > Top + ( ( Left + 90 - X ) div 2 ) ) and
     ( Y < Top + ( ( Left + 122 - X ) div 2 ) ) then
   Result := True;
end;

function TBunker.IsHit(const SnowRect: TRect): Boolean;
begin
  Result := ( Action = kaNormal ) and
            ( CheckPoint( SnowRect.Left, SnowRect.Top ) or
              CheckPoint( SnowRect.Right, SnowRect.Bottom ) or
              CheckPoint( SnowRect.Right, SnowRect.Top ) or
              CheckPoint( SnowRect.Left, SnowRect.Bottom ) );
end;

{ TCharacterList }

constructor TCharacterList.Create(AOwner: TCharacterCollection; ItemClass: TCollectionItemClass; ATeam: TTeam);
begin
  inherited Create( ItemClass );

  FOwner := AOwner;
  FTeam := ATeam;
end;

function TCharacterList.IndexOf(const Character: TCharacter): Integer;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
   if Items[i] = Character then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

function TCharacterList.LiveCount: Integer;
var
  i: Integer;
begin
  Result := 0;

  for i := 0 to Count - 1 do
   if Characters[i].IsLive then
    Inc( Result );
end;

procedure TCharacterList.MoveToFirst(Index: Integer);
begin
  Characters[ Index ].Index := 0;
end;

procedure TCharacterList.Added(var Item: TCollectionItem);
begin
  TCharacter(Item).FOwner := FOwner;
  TCharacter(Item).FTeam := FTeam;
end;

function TCharacterList.GetCharacters(Index: Integer): TCharacter;
begin
  Result := TCharacter( Items[ Index ] );
end;

{ TCharacterCollection }

constructor TCharacterCollection.Create(const PaintBox: TPaintBox);
begin
  inherited Create;

  FMediaPlayer := TMediaPlayer.Create( nil );

  FPaintBox := PaintBox;
  FCanvasWidth := Trunc(PaintBox.Width);
  FCanvasHeight := Trunc(PaintBox.Height);

  FTimer := TTimer.Create( nil );
  FTimer.Enabled := False;
  FTimer.Interval := TimerInterval;
  FTimer.OnTimer := OnTimer;

  FGameAction := gaReady;
  FCurrStep := 0;
  FMaxStep := IntroInterval;
  FStage := 1;

  Randomize;

  FYouBoyList := TCharacterList.Create( Self, TBoy, tmTeam2 );
  FYouSnowList := TCharacterList.Create( Self, TSnow, tmTeam2 );
  FYouBunkerList := TCharacterList.Create( Self, TBunker, tmTeam2 );
  FMeBoyList := TCharacterList.Create( Self, TBoy, tmTeam1 );
  FMeSnowList := TCharacterList.Create( Self, TSnow, tmTeam1 );
  FMeBunkerList := TCharacterList.Create( Self, TBunker, tmTeam1 );
end;

destructor TCharacterCollection.Destroy;
begin
  FTimer.Enabled := False;

  FYouBoyList.Free;
  FYouSnowList.Free;
  FYouBunkerList.Free;
  FMeBoyList.Free;
  FMeSnowList.Free;
  FMeBunkerList.Free;
  FMediaPlayer.Free;

  inherited Destroy;
end;

procedure TCharacterCollection.Draw(const Canvas: TCanvas);
procedure PaintBackground;
  var
    W, H: Integer;
    Rect: TRectF;
    Bitmap: TBitmap;
  begin
    W := FCanvasWidth;
    H := FCanvasHeight;

    Rect.Left := 0;
    Rect.Top := 0;
    Rect.Width := W;
    Rect.Height := H;

    Canvas.Fill.Color := TAlphaColorRec.White;
    Canvas.FillRect( Rect, 1, 1, [], 1 );

    Bitmap := GetImage( itBack1 );
    DrawBitmap( Canvas, 0, 0, Bitmap  );

    Bitmap := GetImage( itBack4 );
    DrawBitmap( Canvas, W - Bitmap.Width, H - Bitmap.Height, Bitmap );
  end;
begin
  Canvas.BeginScene;
  try

    PaintBackground;

    case GameAction of
         gaReady: DrawReady( Canvas );
    gaStageIntro: DrawStageIntro( Canvas );
    gaStageStart,
      gaGameOver: DrawStageStart( Canvas );
     gaStageOver: DrawStageOver( Canvas );
    end;

    if GameAction = gaGameOver then
     begin
       ShowTextCenter( Canvas, 'Game Over'#13#10#13#10'마지막판을 다시 하려면 터치!' );
     end;

  finally
    Canvas.EndScene;
  end;
end;

procedure TCharacterCollection.DrawStageIntro(const Canvas: TCanvas);
begin
  ShowTextCenter( Canvas, 'Stage ' + IntToStr( FStage ) );
end;

procedure TCharacterCollection.DrawStageOver(const Canvas: TCanvas);
begin
  ShowTextCenter( Canvas, '참 잘했어요~' );
end;

procedure TCharacterCollection.DrawStageStart(const Canvas: TCanvas);
procedure DrawFocus;
  begin
    if FFocusBoy <> nil then
     DrawBitmap( Canvas, FFocusBoy.Left + FocusLeft, FFocusBoy.Top + FocusTop, GetImage( itFocus ) );
  end;
procedure DrawPowerLevel;
  begin
    if FFocusBoy <> nil then
     DrawBitmap( Canvas, FFocusBoy.Left + PowerLevelLeft, FFocusBoy.Top + PowerLevelTop, GetBoyPowerLevelImage( FFocusBoy.FPowerLevel ) );
  end;
procedure DrawStageInfo;
  var
    W: Single;
  begin
    Canvas.Font.Size := MsgFontSize;
    Canvas.Font.Style := MsgFontStyle;

    W := Canvas.TextWidth( 'Stage ' );
    ShowText( Canvas, 'Stage ' + IntToStr( FStage ), 50 - W, 10, MsgFontColor );

    W := Canvas.TextWidth( 'Green ' );
    ShowText( Canvas, 'Green ' + IntToStr( FYouBoyList.LiveCount ), 50 - W, 30, TAlphaColorRec.Green );

    W := Canvas.TextWidth( 'Red ' );
    ShowText( Canvas, 'Red ' + IntToStr( FMeBoyList.LiveCount ), 50 - W, 50, TAlphaColorRec.Red );
  end;
begin
  DrawShadows( Canvas, YouBoyList );
  DrawShadows( Canvas, MeBoyList );
  DrawShadows( Canvas, YouSnowList );
  DrawShadows( Canvas, MeSnowList );

  DrawFocus;

  DrawCharacters( Canvas, YouBunkerList );
  DrawCharacters( Canvas, MeBunkerList );
  DrawCharacters( Canvas, YouBoyList );
  DrawCharacters( Canvas, MeBoyList );
  DrawCharacters( Canvas, YouSnowList );
  DrawCharacters( Canvas, MeSnowList );

  DrawPowerLevel;

  DrawStageInfo;
end;

procedure TCharacterCollection.DrawReady(const Canvas: TCanvas);
var
  Graphic: TBitmap;
begin
  Graphic := GetSystemImage( siLogo );
  DrawBitmap( Canvas, ( FCanvasWidth - Graphic.Width ) div 2, ( FCanvasHeight - Graphic.Height ) div 2, Graphic );
end;

procedure TCharacterCollection.StartGame;
begin
  FActive := True;

  FTimer.Enabled := True;
end;

procedure TCharacterCollection.StopGame;
begin
  FActive := False;
  FTimer.Enabled := False;
end;

procedure TCharacterCollection.Pause;
begin
  FTimer.Enabled := False;
end;

procedure TCharacterCollection.Restart;
begin
  if FActive then
   FTimer.Enabled := True;
end;

procedure TCharacterCollection.SetStageIntro;
begin
  FGameAction := gaStageIntro;
  FCurrStep := 0;
  FMaxStep := StageIntroMax;
end;

procedure TCharacterCollection.SetStageStart(Stage: Integer);
begin
  FGameAction := gaStageStart;
  CharactersClear;
  if FStage < StageCount then LoadStageData( Stage )
                         else LoadStageData( StageCount );
end;

procedure TCharacterCollection.SetStageOver;
begin
  if FStage < StageCount then
   begin
     FGameAction := gaStageOver;
     FCurrStep := 0;
     FMaxStep := StageOverMax;
   end
  else
   begin
     SetGameOver;
   end;
end;

procedure TCharacterCollection.SetGameOver;
begin
  if FGameAction <> gaGameOver then
   begin
     Sound( 'gameover' );
     FGameAction := gaGameOver;
   end;
end;

procedure TCharacterCollection.CharactersClear;
begin
  YouBoyList.Clear;
  YouSnowList.Clear;
  YouBunkerList.Clear;
  MeBoyList.Clear;
  MeSnowList.Clear;
  MeBunkerList.Clear;
end;

procedure TCharacterCollection.LoadStageData(AStage: Integer);
var
  X, Y, i: Integer;
procedure NewBoy( Team: TTeam; CharacterList: TCharacterList; ALeft, ATop: Integer );
  var
    ABoy: TBoy;
  begin
    ABoy := TBoy( CharacterList.Add );
    ABoy.Left := ALeft;
    ABoy.Top := ATop;
    ABoy.Width := GetBoyImage( Team, baPause, 0, False ).Width;
    ABoy.Height := GetBoyImage( Team, baPause, 0, False ).Height;
    ABoy.Action := baGoIn;
    ABoy.CurrStep := 0;
    ABoy.MaxStep := BoyGoIn div BoysMoveHigh;
  end;
procedure NewYouBoy(ALeft, ATop: Integer);
  begin
    NewBoy( tmTeam2, YouBoyList, ALeft - BoyGoIn, ATop - BoyGoIn );
  end;
procedure NewMeBoy(ALeft, ATop: Integer);
  begin
    NewBoy( tmTeam1, MeBoyList, ALeft + BoyGoIn, ATop + BoyGoIn );
  end;
procedure NewBunker(Team: TTeam; const CharacterList: TCharacterList; ALeft, ATop: Integer);
  var
    ABunker: TBunker;
  begin
    ABunker := TBunker( CharacterList.Add );
    ABunker.Action := kaNormal;
    ABunker.Left := ALeft;
    ABunker.Top := ATop;
    ABunker.Width := GetBunkerImage( Team, kaNormal, 0 ).Width;
    ABunker.Height := GetBunkerImage( Team, kaNormal, 0 ).Height;
  end;
procedure NewYouBunker(ALeft, ATop: Integer);
  begin
    NewBunker( tmTeam2, YouBunkerList, ALeft, ATop );
  end;
procedure NewMeBunker(ALeft, ATop: Integer);
  begin
    NewBunker( tmTeam1, MeBunkerList, ALeft, ATop );
  end;
function CheckData(Index: Integer): Boolean;
  begin
     Result := Datas[ AStage ][ Index ] > 0;
     if Result  then
      begin
        X := Round( ( Datas[ AStage ][ Index ] div 10000 ) / DataOrgWidth * FCanvasWidth );
        Y := Round( ( Datas[ AStage ][ Index ] mod 10000 ) / DataOrgHeight * FCanvasHeight );
      end;
  end;
begin
  for i := Boy2Min to Boy2Max do
   if CheckData( i ) then
    NewYouBoy( X, Y );

  for i := Boy1Min to Boy1Max do
   if CheckData( i ) then
     NewMeBoy( X, Y );

  for i := Bunker2Min to Bunker2Max do
   if CheckData( i ) then
     NewYouBunker( X, Y );

  for i := Bunker1Min to Bunker1Max do
   if CheckData( i ) then
     NewMeBunker( X, Y );
end;

procedure TCharacterCollection.ShowTextCenter(const Canvas: TCanvas; const Text: String);
var
  Rect: TRectF;
begin
  Rect.Left := 0;
  Rect.Top := 0;
  Rect.Width := FCanvasWidth;
  Rect.Height := FCanvasHeight;
  Canvas.Font.Size := MsgFontSize;
  Canvas.Font.Style := MsgFontStyle;

  Canvas.Fill.Color := MsgFontColor;
  Canvas.Fill.Kind := TBrushKind.bkNone;
  Canvas.FillText( Rect, Text, True, 1, [], TTextAlign.taCenter );
end;

procedure TCharacterCollection.Sound(const ResName: String);
var
  FileName, TempFile: String;
  ResStream: TResourceStream;
begin
  FileName := ResName + '_tmp.mp3';
  TempFile := TPath.Combine( TPath.GetTempPath, FileName );

  if not FileExists( TempFile ) then
   begin
     ResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
     try
       ResStream.SaveToFile( TempFile );
     finally
       ResStream.Free;
     end;
   end;

  FMediaPlayer.Stop;
  FMediaPlayer.Clear;
  FMediaPlayer.FileName := TempFile;
  FMediaPlayer.Play;
end;

procedure TCharacterCollection.ShowText(const Canvas: TCanvas; const Text: String; X, Y: Single; Color: TAlphaColor);
var
  Rect: TRectF;
begin
  Rect.Left := X;
  Rect.Top := Y;
  Rect.Right := FCanvasWidth;
  Rect.Bottom := FCanvasHeight;
  Canvas.Font.Size := MsgFontSize;
  Canvas.Font.Style := MsgFontStyle;

  Canvas.Fill.Color := Color;
  Canvas.Fill.Kind := TBrushKind.bkNone;
  Canvas.FillText( Rect, Text, True, 1, [], TTextAlign.taLeading, TTextAlign.taLeading );
end;

procedure TCharacterCollection.MouseDown(X, Y: Integer; IsLeft: Boolean = True);
var
  Bunker: TBunker;
  FocusBoy: TBoy;
begin
  if not FTimer.Enabled then Exit;

  case GameAction of
       gaReady: begin
                  Sound( 'newstage' );
                  SetStageIntro;
                end;
    gaGameOver: begin
                  SetStageIntro;
                end;
  gaStageStart: begin
                  FMouseLeft := IsLeft;
                  FocusBoy := GetMousePosBoy( MeBoyList, X, Y, True );
                  if ( FocusBoy <> nil ) and FocusBoy.CanMouseEvent then
                   begin
                     FFocusBoy := FocusBoy;

                     if IsLeft then
                      begin
                        FMouseDownPoint := GetMouseDownPoint( FFocusBoy, X, Y );
                        FFocusBoy.Action := baMouseDown;
                        FFocusBoy.FMaxStep := 0;
                        FFocusBoy.FCurrStep := 0;
                        FMouseDown := True;
                      end
                     else
                      begin
                        Bunker := BunkerFromRect( FFocusBoy.Team, FFocusBoy.Bounds );
                        if Bunker <> nil then
                         begin
                           FFocusBoy.FMakeBunker := Bunker;
                           FFocusBoy.Action := baMakeBunker;
                           FFocusBoy.MaxStep := -1;
                           FFocusBoy := nil;
                         end;
                      end;
                   end
                  else
                  if FFocusBoy <> nil then
                   begin
                     FMouseDownPoint := GetMouseDownPoint( FFocusBoy, X, Y );
                   end;


                  if FFocusBoy <> nil then
                   begin
                     FFocusBoy.Action := baMouseDown;
                     FFocusBoy.FMaxStep := 0;
                     FFocusBoy.FCurrStep := 0;
                     FFocusBoy.FPowerLevel := 0;
                     FMouseDown := True;
                   end;
                end;
  end;
end;

procedure TCharacterCollection.MouseMove(X, Y: Integer);
var
  P: Integer;
begin
  P := Round( FCanvasWidth - ( FCanvasWidth * ( Y / FCanvasHeight ) ) );
  if X < P then X := X + ( P - X ) div 2;

  P := Round( FCanvasHeight - ( FCanvasHeight * ( X / FCanvasWidth ) ) );
  if Y < P then Y := Y + ( P - Y ) div 2;

  if GameAction = gaStageStart then
   begin
     if FMouseDown and ( FFocusBoy <> nil ) and ( FFocusBoy.Action <> baMakeBunker ) then
      begin
        if FFocusBoy.CanFocusAction then
         MoveBoyToMousePoint( FFocusBoy, FMouseDownPoint, X, Y, FCanvasWidth, FCanvasHeight );
      end
{     else
      begin
        FFocusBoy := GetMousePosBoy( MeBoyList, X, Y, False );
      end;}
   end;
end;

procedure TCharacterCollection.MouseUp(X, Y: Integer);
begin
  if GameAction = gaStageStart then
   begin
     if ( FFocusBoy <> nil ) and FFocusBoy.CanMouseEvent then
      begin
        FFocusBoy.ShootSnow( FFocusBoy.FPowerLevel + 1 );
        FFocusBoy.Action := baMouseUp;
        FFocusBoy.FMaxStep := BoyMouseUpMax;
        FFocusBoy.FCurrStep := BoyMouseUpDefStep;
        FFocusBoy.FPowerLevel := 0;
        FMouseDown := False;
      end;
   end;
end;

function TCharacterCollection.BunkerFromRect(Team: TTeam; const ARect: TRect): TBunker;
var
  i: Integer;
  CharacterList : TCharacterList;
function CheckRect( Bunker: TBunker ): Boolean;
  begin
    Result := Bunker.CheckPoint( ARect.Left, ARect.Top ) or
              Bunker.CheckPoint( ARect.Right, ARect.Top ) or
              Bunker.CheckPoint( ARect.Left, ARect.Bottom ) or
              Bunker.CheckPoint( ARect.Right, ARect.Bottom ) or
              Bunker.CheckPoint( ARect.Left + ( ( ARect.Right - ARect.Left ) div 2 ), ARect.Top + ( ( ARect.Bottom - ARect.Top ) div 2 ) );
  end;
begin
  Result := nil;
  case Team of
  tmTeam1: CharacterList := FMeBunkerList;
     else  CharacterList := FYouBunkerList;
  end;

  if CharacterList.Count > 0 then
   for i := CharacterList.Count - 1 downto 0 do
    if CheckRect( TBunker( CharacterList[ i ] ) ) then
     begin
       Result := TBunker( CharacterList[ i ] );
       Break;
     end;
end;

function TCharacterCollection.GetBoyImage(Team: TTeam; BoyAction: TBoyAction; Step: Integer; IsShadow: Boolean): TBitmap;
begin
  Result := nil;

  if IsShadow then
   begin

     case Team of
     tmTeam1: Result := Image_MeShadow;
     else     Result := Image_YouShadow;
     end;

   end
  else

  case Team of
  tmTeam1: case BoyAction of
           baPause    : Result := Image_MeStop;

           baGoIn,
           baMove     : case Step mod 2 of
                        0: Result := Image_MeMove1;
                        1: Result := Image_MeMove2;
                        else Result := nil;
                        end;

           baMouseUp,
           baShootSnow: case Step of
                        0..4: Result := Image_MeShoot1;
                        5..9: Result := Image_MeShoot2;
                        else  Result := Image_MeShoot3;
                        end;

           baHit1     : Result := Image_MeHit;

           baDelay    : case Step mod 2 of
                        0: Result := Image_MeDelay1;
                        1: Result := Image_MeDelay2;
                        end;

           baHit2     : case Step of
                        0..2: Result := Image_MeHit;
                        else  Result := Image_MeDown;
                        end;

           baHit3     : case Step of
                        0:   Result := Image_MeDown;
                        else Result := Image_MeDead;
                        end;
           baDead     : Result := Image_MeDead;

           baFocused  : Result := Image_MeStop;
           baMouseDown: Result := Image_MeShoot2;
           end;

  tmTeam2: case BoyAction of
           baPause    : Result := Image_YouStop;

           baGoIn,
           baMove     : case Step mod 2 of
                        0: Result := Image_YouMove1;
                        1: Result := Image_YouMove2;
                        else Result := nil;
                        end;

           baShootSnow: case Step of
                        0..4: Result := Image_YouShoot1;
                        5..9: Result := Image_YouShoot2;
                        else  Result := Image_YouShoot3;
                        end;

           baHit1     : Result := Image_YouHit;

           baDelay    : case Step mod 4 of
                        0..1: Result := Image_YouDelay1;
                        2..3: Result := Image_YouDelay2;
                        end;

           baHit2     : case Step of
                        0..2: Result := Image_YouHit;
                        else  Result := Image_YouDown;
                        end;

           baHit3     : case Step of
                        0: Result := Image_YouDown;
                        else Result := Image_YouDead2;
                        end;

           baDead     : Result := Image_YouDead1;
           end;
  end;
end;

function TCharacterCollection.GetBoyPowerLevelImage(Level: Integer): TBitmap;
begin
 case Level of
   0: Result := Image_Power1;
   1: Result := Image_Power2;
   2: Result := Image_Power3;
   3: Result := Image_Power4;
   4: Result := Image_Power5;
   5: Result := Image_Power6;
   6: Result := Image_Power7;
   7: Result := Image_Power8;
   8: Result := Image_Power9;
   9: Result := Image_Power10;
 else Result := nil;
 end;
end;

function TCharacterCollection.GetBunkerImage(Team: TTeam; BunkerAction: TBunkerAction; Step: Integer): TBitmap;
begin
  Result := nil;
  case Team of
  tmTeam1: case BunkerAction of
           kaNormal: case Step of
           0..2: Result := Image_BunkerMe1;
           3..5: Result := Image_BunkerMe2;
           6..8: Result := Image_BunkerMe3;
            else Result := Image_BunkerMe4;
           end;
           kaDead  : Result := Image_BunkerMe4;
           end;
  tmTeam2: case BunkerAction of
           kaNormal: case Step of
           0..2: Result := Image_BunkerYou1;
           3..5: Result := Image_BunkerYou2;
           6..8: Result := Image_BunkerYou3;
            else Result := Image_BunkerYou4;
           end;
           kaDead  : Result := Image_BunkerYou4;
           end;
  end;
end;

function TCharacterCollection.GetImage(ImageType: TImageType): TBitmap;
begin
  Result := nil;
  case ImageType of
   itBack1: Result := Image_Back1;
   itBack4: Result := Image_Back4;
   itFocus: Result := Image_Focus;
  end;
end;

function TCharacterCollection.GetSnowImage(SnowAction: TSnowAction; Step: Integer; IsShadow: Boolean): TBitmap;
begin
  Result := nil;

  case SnowAction of
  saShoot: if IsShadow then Result := Image_SnowShadow
                       else Result := Image_Snow;
  saDown : if IsShadow then Result := Image_SnowShadow
                       else Result := Image_Snow;
  saDead : case Step of
           0..2: if IsShadow then Result := Image_SnowDead1
                             else Result := nil;
            else if IsShadow then Result := Image_SnowDead2
                             else Result := nil;
           end;
  end;
end;

function TCharacterCollection.GetSystemImage(SysImageType: TSysImageType): TBitmap;
begin
  case SysImageType of
  siLogo : Result := Image_Logo;
  else     Result := nil;
  end;
end;

procedure TCharacterCollection.OnTimer(Sender: TObject);
begin
  if Active then
   begin
     case GameAction of
          gaReady: begin
                     Sound( 'newstage' );
                     SetStageIntro;
                     FMaxStep := StageIntroMax;
                   end;
     gaStageIntro: begin
                     ProcessStageIntro;
                   end;
     gaStageStart,
       gaGameOver: begin
                     ProcessStageStart;
                   end;
      gaStageOver: ProcessStageOver;
     end;

    FPaintBox.Repaint;
   end;
end;

procedure TCharacterCollection.SetNextAction;
begin
  case GameAction of
  gaReady,
  gaStageIntro : begin
                   Sound( 'start' );
                   SetStageStart( FStage );
                 end;
   gaStageOver : begin
                   Inc( FStage );
                   Sound( 'newstage' );
                   SetStageIntro;
                 end;
  end;
end;

procedure TCharacterCollection.ProcessStageIntro;
begin
  Inc( FCurrStep );
  if FCurrStep >= FMaxStep then
   SetNextAction;
end;


procedure TCharacterCollection.ProcessStageStart;

procedure PowerLevelCalc;
  begin
    if ( FFocusBoy <> nil ) and ( FFocusBoy.Action = baMouseDown ) then
     with FFocusBoy do
      begin
        FPowerLevel := Trunc( CurrStep * 1.5 ) - 1;
        if FPowerLevel < 0 then FPowerLevel := 0 else
        if FPowerLevel > ShootLevelCount - 1 then FPowerLevel := ShootLevelCount - 1;
      end;
  end;
function GetExistsLibBoy( BoyList: TCharacterList ): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    if BoyList.Count > 0 then
     for i := 0 to BoyList.Count - 1 do
      if not TBoy( BoyList[ i ] ).IsDead then
       begin
         Result := True;
         Break;
       end;
  end;
procedure CheckStageOver;
  begin
    if not GetExistsLibBoy( YouBoyList ) then SetStageOver else
    if not GetExistsLibBoy( MeBoyList ) then SetGameOver;
  end;
begin
  HitChecking( MeBunkerList, YouSnowList );
  HitChecking( YouBunkerList, MeSnowList );
  HitChecking( MeBoyList, YouSnowList );
  HitChecking( YouBoyList, MeSnowList );

  FToggleBoyAction := not FToggleBoyAction;
  if FToggleBoyAction then
   begin
     CharacterProcessStep( YouBoyList );
     CharacterProcessStep( MeBoyList );
   end;

  CharacterProcessStep( YouSnowList );
  CharacterProcessStep( MeSnowList );
  CharacterProcessStep( YouBunkerList );
  CharacterProcessStep( MeBunkerList );

  PowerLevelCalc;

  DeleteOutedCharacters( YouSnowList );
  DeleteOutedCharacters( MeSnowList );

  CheckStageOver;
end;

procedure TCharacterCollection.ProcessStageOver;
begin
  if FCurrStep >= FMaxStep then SetNextAction
                           else Inc( FCurrStep );
end;

end.
