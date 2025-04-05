program multisample;
uses raylib;
const
    screenWidth: Integer = 800;
    screenHeight: Integer = 450;
var
    imRed, imBlue: TImage;
    texRed, texBlue: TTexture;
    shader: TShader;
    texBlueLoc, dividerLoc: Integer;
    dividerValue: Single;
begin
    InitWindow(screenWidth, screenHeight, 'raylib - multiple sample2D');

    imRed := GenImageColor(800, 450, Color(255, 0, 0, 255));
    texRed := LoadTextureFromImage(imRed);
    UnloadImage(imRed);

    imBlue := GenImageColor(800, 450, Color(0, 0, 255, 255));
    texBlue := LoadTextureFromImage(imBlue);
    UnloadImage(imBlue);

    shader := LoadShader(PChar(0), 'shaders/color_mix.fs');

    texBlueLoc := GetShaderLocation(shader, 'texture1');


    dividerLoc := GetShaderLocation(shader, 'divider');
    dividerValue := 0.5;

    SetTargetFPS(60);

    while not WindowShouldClose() do
    begin
        if IsKeyDown(Ord(KEY_RIGHT)) then
        begin
            dividerValue += 0.01;
        end
        else
            if IsKeyDown(Ord(KEY_LEFT)) then
                dividerValue -= 0.01;

        if dividerValue < 0.0 then
        begin
            dividerValue := 0.0;
        end
        else
            if dividerValue > 1.0 then
                dividerValue := 1.0;

        SetShaderValue(shader, dividerLoc, @dividerValue, Ord(SHADER_UNIFORM_FLOAT));

        BeginDrawing();
            ClearBackground(RAYWHITE);
            BeginShaderMode(shader);
                SetShaderValueTexture(shader, texBlueLoc, texBlue);
                DrawTexture(texRed, 0, 0, WHITE);
            EndShaderMode();

            DrawText('Use KEY_LEFT/KEY_RIGHT to move texture mixing in shader!', 80, GetScreenHeight() - 40, 20, RAYWHITE);
        EndDrawing();
    end;

    UnloadShader(shader);
    UnloadTexture(texRed);
    UnloadTexture(texBlue);

    CloseWindow();
end.