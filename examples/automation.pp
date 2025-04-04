{$mode objfpc}{$H+}

program automation;
uses raylib, Math;
type
TPlayer = record
    position: TVector2;
    speed: Single;
    canJump: Boolean;
end;

TEnvElement = record
    rect: TRectangle;
    blocking: Integer;
    color: TColor;
end;
PTEnvElement = ^TEnvElement;

function Player(position: TVector2; speed: Single; canJump: Boolean): TPlayer;
begin
    result.position := position;
    result.speed := speed;
    result.canJump := canJump;
end;

function EnvElement(rect: TRectangle; blocking: Integer; color: TColor): TEnvElement;
begin
    result.rect := rect;
    result.blocking := blocking;
    result.color := color;
end;

type
    ENVIRONMENT_ELEMENTS_IDX = 0..4;
const
    GRAVITY: Integer = 400;
    PLAYER_JUMP_SPD: Single = 350.0;
    PLAYER_HOR_SPD: Single = 200.0;
    screenWidth: Integer = 800;
    screenHeight: Integer = 450;
var
    ply: TPlayer;
    envElements: Array[ENVIRONMENT_ELEMENTS_IDX] of TEnvElement;
    camera: TCamera2D;
    aelist: TAutomationEventList;
    eventRecording, eventPlaying: Boolean;
    frameCounter: dWord;
    playFrameCounter: dWord;
    currentPlayFrame: dWord;
    deltaTime: Single;
    droppedFiles: TFilePathList;
    hitObstacle: Integer;
    i: Integer;
    element: PTEnvElement;
    p: PTVector2;
    minX, minY, maxX, maxY: Single;
    mn, mx: TVector2;
