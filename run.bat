@echo off
cls

:start
set /p operation= Seleziona l'operazione (cifra/decifra): 
if %operation% NEQ cifra if %operation% NEQ decifra (goto start)
if %operation% EQU decifra (goto d0)


:file
echo Sposta il video da cifrare all'interno della cartella "VCHoxha".
set /p filename= Inserisci il nome del video da cifrare (esempio: video.mp4): 
if "%filename%"=="" (goto file)
if not exist ./VCHoxha/%filename% (
	echo File video non trovato. 
	goto file
)
goto encodingChoice

:d0
echo Sposta le due share (e l'eventuale traccia audio) all'interno della cartella "VCHoxha".
set /p filed0= Inserisci il nome della prima share da decifrare (esempio: share1.mp4): 
if "%filed0%"=="" (goto d0)
if not exist ./VCHoxha/%filed0% (
echo Share non trovata. 
goto d0
)

:d1
set /p filed1= Inserisci il nome della seconda share da decifrare (esempio: share2.mp4): 
if "%filed1%"=="" (goto d1)
if not exist ./VCHoxha/%filed1% (
echo Share non trovata. 
goto d1
)

:audio
set /p fileaudio=Inserisci il nome della traccia audio (esempio: audio.aac). Premi invio per saltare: 

:: Se l'utente preme Invio, setta il valore di fileaudio a "none"
if "%fileaudio%"=="" (
    set fileaudio=none
)

:: Controlla solo se il valore non è "none"
if /i not "%fileaudio%"=="none" if not exist ./VCHoxha/%fileaudio% (
    echo Il file %fileaudio% non esiste. Riprova.
    goto audio
)

:encodingChoice
set /p encodingType= Inserisci la tipologia di encoding/decoding da applicare (lossy/lossless): 
if "%encodingType%"=="" (goto encodingChoice)
if %encodingType% NEQ lossless if %encodingType% NEQ lossy (goto encodingChoice)
REM if %encodingType% EQU lossless (goto nextStep)

:codecChoice
if "%encodingType%"=="lossy" (
echo Codec lossy disponibili: OpenH264, x264, x265, VP8, VP9
set /p codec= Scegli uno dei codec disponibili in modalita lossy:

    if /I %codec% EQU x264 goto crfparam
    if /I %codec% EQU OpenH264 goto crfparam
    if /I %codec% EQU x265 goto crfparam
    if /I %codec% EQU VP8 goto crfparam
    if /I %codec% EQU VP9 goto crfparam

    echo Codec non valido. Riprova. 
    goto codecChoice
) else if "%encodingType%"=="lossless" (
    echo Codec lossless disponibili: x264, x265, VP9
    set /p codec= Scegli uno dei codec disponibili in modalita' lossless: 
    	if /I %codec% EQU x264 goto crfparam
    	if /I %codec% EQU x265 goto crfparam
    	if /I %codec% EQU VP9 goto crfparam

	echo Codec non valido. Riprova. 
	goto codecChoice
)

:crfparam
if "%encodingType%"=="lossy" (
    echo Hai scelto %codec% in modalita' lossy.
    goto inserisciCRF
) else (
    echo Hai scelto %codec% in modalita' lossless.
    if /I "%codec%"=="x264" (
        set crf=0
        echo x264 configurato per lossless con CRF=0.
	goto speedStep
    ) else if /I "%codec%"=="x265" (
        set crf=1
        echo x265 configurato per lossless con CRF=0.
	goto speedStep
    ) else if /I "%codec%"=="VP9" (
        set crf=0
        echo VP9 configurato per lossless con CRF=0.
	goto speedStep
    ) else if /I "%codec%"=="OpenH264" (
	set crf=0
        echo OpenH264 configurato per lossless con CRF=0.
	goto speedStep
    ) else if /I "%codec%"=="VP8" (
	set crf=0
        echo VP8 configurato per lossless con CRF=0.
	goto speedStep
    )
)

:inserisciCRF
if /I "%codec%"=="x264" (
    set /p crf= Inserisci un valore CRF (0...51) per x264 (valore comune: 23): 
    if %crf% EQU LSS 0 (
        echo Valore CRF non valido! Riprova.
        goto inserisciCRF
    )
    if %crf% EQU GTR 51 (
        echo Valore CRF non valido! Riprova.
        goto inserisciCRF
    )
) else if /I "%codec%"=="x265" (
    set /p crf= Inserisci un valore CRF (0...51) per x265 (valore comune: 28): 
    if %crf% EQU LSS 0 (
        echo Valore CRF non valido! Riprova.
        goto inserisciCRF
    )
    if %crf% EQU GTR 51 (
        echo Valore CRF non valido! Riprova.
        goto inserisciCRF
    )
) else if /I "%codec%"=="VP9" (
    set /p crf= Inserisci un valore CRF (0...63) per VP9 (valore comune: 31): 
    if %crf% EQU LSS 0 (
        echo Valore CRF non valido! Riprova.
        goto inserisciCRF
    )
    if %crf% EQU GTR 63 (
        echo Valore CRF non valido! Riprova.
        goto inserisciCRF
    )
) else if /I "%codec%"=="OpenH264" (
    set /p crf= Inserisci un valore CRF (0...51) per OpenH264 (valore comune: 23): 
    if %crf% EQU LSS 0 (
        echo Valore CRF non valido! Riprova.
        goto inserisciCRF
    )
    if %crf% EQU GTR 51 (
        echo Valore CRF non valido! Riprova.
        goto inserisciCRF
    )
) else if /I "%codec%"=="VP8" (
    set /p crf= Inserisci un valore CRF (0...63) per VP8 (valore comune: 31): 
    if %crf% EQU LSS 0 (
        echo Valore CRF non valido! Riprova.
        goto inserisciCRF
    )
    if %crf% EQU GTR 63 (
        echo Valore CRF non valido! Riprova.
        goto inserisciCRF
    )
)

:speedStep
if /I "%codec%"=="x264" (
    goto askSpeed
) else if /I "%codec%"=="x265" (
    goto askSpeed
) else if /I "%codec%"=="VP8" (
    goto askVP9Speed
) else if /I "%codec%"=="VP9" (
    goto askVP9Speed
) else if /I "%codec%"=="openh264" (
    echo OpenH264 non supporta la modifica della velocita' di codifica.
    goto nextStep
) else (
    echo Il codec scelto non supporta la modifica della velocita' di codifica.
    goto nextStep
)


:askVP9Speed
set /p speed= Inserisci la velocita' di codifica per %codec% (realtime, best, good): 
if /I not "%speed%"=="realtime" (
    if /I not "%speed%"=="best" (
        if /I not "%speed%"=="good" (
            echo Valore di velocita' non valido! Riprova.
            goto askVP9Speed
        )
    )
)
goto nextStep

:askSpeed
set /p speed= Inserisci la velocita' di codifica (veryslow, slower, slow, medium, fast, faster, veryfast, superfast, ultrafast): 
if /I not "%speed%"=="ultrafast" if /I not "%speed%"=="superfast" if /I not "%speed%"=="veryfast" if /I not "%speed%"=="faster" if /I not "%speed%"=="fast" if /I not "%speed%"=="medium" if /I not "%speed%"=="slow" if /I not "%speed%"=="slower" if /I not "%speed%"=="veryslow" (
    echo Valore di velocita' non valido! Riprova.
    goto speedStep
)


:nextStep
if /I "%operation%"=="codifica" (
    set operationType=codifica
) else if /I "%operation%"=="decifra" (
    set operationType=decodifica
) else (
    set operationType=Operazione sconosciuta
)

if /I "%codec%"=="openh264" (
    echo Parametri configurati: operazione = %operationType%, tipologia = %encodingType%, codec = %codec%, CRF = %crf%.
) else (
    echo Parametri configurati: operazione = %operationType%, tipologia = %encodingType%, codec = %codec%, CRF = %crf%, velocita' = %speed%.
)



if %operation% EQU decifra (goto decode)
echo Lettura delle informazioni del file video...
start /B /wait ffmpeg -y -i ./VCHoxha/%filename% ./VCHoxha/video.yuv 2> nul
start /B /wait ffmpeg -y -i ./VCHoxha/%filename% -vn -acodec copy ./VCHoxha/audio.aac 2> nul

cd ./VCHoxha

start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getVideoSize > videoSize.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getVideoLength > videoLength.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getFrameRate > frameRate.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getFrameNumber > frameNumber.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getFrameHeight > frameHeight.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getFrameWidth > frameWidth.tmp
for /f "delims=" %%x in (videoSize.tmp) do set videoSize=%%x
for /f "delims=" %%x in (videoLength.tmp) do set videoLength=%%x
for /f "delims=" %%x in (frameRate.tmp) do set frameRate=%%x
for /f "delims=" %%x in (frameNumber.tmp) do set frameNumber=%%x
for /f "delims=" %%x in (frameHeight.tmp) do set frameHeight=%%x
for /f "delims=" %%x in (frameWidth.tmp) do set frameWidth=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar ../VCHoxha/video.yuv --getPixelFormat %frameHeight% %frameWidth% %frameNumber% > pixelFormat.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar ../VCHoxha/video.yuv --getVideoSlices > videoSlices.tmp
for /f "delims=" %%x in (pixelFormat.tmp) do set pixelFormat=%%x
for /f "delims=" %%x in (videoSlices.tmp) do set videoSlices=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTimeSlice %videoLength% %videoSlices% > timeSlice.tmp
for /f "delims=" %%x in (timeSlice.tmp) do set timeSlice=%%x
set size=%frameWidth%x%frameHeight%
del video.yuv > nul
del videoSize.tmp > nul
del videoLength.tmp > nul
del frameRate.tmp > nul
del frameNumber.tmp > nul
del frameHeight.tmp > nul
del frameWidth.tmp > nul
del pixelFormat.tmp > nul
del videoSlices.tmp > nul
del timeSlice.tmp > nul
echo Dimensioni video: %videoSize% kb
echo Lunghezza video: %videoLength% s
echo Frame rate: %frameRate% fps
echo Numero frame: %frameNumber%
echo Larghezza frame: %frameWidth% px
echo Altezza frame: %frameHeight% px
echo Formato pixel: %pixelFormat%

if %pixelFormat% EQU yuv420p (goto postConversion)

cd ..

echo Convertendo i pixel in formato yuv420p...
if "%codec%"=="x264" (
    start /B /wait ffmpeg -y -i ./VCHoxha/%filename% -c:v libx264 -crf 23 -preset veryslow -pix_fmt yuv420p ./VCHoxha/video.mp4 2> nul
	set filename=video.mp4
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -y -i ./VCHoxha/%filename% -c:v libx265 -crf 23 -preset veryslow -pix_fmt yuv420p ./VCHoxha/video.mp4 2> nul
	set filename=video.mp4
) else if "%%c"=="VP8" (
    start /B /wait ffmpeg -y -i ./VCHoxha/%filename% -c:v libvpx -b:v 1M -deadline %speed% -pix_fmt yuv420p ./VCHoxha/video.webm 2> nul
	set filename=video.webm
) else if "%%c"=="VP9" (
    start /B /wait ffmpeg -y -i ./VCHoxha/%filename% -c:v libvpx-vp9 -crf 23 -b:v 1M -speed %speed% -pix_fmt yuv420p ./VCHoxha/video.webm 2> nul
	set filename=video.webm
)else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -y -i ./VCHoxha/%filename% -c:v libopenh264 -b:v 1M -pix_fmt yuv420p ./VCHoxha/video.mp4 2> nul
	set filename=video.mp4
)
start /B /wait ffmpeg -y -i ./VCHoxha/%filename% ./VCHoxha/video.yuv 2> nul

