program cam2dsystem;
uses raylib;
const
    MAX_BUILDINGS: Integer = 100;
    screenWidth: Integer = 800;
    screenHeight: Integer = 450;
var
    player: TRectangle;
    buildings: Array[0..99] of TRectangle;
    buildColors: Array[0..99] of TColor;
    spacing, i: Integer;
    camera: TCamera2D;
begin
    InitWindow(screenWidth, screenHeight, 'raylib [core] example - 2d camera');

    player := Rectangle(400.0, 280.0, 40.0, 40.0);

    spacing := 0;

    for i := 0 to MAX_BUILDINGS-1 do
    begin
        buildings[i].width := 1.0 * GetRandomValue(50, 200);
        buildings[i].height := 1.0 * GetRandomValue(100, 800);
        buildings[i].y := screenHeight - 130.0 - buildings[i].height;
        buildings[i].x := -6000.0 + spacing;

        spacing += Trunc(buildings[i].width);

        buildColors[i] := Color(
            Byte(GetRandomValue(200, 240)),
            Byte(GetRandomValue(200, 240)),
            Byte(GetRandomValue(200, 250)),
            255);
    end;

    camera.target := Vector2(player.x + 20.0, player.y + 20.0);
    camera.offset := Vector2(screenWidth/2.0, screenHeight/2.0);
    camera.rotation := 0.0;
    camera.zoom := 1.0;

    SetTargetFPS(60);

    while not WindowShouldClose() do
    begin
        if IsKeyDown(Integer(KEY_RIGHT)) then
        begin
            player.x += 2;
        end
        else
            if IsKeyDown(Integer(KEY_LEFT)) then
                player.x -= 2;

        camera.target := Vector2(player.x + 20, player.y + 20);

        if IsKeyDown(Integer(KEY_A)) then
        begin
            camera.rotation -= 1;
        end
        else
            if IsKeyDown(Integer(KEY_S)) then 
                camera.rotation += 1;

        if camera.rotation > 40 then
        begin
            camera.rotation := 40;
        end
        else
            if camera.rotation < -40 then
                camera.rotation := -40;

        camera.zoom := Exp(Ln(camera.zoom) + (1.0 * GetMouseWheelMove() * 0.1));

        if camera.zoom > 3.0 then
        begin
            camera.zoom := 3.0;
        end
        else
            if camera.zoom < 0.1 then
                camera.zoom := 0.1;

        if IsKeyPressed(Integer(KEY_R)) then
        begin
            camera.zoom := 1.0;
            camera.rotation := 0.0;
        end;
        
        BeginDrawing();

            ClearBackground(RAYWHITE);

            BeginMode2D(camera);

                DrawRectangle(-6000, 320, 13000, 8000, DARKGRAY);

                for i := 0 to MAX_BUILDINGS-1 do
                    DrawRectangleRec(buildings[i], buildColors[i]);

                DrawRectangleRec(player, RED);

                DrawLine(Trunc(camera.target.x), -screenHeight*10, Trunc(camera.target.x), screenHeight*10, GREEN);
                DrawLine(-screenWidth*10, Trunc(camera.target.y), screenWidth*10, Trunc(camera.target.y), GREEN);

            EndMode2D();

            DrawText('SCREEN AREA', 640, 10, 20, RED);

            DrawRectangle(0, 0, screenWidth, 5, RED);
            DrawRectangle(0, 5, 5, screenHeight - 10, RED);
            DrawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, RED);
            DrawRectangle(0, screenHeight - 5, screenWidth, 5, RED);

            DrawRectangle( 10, 10, 250, 113, Fade(SKYBLUE, 0.5));
            DrawRectangleLines( 10, 10, 250, 113, BLUE);

            DrawText('Free 2d camera controls:', 20, 20, 10, BLACK);
            DrawText('- Right/Left to move Offset', 40, 40, 10, DARKGRAY);
            DrawText('- Mouse Wheel to Zoom in-out', 40, 60, 10, DARKGRAY);
            DrawText('- A / S to Rotate', 40, 80, 10, DARKGRAY);
            DrawText('- R to reset Zoom and Rotation', 40, 100, 10, DARKGRAY);

        EndDrawing();
    end;

    CloseWindow();
end.