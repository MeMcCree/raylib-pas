program ray;
uses raylib;
const
    screenWidth: Integer = 800;
    screenHeight: Integer = 600;
    fontSize: Integer = 20;
    title: PChar = 'Example';
    hellotext: PChar = 'Hello world!';
var
    textWidth: Integer;
begin
    InitWindow(screenWidth, screenHeight, title);

    textWidth := MeasureText(hellotext, fontSize);
    while not WindowShouldClose() do
    begin
        BeginDrawing();
            ClearBackground(Color(255, 255, 255, 255));
            DrawText('Hello world!', screenWidth div 2 - textWidth div 2, screenHeight div 2, fontSize, Color(0, 0, 0, 255));
        EndDrawing();
    end;
    CloseWindow();
end.