cd ./VCHoxha

start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getVideoLength > videoLength.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getFrameRate > frameRate.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getFrameHeight > frameHeight.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getFrameWidth > frameWidth.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar video.yuv --getVideoSlices > videoSlices.tmp
for /f "delims=" %%x in (videoLength.tmp) do set videoLength=%%x
for /f "delims=" %%x in (frameRate.tmp) do set frameRate=%%x
for /f "delims=" %%x in (frameHeight.tmp) do set frameHeight=%%x
for /f "delims=" %%x in (frameWidth.tmp) do set frameWidth=%%x
for /f "delims=" %%x in (videoSlices.tmp) do set videoSlices=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTimeSlice %videoLength% %videoSlices% > timeSlice.tmp
for /f "delims=" %%x in (timeSlice.tmp) do set timeSlice=%%x
del video.yuv > nul
del videoLength.tmp > nul
del frameRate.tmp > nul
del frameHeight.tmp > nul
del frameWidth.tmp > nul
del videoSlices.tmp > nul
del timeSlice.tmp > nul

:postConversion

echo Codificando...
if %encodingType% EQU lossy (goto lossyCod)
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

start /B /wait ffmpeg -i ./VCHoxha/%filename% -f segment -segment_time %timeSlice% -pix_fmt yuv420p ./VCHoxha/video-%%d.yuv 2> nul

