{$mode objfpc}{$H+}

unit raylib;
{$if defined(WINDOWS)}
    {$linklib raylib.dll}
{$elseif defined(UNIX)}
    {$linklib c}
    {$linklib m}
    {$linklib raylib}
{$endif}
interface
type
{$include raystructs.inc}
{$include rayenums.inc}

{$include rcore.inc}
{$include rshapes.inc}
{$include rtextures.inc}
{$include rtext.inc}
{$include rmodels.inc}
{$include raudio.inc}
{$include rmath.inc}
{$include rcamera.inc}

const
{$include rayconsts.inc}

function Color(r, g, b, a: Byte): TColor;
function Vector2(x, y: Single): TVector2;
function Vector3(x, y, z: Single): TVector3;
function Vector4(x, y, z, w: Single): TVector4;
function Rectangle(x, y, width, height: Single): TRectangle;

implementation
function Color(r, g, b, a: Byte): TColor;
begin
    result.r := r;
    result.g := g;
    result.b := b;
    result.a := a;
end;

function Vector2(x, y: Single): TVector2;
begin
    result.x := x;
    result.y := y;
end;

function Vector3(x, y, z: Single): TVector3;
begin
    result.x := x;
    result.y := y;
    result.z := z;
end;

function Vector4(x, y, z, w: Single): TVector4;
begin
    result.x := x;
    result.y := y;
    result.z := z;
    result.w := w;
end;

function Rectangle(x, y, width, height: Single): TRectangle;
begin
    result.x := x;
    result.y := y;
    result.width := width;
    result.height := height;
end;
end.