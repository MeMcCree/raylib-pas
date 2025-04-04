program cam2dsystem;
uses raylib;
type
    COLUMN_IDX = 0..19;
const
    screenWidth: Integer = 800;
    screenHeight: Integer = 450;
var
    camera: TCamera;
    cameraMode: Integer;
    heights: Array[0..19] of Single;
    positions: Array[0..19] of TVector3;
    colors: Array[0..19] of TColor;
    i: Integer;
begin
    InitWindow(screenWidth, screenHeight, 'raylib [core] example - 3d camera first person');

    camera.position := Vector3(0.0, 2.0, 4.0);
    camera.target := Vector3(0.0, 2.0, 0.0);
    camera.up := Vector3(0.0, 1.0, 0.0);
    camera.fovy := 60.0;
    camera.projection := Ord(CAMERA_PERSPECTIVE);

    cameraMode := Ord(CAMERA_FIRST_PERSON);

    for i := Low(COLUMN_IDX) to High(COLUMN_IDX) do
    begin
        heights[i] := 1.0 * GetRandomValue(1, 12);
        positions[i] := Vector3(1.0 * GetRandomValue(-15, 15), heights[i]/2.0, 1.0 * GetRandomValue(-15, 15));
        colors[i] := Color(GetRandomValue(20, 255), GetRandomValue(10, 55), 30, 255);
    end;

    DisableCursor();
    SetTargetFPS(60);

    while not WindowShouldClose() do
    begin
        if IsKeyPressed(Ord(KEY_ONE)) then
        begin
            cameraMode := Ord(CAMERA_FREE);
            camera.up := Vector3(0.0, 1.0, 0.0);
        end;

        if IsKeyPressed(Ord(KEY_TWO)) then
        begin
            cameraMode := Ord(CAMERA_FIRST_PERSON);
            camera.up := Vector3(0.0, 1.0, 0.0);
        end;

        if IsKeyPressed(Ord(KEY_THREE)) then
        begin
            cameraMode := Ord(CAMERA_THIRD_PERSON);
            camera.up := Vector3(0.0, 1.0, 0.0);
        end;

        if IsKeyPressed(Ord(KEY_FOUR)) then
        begin
            cameraMode := Ord(CAMERA_ORBITAL);
            camera.up := Vector3(0.0, 1.0, 0.0);
        end;


        if IsKeyPressed(Ord(KEY_P)) then
        begin
            if camera.projection = Ord(CAMERA_PERSPECTIVE) then
            begin
                cameraMode := Ord(CAMERA_THIRD_PERSON);

                camera.position := Vector3(0.0, 2.0, -100.0);
                camera.target := Vector3(0.0, 2.0, 0.0);
                camera.up := Vector3(0.0, 1.0, 0.0);
                camera.projection := Ord(CAMERA_ORTHOGRAPHIC);
                camera.fovy := 20.0;
                CameraYaw(@camera, -135 * Pi / 180.0, true);
                CameraPitch(@camera, -45 * Pi / 180.0, true, true, false);
            end
            else 
                if camera.projection = Ord(CAMERA_ORTHOGRAPHIC) then
                begin
                    cameraMode := Ord(CAMERA_THIRD_PERSON);
                    camera.position := Vector3(0.0, 2.0, 10.0);
                    camera.target := Vector3(0.0, 2.0, 0.0);
                    camera.up := Vector3(0.0, 1.0, 0.0);
                    camera.projection := Ord(CAMERA_PERSPECTIVE);
                    camera.fovy := 60.0;
                end;
        end;

        UpdateCamera(@camera, cameraMode);

        BeginDrawing();
            ClearBackground(RAYWHITE);

            BeginMode3D(camera);
                DrawPlane(Vector3(0.0, 0.0, 0.0), Vector2(32.0, 32.0), LIGHTGRAY);
                DrawCube(Vector3(-16.0, 2.5, 0.0), 1.0, 5.0, 32.0, BLUE);
                DrawCube(Vector3(16.0, 2.5, 0.0), 1.0, 5.0, 32.0, LIME);
                DrawCube(Vector3(0.0, 2.5, 16.0), 32.0, 5.0, 1.0, GOLD);

                for i := Low(COLUMN_IDX) to High(COLUMN_IDX) do
                begin
                    DrawCube(positions[i], 2.0, heights[i], 2.0, colors[i]);
                    DrawCubeWires(positions[i], 2.0, heights[i], 2.0, MAROON);
                end;


                if cameraMode = Ord(CAMERA_THIRD_PERSON) then
                begin
                    DrawCube(camera.target, 0.5, 0.5, 0.5, PURPLE);
                    DrawCubeWires(camera.target, 0.5, 0.5, 0.5, DARKPURPLE);
                end;

            EndMode3D();

            DrawRectangle(5, 5, 330, 100, Fade(SKYBLUE, 0.5));
            DrawRectangleLines(5, 5, 330, 100, BLUE);

            DrawText('Camera controls:', 15, 15, 10, BLACK);
            DrawText('- Move keys: W, A, S, D, Space, Left-Ctrl', 15, 30, 10, BLACK);
            DrawText('- Look around: arrow keys or mouse', 15, 45, 10, BLACK);
            DrawText('- Camera mode keys: 1, 2, 3, 4', 15, 60, 10, BLACK);
            DrawText('- Zoom keys: num-plus, num-minus or mouse scroll', 15, 75, 10, BLACK);
            DrawText('- Camera projection key: P', 15, 90, 10, BLACK);

            DrawRectangle(600, 5, 195, 100, Fade(SKYBLUE, 0.5));
            DrawRectangleLines(600, 5, 195, 100, BLUE);

            DrawText('Camera status:', 610, 15, 10, BLACK);
            DrawText(TextFormat('- Position: (%06.3f, %06.3f, %06.3f)', camera.position.x, camera.position.y, camera.position.z), 610, 60, 10, BLACK);
            DrawText(TextFormat('- Target: (%06.3f, %06.3f, %06.3f)', camera.target.x, camera.target.y, camera.target.z), 610, 75, 10, BLACK);
            DrawText(TextFormat('- Up: (%06.3f, %06.3f, %06.3f)', camera.up.x, camera.up.y, camera.up.z), 610, 90, 10, BLACK);

        EndDrawing();
    end;

    CloseWindow();
end.