cd ./VCHoxha

start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --delta0 %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeConcatBashScript delta0 %videoSlices%
start /B /wait delta0.sh
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set encodingTimeD0=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

if "%codec%"=="x264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta0.yuv -c:v libx264 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/share1.mp4 2> nul
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta0.yuv -c:v libx265 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/share1.mp4 2> nul
) else if "%codec%"=="VP8" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta0.yuv -c:v libvpx -b:v 1M -deadline %speed% -pix_fmt yuv420p ./VCHoxha/share1.webm 2> nul
) else if "%codec%"=="VP9" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta0.yuv -c:v libvpx-vp9 -b:v 1M -deadline %speed% -pix_fmt yuv420p ./VCHoxha/share1.webm 2> nul
) else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta0.yuv -c:v libopenh264 -b:v 1M -pix_fmt yuv420p ./VCHoxha/share1.mp4 2> nul)

cd ./VCHoxha

start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set writingTimeD0=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --sumTime %encodingTimeD0% %writingTimeD0% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set totalTimeD0=%%x
echo Tempo impiegato per calcolare la prima share (calcolo dei pixel + codifica %codec%): %encodingTimeD0%s + %writingTimeD0%s = %totalTimeD0%s
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getTime > startTime.tmp

for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

if "%codec%"=="x264" (
    start /B /wait ffmpeg -i ./VCHoxha/share1.mp4 -f segment -segment_time %timeSlice% -pix_fmt yuv420p libx264 ./VCHoxha/delta0-%%d.yuv 2> nul
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -i ./VCHoxha/share1.mp4 -f segment -segment_time %timeSlice% -pix_fmt yuv420p libx265 ./VCHoxha/delta0-%%d.yuv 2> nul
) else if "%codec%"=="VP8" (
    start /B /wait ffmpeg -i ./VCHoxha/share1.webm -f segment -segment_time %timeSlice% -pix_fmt yuv420p libvpx -b:v 1M ./VCHoxha/delta0-%%d.yuv 2> nul
) else if "%codec%"=="VP9" (
    start /B /wait ffmpeg -i ./VCHoxha/share1.webm -f segment -segment_time %timeSlice% -pix_fmt yuv420p libvpx-vp9 -b:v 1M ./VCHoxha/delta0-%%d.yuv 2> nul
) else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -i ./VCHoxha/share1.mp4 -f segment -segment_time %timeSlice% -pix_fmt yuv420p libopenh264 -b:v 1M ./VCHoxha/delta0-%%d.yuv 2> nul)


