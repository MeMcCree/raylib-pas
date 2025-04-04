function GetCameraForward(camera: PTCamera): TVector3; cdecl; external;
function GetCameraUp(camera: PTCamera): TVector3; cdecl; external;
function GetCameraRight(camera: PTCamera): TVector3; cdecl; external;

procedure CameraMoveForward(camera: PTCamera; distance: Single; moveInWorldPlane: Boolean); cdecl; external;
procedure CameraMoveUp(camera: PTCamera; distance: Single); cdecl; external;
procedure CameraMoveRight(camera: PTCamera; distance: Single; moveInWorldPlane: Boolean); cdecl; external;
procedure CameraMoveToTarget(camera: PTCamera; delta: Single); cdecl; external;

procedure CameraYaw(camera: PTCamera; angle: Single; rotateAroundTarget: Boolean); cdecl; external;
procedure CameraPitch(camera: PTCamera; angle: Single; lockView, rotateAroundTarget, rotateUp: Boolean); cdecl; external;
procedure CameraRoll(camera: PTCamera; angle: Single); cdecl; external;

function GetCameraViewMatrix(camera: PTCamera): TMatrix; cdecl; external;
function GetCameraProjectionMatrix(camera: PTCamera; aspect: Single): TMatrix; cdecl; external;