begin
    InitWindow(screenWidth, screenHeight, 'raylib [core] example - automation events');

    ply.position := Vector2(400, 280);
    ply.speed := 0;
    ply.canJump := false;
     
    envElements[0] := EnvElement(Rectangle(0, 0, 1000, 400), 0, LIGHTGRAY);
    envElements[1] := EnvElement(Rectangle(0, 400, 1000, 200), 1, GRAY);
    envElements[2] := EnvElement(Rectangle(300, 200, 400, 10), 1, GRAY);
    envElements[3] := EnvElement(Rectangle(250, 300, 100, 10), 1, GRAY);
    envElements[4] := EnvElement(Rectangle(650, 300, 100, 10), 1, GRAY);

    camera.target := ply.position;
    camera.offset := Vector2(screenWidth/2.0, screenHeight/2.0);
    camera.rotation := 0.0;
    camera.zoom := 1.0;

    aelist := LoadAutomationEventList(PChar(0));
    SetAutomationEventList(@aelist);
    eventRecording := false;
    eventPlaying := false;

    frameCounter := 0;
    playFrameCounter := 0;
    currentPlayFrame := 0;

    SetTargetFPS(60);

    while not WindowShouldClose() do
    begin
        deltaTime := 0.015;

        if IsFileDropped() then
        begin
            droppedFiles := LoadDroppedFiles();

            if IsFileExtension(droppedFiles.paths[0], '.txt;.rae') then
            begin
                UnloadAutomationEventList(aelist);
                aelist := LoadAutomationEventList(droppedFiles.paths[0]);

                eventRecording := false;
                eventPlaying := true;
                playFrameCounter := 0;
                currentPlayFrame := 0;

                ply.position := Vector2(400, 280);
                ply.speed := 0;
                ply.canJump := false;

                camera.target := ply.position;
                camera.offset := Vector2(screenWidth/2.0, screenHeight/2.0);
                camera.rotation := 0.0;
                camera.zoom := 1.0;
            end;

            UnloadDroppedFiles(droppedFiles);
        end;

        if IsKeyDown(Ord(KEY_LEFT)) then
            ply.position.x -= PLAYER_HOR_SPD*deltaTime;
        if IsKeyDown(Ord(KEY_RIGHT)) then
            ply.position.x += PLAYER_HOR_SPD*deltaTime;
        if IsKeyDown(Ord(KEY_SPACE)) and ply.canJump then
        begin
            ply.speed := -PLAYER_JUMP_SPD;
            ply.canJump := false;
        end;

        hitObstacle := 0;
        for i := Low(ENVIRONMENT_ELEMENTS_IDX) to High(ENVIRONMENT_ELEMENTS_IDX) do
        begin
            element := @envElements[i];
            p := @ply.position;
            if Boolean(element^.blocking) and
               (element^.rect.x <= p^.x) and
               ((element^.rect.x + element^.rect.width) >= p^.x) and
               (element^.rect.y >= p^.y) and
               (element^.rect.y <= (p^.y + ply.speed*deltaTime)) then
            begin
                hitObstacle := 1;
                ply.speed := 0.0;
                p^.y := element^.rect.y;
            end;
        end;

        if not Boolean(hitObstacle) then
        begin
            ply.position.y += ply.speed*deltaTime;
            ply.speed += GRAVITY*deltaTime;
            ply.canJump := false;
        end
        else
            ply.canJump := true;

        if IsKeyPressed(Ord(KEY_R)) then
        begin
            ply.position := Vector2(400, 280);
            ply.speed := 0;
            ply.canJump := false;

            camera.target := ply.position;
            camera.offset := Vector2(screenWidth/2.0, screenHeight/2.0);
            camera.rotation := 0.0;
            camera.zoom := 1.0;
        end;

        if eventPlaying then
        begin
            while playFrameCounter = aelist.events[currentPlayFrame].frame do
            begin
                PlayAutomationEvent(aelist.events[currentPlayFrame]);
                inc(currentPlayFrame);

                if currentPlayFrame = aelist.count then
                begin
                    eventPlaying := false;
                    currentPlayFrame := 0;
                    playFrameCounter := 0;

                    TraceLog(Ord(LOG_INFO), 'FINISH PLAYING!');
                    break;
                end;
            end;

            inc(playFrameCounter);
        end;

        camera.target := ply.position;
        camera.offset := Vector2(screenWidth/2.0, screenHeight/2.0);
        minX := 1000;
        minY := 1000;
        maxX := -1000;
        maxY := -1000;

        camera.zoom += (1.0 * GetMouseWheelMove() * 0.05);
        if camera.zoom > 3.0 then
        begin
            camera.zoom := 3.0;
        end
        else
            if camera.zoom < 0.25 then
                camera.zoom := 0.25;

        for i := Low(ENVIRONMENT_ELEMENTS_IDX) to High(ENVIRONMENT_ELEMENTS_IDX) do
        begin
            element := @envElements[i];
            minX := Min(element^.rect.x, minX);
            maxX := Max(element^.rect.x + element^.rect.width, maxX);
            minY := Min(element^.rect.y, minY);
            maxY := Max(element^.rect.y + element^.rect.height, maxY);
        end;

        mx := GetWorldToScreen2D(Vector2(maxX, maxY), camera);
        mn := GetWorldToScreen2D(Vector2(minX, minY), camera);

        if mx.x < screenWidth then
            camera.offset.x := screenWidth - (mx.x - screenWidth/2);
        if mx.y < screenHeight then
            camera.offset.y := screenHeight - (mx.y - screenHeight/2);
        if mn.x > 0 then
            camera.offset.x := screenWidth/2 - mn.x;
        if mn.y > 0 then
            camera.offset.y := screenHeight/2 - mn.y;

        if IsKeyPressed(Ord(KEY_S)) then
        begin
            if not eventPlaying then
            begin
                if eventRecording then
                begin
                    StopAutomationEventRecording();
                    eventRecording := false;

                    ExportAutomationEventList(aelist, 'automation.rae');

                    TraceLog(Ord(LOG_INFO), 'RECORDED FRAMES: %i', aelist.count);
                end
                else
                begin
                    SetAutomationEventBaseFrame(180);
                    StartAutomationEventRecording();
                    eventRecording := true;
                end;
            end;
        end
        else
            if IsKeyPressed(Ord(KEY_A)) then
            begin
                if not eventRecording and (aelist.count > 0) then
                begin
                    eventPlaying := true;
                    playFrameCounter := 0;
                    currentPlayFrame := 0;

                    ply.position := Vector2(400, 280);
                    ply.speed := 0;
                    ply.canJump := false;

                    camera.target := ply.position;
                    camera.offset := Vector2(screenWidth/2.0, screenHeight/2.0);
                    camera.rotation := 0.0;
                    camera.zoom := 1.0;
                end;
            end;

        if eventRecording or eventPlaying then
        begin
            inc(frameCounter);
        end
        else
            frameCounter := 0;

        BeginDrawing();
            ClearBackground(LIGHTGRAY);

            BeginMode2D(camera);
                for i := Low(ENVIRONMENT_ELEMENTS_IDX) to High(ENVIRONMENT_ELEMENTS_IDX) do
                    DrawRectangleRec(envElements[i].rect, envElements[i].color);
                DrawRectangleRec(Rectangle(ply.position.x - 20, ply.position.y - 40, 40, 40), RED);
            EndMode2D();

            DrawRectangle(10, 10, 290, 145, Fade(SKYBLUE, 0.5));
            DrawRectangleLines(10, 10, 290, 145, Fade(BLUE, 0.8));

            DrawText('Controls:', 20, 20, 10, BLACK);
            DrawText('- RIGHT | LEFT: Player movement', 30, 40, 10, DARKGRAY);
            DrawText('- SPACE: Player jump', 30, 60, 10, DARKGRAY);
            DrawText('- R: Reset game state', 30, 80, 10, DARKGRAY);

            DrawText('- S: START/STOP RECORDING INPUT EVENTS', 30, 110, 10, BLACK);
            DrawText('- A: REPLAY LAST RECORDED INPUT EVENTS', 30, 130, 10, BLACK);


            if eventRecording then
            begin
                DrawRectangle(10, 160, 290, 30, Fade(RED, 0.3));
                DrawRectangleLines(10, 160, 290, 30, Fade(MAROON, 0.8));
                DrawCircle(30, 175, 10, MAROON);

                if ((frameCounter div 15) mod 2) = 1 then
                    DrawText(TextFormat('RECORDING EVENTS... [%i]', aelist.count), 50, 170, 10, MAROON);
            end
            else
                if eventPlaying then
                begin
                    DrawRectangle(10, 160, 290, 30, Fade(LIME, 0.3));
                    DrawRectangleLines(10, 160, 290, 30, Fade(DARKGREEN, 0.8));
                    DrawTriangle(Vector2(20, 155 + 10), Vector2(20, 155 + 30), Vector2(40, 155 + 20), DARKGREEN);

                    if ((frameCounter div 15) mod 2) = 1 then
                        DrawText(TextFormat('PLAYING RECORDED EVENTS... [%i]', currentPlayFrame), 50, 170, 10, DARKGREEN);
                end;
        EndDrawing();
    end;

    CloseWindow();
end.