cd ./VCHoxha

start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --delta1 %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeConcatBashScript delta1 %videoSlices%
start /B /wait delta1.sh
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set encodingTimeD1=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

if "%codec%"=="x264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta1.yuv -c:v libx264 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/share2.mp4 2> nul
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta1.yuv -c:v libx265 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/share2.mp4 2> nul
) else if "%codec%"=="VP8" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta1.yuv -c:v libvpx -b:v 1M -deadline %speed% -pix_fmt yuv420p ./VCHoxha/share2.webm 2> nul
) else if "%codec%"=="VP9" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta1.yuv -c:v libvpx-vp9 -crf %crf% -b:v 1M -deadline %speed% -pix_fmt yuv420p ./VCHoxha/share2webmmp4 2> nul
) else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta1.yuv -c:v libopenh264 -b:v 1M -pix_fmt yuv420p ./VCHoxha/share2.mp4 2> nul)


cd ./VCHoxha

start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set writingTimeD1=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --sumTime %encodingTimeD1% %writingTimeD1% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set totalTimeD1=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --sumTime %totalTimeD0% %totalTimeD1% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set totalTime=%%x
echo Tempo impiegato per calcolare la seconda share (calcolo dei pixel + codifica %codec%): %encodingTimeD1%s + %writingTimeD1%s = %totalTimeD1%s
echo Tempo totale impiegato per la codifica: %totalTime%s
del startTime.tmp > nul
del endTime.tmp > nul
del computedTime.tmp > nul
del delta0.yuv > nul
del delta1.yuv > nul
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript video %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript delta0 %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript delta1 %videoSlices%
start /B /wait video-del.sh
start /B /wait delta0-del.sh
start /B /wait delta1-del.sh
del video-del.sh > nul
del delta0-del.sh > nul
del delta1-del.sh > nul
del delta0.sh > nul
del delta1.sh > nul
if exist video.mp4 (del video.mp4 > nul)
if exist video.webm (del video.webm > nul)

cd ..

echo Puoi trovare le due share (share1.mp4 e share2.mp4) e la traccia audio originale (audio.aac) nella cartella "Video".
echo Premi un tasto per continuare...
pause > nul
goto end

:lossyCod
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

start /B /wait ffmpeg -i ./VCHoxha/%filename% -f segment -segment_time %timeSlice% -pix_fmt yuv420p ./VCHoxha/video-%%d.yuv  2> nul

cd ./VCHoxha

start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --delta0 %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeConcatBashScript delta0 %videoSlices%
start /B /wait delta0.sh
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set encodingTimeD0=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

if "%codec%"=="x264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta0.yuv -c:v libx264 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/share1.mp4 2> nul
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta0.yuv -c:v libx265 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/share1.mp4 2> nul
) else if "%codec%"=="VP8" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta0.yuv -c:v libvpx -b:v 1M -deadline %speed% -pix_fmt yuv420p ./VCHoxha/share1.webm 2> nul
) else if "%codec%"=="VP9" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta0.yuv -c:v libvpx-vp9 -crf %crf% -b:v 1M -deadline %speed% -pix_fmt yuv420p ./VCHoxha/share1.webm 2> nul
) else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/delta0.yuv -c:v libopenh264 -b:v 1M -pix_fmt yuv420p ./VCHoxha/share1.mp4 2> nul)

cd ./VCHoxha

start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set writingTimeD0=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --sumTime %encodingTimeD0% %writingTimeD0% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set totalTimeD0=%%x
echo Tempo impiegato per calcolare la prima share (calcolo dei pixel + codifica %codec%): %encodingTimeD0%s + %writingTimeD0%s = %totalTimeD0%s
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

if "%codec%"=="x264" (
    start /B /wait ffmpeg -i ./VCHoxha/share1.mp4 -f segment -segment_time %timeSlice% -pix_fmt yuv420p libx264 ./VCHoxha/delta0-%%d.yuv 2> nul
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -i ./VCHoxha/share1.mp4 -f segment -segment_time %timeSlice% -pix_fmt yuv420p libx265 ./VCHoxha/delta0-%%d.yuv 2> nul
) else if "%codec%"=="VP8" (
    start /B /wait ffmpeg -i ./VCHoxha/share1.webm -f segment -segment_time %timeSlice% -pix_fmt yuv420p libvpx -b:v 1M ./VCHoxha/delta0-%%d.yuv 2> nul
) else if "%codec%"=="VP9" (
    start /B /wait ffmpeg -i ./VCHoxha/share1.webm -f segment -segment_time %timeSlice% -pix_fmt yuv420p libvpx-vp9 -b:v 1M ./VCHoxha/delta0-%%d.yuv 2> nul
) else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -i ./VCHoxha/share1.mp4 -f segment -segment_time %timeSlice% -pix_fmt yuv420p libopenh264 -b:v 1M ./VCHoxha/delta0-%%d.yuv 2> nul)


cd ./VCHoxha

start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --delta1 %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeConcatBashScript delta1 %videoSlices%
start /B /wait delta1.sh
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set encodingTimeD1=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

if "%codec%"=="x264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %framerate% -i ./VCHoxha/delta1.yuv -c:v libx264 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/share2.mp4 2> nul
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %framerate% -i ./VCHoxha/delta1.yuv -c:v libx265 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/share2.mp4 2> nul
) else if "%codec%"=="VP8" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %framerate% -i ./VCHoxha/delta1.yuv -c:v libvpx -b:v 1M -pix_fmt yuv420p ./VCHoxha/share2.webm 2> nul
) else if "%codec%"=="VP9" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %framerate% -i ./VCHoxha/delta1.yuv -c:v libvpx-vp9 -b:v 1M -pix_fmt yuv420p ./VCHoxha/share2.webm 2> nul
) else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %framerate% -i ./VCHoxha/delta1.yuv -c:v libopenh264 -b:v 1M -pix_fmt yuv420p ./VCHoxha/share2.mp4 2> nul)

cd ./VCHoxha

start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set writingTimeD1=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --sumTime %encodingTimeD1% %writingTimeD1% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set totalTimeD1=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --sumTime %totalTimeD0% %totalTimeD1% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set totalTime=%%x
echo Tempo impiegato per calcolare la seconda share (calcolo dei pixel + codifica %codec%): %encodingTimeD1%s + %writingTimeD1%s = %totalTimeD1%s
echo Tempo totale impiegato per la codifica: %totalTime%s
del startTime.tmp > nul
del endTime.tmp > nul
del computedTime.tmp > nul
del delta0.yuv > nul
del delta1.yuv > nul
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript video %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript delta0 %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript delta1 %videoSlices%
start /B /wait video-del.sh
start /B /wait delta0-del.sh
start /B /wait delta1-del.sh
del video-del.sh > nul
del delta0-del.sh > nul
del delta1-del.sh > nul
del delta0.sh > nul
del delta1.sh > nul
if exist video.mp4 (del video.mp4 > nul)
if exist video.webm (del video.webm > nul)

cd ..

echo Puoi trovare le due share (share1.mp4 e share2.mp4) e la traccia audio originale (audio.aac) nella cartella "VCHoxha".
echo Premi un tasto per continuare...
pause > nul
goto end

:decode
echo Lettura delle informazioni del file video (share1 = share2)...
start /B /wait ffmpeg -y -i ./VCHoxha/%filed0% ./VCHoxha/delta0.yuv 2> nul

cd ./VCHoxha

start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filed0% --getVideoLength > videoLength.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filed0% --getFrameRate > frameRate.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filed0% --getFrameNumber > frameNumber.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filed0% --getFrameHeight > frameHeight.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filed0% --getFrameWidth > frameWidth.tmp
for /f "delims=" %%x in (videoLength.tmp) do set videoLength=%%x
for /f "delims=" %%x in (frameRate.tmp) do set frameRate=%%x
for /f "delims=" %%x in (frameNumber.tmp) do set frameNumber=%%x
for /f "delims=" %%x in (frameHeight.tmp) do set frameHeight=%%x
for /f "delims=" %%x in (frameWidth.tmp) do set frameWidth=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar delta0.yuv --getPixelFormat %frameHeight% %frameWidth% %frameNumber% > pixelFormat.tmp
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar delta0.yuv --getVideoSlices > videoSlices.tmp
for /f "delims=" %%x in (pixelFormat.tmp) do set pixelFormat=%%x
for /f "delims=" %%x in (videoSlices.tmp) do set videoSlices=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTimeSlice %videoLength% %videoSlices% > timeSlice.tmp
for /f "delims=" %%x in (timeSlice.tmp) do set timeSlice=%%x
set size=%frameWidth%x%frameHeight%
del delta0.yuv > nul
del videoLength.tmp > nul
del frameRate.tmp > nul
del frameNumber.tmp > nul
del frameHeight.tmp > nul
del frameWidth.tmp > nul
del pixelFormat.tmp  > nul
del videoSlices.tmp > nul
del timeSlice.tmp > nul
echo Lunghezza video: %videoLength% s
echo Frame rate: %frameRate% fps
echo Numero frame: %frameNumber%
echo Larghezza frame: %frameWidth% px
echo Altezza frame: %frameHeight% px
echo Formato pixel: %pixelFormat%

echo Decodificando...
if %encodingType% EQU lossy (goto lossyDec)
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

start /B /wait ffmpeg -i ./VCHoxha/%filed0% -f segment -segment_time %timeSlice% -pix_fmt yuv420p ./VCHoxha/delta0-%%d.yuv 
start /B /wait ffmpeg -i ./VCHoxha/%filed1% -f segment -segment_time %timeSlice% -pix_fmt yuv420p ./VCHoxha/delta1-%%d.yuv 

cd ./VCHoxha

start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --secret %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeConcatBashScript secret %videoSlices%
start /B /wait secret.sh
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set decodingTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

if %fileaudio% EQU none (goto noaudio)
if "%codec%"=="x264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -i ./VCHoxha/%fileaudio% -c:v libx264 -c:a copy -crf 0 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -i ./VCHoxha/%fileaudio% -c:v libx265 -c:a copy -crf 0 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4 2> nul
) else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -i ./VCHoxha/%fileaudio% -c:v libopenh264 -c:a copy -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.webm 2> nul
) else if "%codec%"=="VP8" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -i ./VCHoxha/%fileaudio% -c:v libvpx -c:a copy -crf 23 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.webm 2> nul
) else if "%codec%"=="VP9" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -i ./VCHoxha/%fileaudio% -c:v libvpx-vp9 -c:a copy -crf 23 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4 2> nul)

goto postNoAudioStep

:noaudio
if "%codec%"=="x264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -c:v libx264 -crf 0 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4 
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -c:v libx265 -crf 0 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4 2> nul
) else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -c:v libopenh264 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.webm 2> nul
) else if "%codec%"=="VP8" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -c:v libvpx -crf 23 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.webm 2> nul
) else if "%codec%"=="VP9" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -c:v libvpx-vp9 -crf 23 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4 2> nul)


:postNoAudioStep
cd ./VCHoxha
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set writingTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar %filename% --sumTime %decodingTime% %writingTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set totalTime=%%x
echo Tempo impiegato per calcolare il video originale (calcolo dei pixel + decodifica %codec%): %decodingTime%s + %writingTime%s = %totalTime%s
echo Tempo totale impiegato per la decodifica: %totalTime%s
del startTime.tmp > nul
del endTime.tmp > nul
del computedTime.tmp > nul
del secret.yuv > nul
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript secret %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript delta0 %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript delta1 %videoSlices%
start /B /wait secret-del.sh
start /B /wait delta0-del.sh
start /B /wait delta1-del.sh
del secret-del.sh > nul
del delta0-del.sh > nul
del delta1-del.sh > nul
del secret.sh > nul

cd ..

echo Puoi trovare il video segreto decodificato (secret.mp4) nella cartella "VCHoxha".
echo Premi un tasto per continuare...
pause > nul
goto end

:lossyDec
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

start /B /wait ffmpeg -i ./VCHoxha/%filed0% -f segment -segment_time %timeSlice% -pix_fmt yuv420p ./VCHoxha/delta0-%%d.yuv 2> nul
start /B /wait ffmpeg -i ./VCHoxha/%filed1% -f segment -segment_time %timeSlice% -pix_fmt yuv420p ./VCHoxha/delta1-%%d.yuv 2> nul

cd ./VCHoxha

start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --secret %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeConcatBashScript secret %videoSlices%
start /B /wait secret.sh 
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set decodingTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > startTime.tmp
for /f "delims=" %%x in (startTime.tmp) do set startTime=%%x

cd ..

if %fileaudio% EQU none (goto noaudio)
if "%codec%"=="x264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -i ./VCHoxha/%fileaudio% -c:v libx264 -c:a copy -crf 0 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -i ./VCHoxha/%fileaudio% -c:v libx265 -c:a copy -crf 0 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4 2> nul
) else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -i ./VCHoxha/%fileaudio% -c:v libopenh264 -c:a copy -deadline %speed% -pix_fmt yuv420p ./VCHoxha/secret.webm 2> nul
) else if "%codec%"=="VP8" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -i ./VCHoxha/%fileaudio% -c:v libvpx -c:a copy -deadline %speed% -pix_fmt yuv420p ./VCHoxha/secret.webm 2> nul
) else if "%codec%"=="VP9" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -i ./VCHoxha/%fileaudio% -c:v libvpx-vp9 -c:a copy -crf 23 -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4 2> nul)

goto postNoAudioStep

:noaudio
if "%codec%"=="x264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -c:v libx264 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4 2> nul
) else if "%codec%"=="x265" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -c:v libx265 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4 2> nul
) else if "%codec%"=="OpenH264" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -c:v libopenh264 -deadline %speed% -pix_fmt yuv420p ./VCHoxha/secret.webm 2> nul
) else if "%codec%"=="VP8" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -c:v libvpx -deadline %speed% -pix_fmt yuv420p ./VCHoxha/secret.webm 2> nul
) else if "%codec%"=="VP9" (
    start /B /wait ffmpeg -y -video_size %size% -pix_fmt yuv420p -framerate %frameRate% -i ./VCHoxha/secret.yuv -c:v libvpx-vp9 -crf %crf% -preset %speed% -pix_fmt yuv420p ./VCHoxha/secret.mp4 2> nul)

:postNoAudioStep
cd ./VCHoxha
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --getTime > endTime.tmp
for /f "delims=" %%x in (endTime.tmp) do set endTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --computeTime %startTime% %endTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set writingTime=%%x
start /B /wait java -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --sumTime %decodingTime% %writingTime% > computedTime.tmp
for /f "delims=" %%x in (computedTime.tmp) do set totalTime=%%x
echo Tempo totale impiegato per calcolare il video originale (calcolo dei pixel + decodifica %codec%): %decodingTime%s + %writingTime%s = %totalTime%s
del startTime.tmp > nul
del endTime.tmp > nul
del computedTime.tmp > nul
del secret.yuv > nul
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript secret %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript delta0 %videoSlices%
start /B /wait java -Xms1024m -Xmx4096m -Djava.library.path=opencv/build/java/x64 -jar VCHoxha.jar placeholder --writeDelBashScript delta1 %videoSlices%
start /B /wait secret-del.sh
start /B /wait delta0-del.sh 
start /B /wait delta1-del.sh 
del secret-del.sh > nul
del delta0-del.sh > nul
del delta1-del.sh > nul
del secret.sh > nul
cd ..
echo Puoi trovare il video segreto decodificato (secret.mp4) nella cartella "VCHoxha".
echo Premi un tasto per continuare...
pause > nul

:end