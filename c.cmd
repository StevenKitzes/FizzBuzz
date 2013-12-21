@echo off

rem c
rem     If MS VS vv.0 hasn't already been initialized, do so (vv in [6,20])
rem c prog.cpp
rem     Initialize MS VS vv.0, if necessary
rem     Compile prog.cpp (if problem, exit this command file)
rem     Link prog.obj (if problem, exit this command file)
rem     Run prog.exe
rem c prog.c
rem     Same thing, but now we're working with a program in C instead of C++
rem c prog
rem     Work with prog.c or prog.cpp, whichever exists
rem c prog arg1 arg2 arg3
rem     When we run prog.exe, supply the given command-line args
rem c /c prog    (/c etc. are case sensitive)
rem     Just compile, don't link or run
rem c /cl prog
rem     Just compile and link, don't run
rem c /clr prog args
rem     Same as    c prog args
rem c /l prog
rem     Don't compile or execute, just link
rem c /l prog.obj
rem     Same as    c /l prog
rem c /lr prog args
rem     Don't compile, just link and run
rem c /r prog args
rem     Don't compile or link, just run
rem c /r prog.exe args
rem     Same as    c /r prog args
rem c prog.obj args
rem     Same as    c /lr prog
rem c prog.exe args
rem     Same as    c /r prog args

rem Normally, this command file runs in the mode where compiler warnings are
rem treated as errors and therefore prevent linking and compiling; we should
rem treat warnings seriously and produce C/C++ code without errors or warnings.
rem To temporarily turn off this feature so that C/C++ programs with warnings
rem can compile, link, and run, type (without the rem)
rem     set compilerOptions=/c /EHsc /W4
rem That will disable the die-on-warnings feature so that programs with
rem warnings can compile, link, and run. This disabling will affect the current
rem DOS window until you close the window or until you type
rem     set compilerOptions=

rem This command file can normally compile-link-execute a file that is in
rem another drive/folder. The .obj and .exe files are then created in the same
rem drive/folder as the .c/.cpp file, but the program is executed in the folder
rem from which this command file is invoked. However, temporarily disabling the
rem die-on-warnings feature as described above also temporarily disables this
rem compile-link-execute-a-file-in-another-folder feature.

rem Input redirection can be used with this command file:
rem     c prog args <data.txt
rem will supply the lines in data.txt to prog.exe as user input.
rem Output redirection can be used after a fashion:
rem     c prog args >output.txt
rem but the output file will contain diagnostic messages from the compiler and
rem linker and progress messages from this command file as well as any output
rem from prog.exe. If you want to capture the program output in a file, it's
rem probably best do it with 2 statements:
rem     c /cl prog
rem     prog args >output.txt
rem or 2 statements on one line:
rem     c /cl prog & prog args >output.txt
rem This way, all the verbage from the compilation and linkage doesn't end up
rem in your output file.
rem If you use output redirection, with or without this command file, remember
rem that output direction can be dangerously destructive: any previous contents
rem of the output file are irretrievably destroyed without so much as an
rem "Are you sure?"

rem This is the end of the user documentation.

    rem To initialize MS VS vv.0, this command file must run the vsvars32.bat
    rem batch file.
    rem This needn't be done each time a program is compiled, but must be done
    rem each time a DOS window is opened in which we want to compile.
    rem The environment variable VSvv0COMNTOOLS is set (to the location of the
    rem vsvars32.bat file) when the MS VS vv.0 program is installed onto the
    rem computer.
    rem The environment variable VCINSTALLDIR is set (to the location of the
    rem bin folder that contains the compiler and linker) when we run
    rem vsvars32.bat.

if defined VCINSTALLDIR goto :VCDefined
if defined VS200COMNTOOLS call "%VS200COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS190COMNTOOLS call "%VS190COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS180COMNTOOLS call "%VS180COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS170COMNTOOLS call "%VS170COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS160COMNTOOLS call "%VS160COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS150COMNTOOLS call "%VS150COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS140COMNTOOLS call "%VS140COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS130COMNTOOLS call "%VS130COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS120COMNTOOLS call "%VS120COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS110COMNTOOLS call "%VS110COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS100COMNTOOLS call "%VS100COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS90COMNTOOLS call "%VS90COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS80COMNTOOLS call "%VS80COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS70COMNTOOLS call "%VS70COMNTOOLS%vsvars32.bat" & goto :VCCheck
if defined VS60COMNTOOLS call "%VS60COMNTOOLS%vsvars32.bat" & goto :VCCheck
(echo MS VS doesn't seem to be installed on this machine)
    rem copy without parameters sets errorLevel to 1
copy >nul
goto :EOF

:VCCheck
if defined VCINSTALLDIR goto :VCDefined
(echo I can't define VCINSTALLDIR on this machine)
    rem copy without parameters sets errorLevel to 1
copy >nul
goto :EOF

:VCDefined

    rem ver without parameters sets errorLevel to 0
if %1. equ . (ver>nul) & goto :EOF

setlocal

    rem Environment variables c, l, and r control whether we compile, link, and
    rem run, respectively.
    rem clr means %1 is any of /c /l /r /cl /lr /clr
set c=1&
set l=1&
set r=1&
set clr=1&
set zero=%~dpnx0&
                                                 if /i %1 equ /c   (
            (set l=0) & (set r=0) & shift ) else if /i %1 equ /l   (
(set c=0)             & (set r=0) & shift ) else if /i %1 equ /r   (
(set c=0) & (set l=0)             & shift ) else if /i %1 equ /cl  (
                        (set r=0) & shift ) else if /i %1 equ /lr  (
(set c=0)                         & shift ) else if /i %1 equ /clr (
                                    shift ) else                   (
(set clr=0) )

if %1. equ . goto :NoProgramName

set prog=%~dpn1&
set ext=%~x1&
if    "%ext%" neq ""     if /i "%ext%" neq ".c"   if /i "%ext%" neq ".cpp" (
if /i "%ext%" neq ".obj" if /i "%ext%" neq ".exe" goto :UnrecognizedExtension )

if %2. neq . if %r% equ 0 goto :ArgsWithoutRun

if %clr% equ 1 (
    if %c% equ 1 (
        if /i %ext%. equ .c.   goto :FECompile
        if /i %ext%. equ .cpp. goto :FECompile
        if    %ext%. neq .     goto :IncompatibleExtension
        if exist "%prog%.c" (
            if exist "%prog%.cpp" goto :BothExist
            (set ext=.c)
            goto :Compile
        ) else if exist "%prog%.cpp" (
            (set ext=.cpp)
            goto :Compile
        ) else (
            goto :NeitherExists
        )
    ) else if %l% equ 1 (
        if    %ext%. equ .     (set ext=.obj) & goto :FELink
        if /i %ext%. equ .obj. goto :FELink
        goto :IncompatibleExtension
    ) else (
        if    %ext%. equ .     (set ext=.exe) & goto :FERun
        if /i %ext%. equ .exe. goto :FERun
        goto :IncompatibleExtension
    )
) else (
    if /i %ext%. equ .c.   goto :FECompile
    if /i %ext%. equ .cpp. goto :FECompile
    if /i %ext%. equ .obj. goto :FELink
    if /i %ext%. equ .exe. goto :FERun
    if exist "%prog%.c" (
        if exist "%prog%.cpp" goto :BothExist
        (set ext=.c)
        goto :Compile
    ) else if exist "%prog%.cpp" (
        (set ext=.cpp)
        goto :Compile
    ) else (
        goto :NeitherExists
    )
)


:FECompile
if not exist "%prog%%ext%" goto :NotExist

:Compile

if defined compilerOptions (
     (set options=%compilerOptions%)
) else if /i %ext% equ .c (
    (set options=/c /Fo"%prog%.obj" /nologo /W4 /WX)
) else (
    (set options=/c /EHsc /Fo"%prog%.obj" /nologo /W4 /WX)
)

echo compiling %options% %prog%%ext%...
"%VCINSTALLDIR%bin\cl.exe" %options% "%prog%%ext%"
if %errorLevel% neq 0 goto :EOF
if %l% equ 0 goto :EOF
set ext=.obj&
goto :LINK

:FELink
if not exist "%prog%%ext%" goto :NotExist

:Link

if defined linkerOptions (
    (set options=%linkerOptions%)
) else (
    (set options=/nologo /out:"%prog%.exe" /WX)
)

echo linking %options% %prog%%ext%...
"%VCINSTALLDIR%bin\link.exe" %options% "%prog%%ext%"
if %errorLevel% neq 0 goto :EOF
if %r% equ 0 goto :EOF
set ext=.exe&
goto :RUN

:FERun
if not exist "%prog%%ext%" goto :NotExist

:Run

set arguments=&
goto :Pool
:Loop
    set arguments=%arguments% %1&
:Pool
    shift
    if %1. neq . goto :LOOP

echo running %prog%%ext%%arguments%...&
"%prog%%ext%"%arguments%
goto :EOF

:ArgsWithoutRun
    set error=If you don't want to run %prog%.exe, don't supply arguments.&
    goto :ERROR

:BothExist
    set error=%1.c and %1.cpp both exist, you must specify which extension.&
    goto :ERROR

:IncompatibleExtension
    set error=Extension %ext% is incompatible with %0.&
    goto :ERROR

:NeitherExists
    set error=Neither %1.c nor %1.cpp seems to exist.&
    goto :ERROR

:NoProgramName
    set error=You forgot to tell me the program name.&
    goto :ERROR

:NotExist
    set error=%prog%%ext% doesn't seem to exist.&
    goto :ERROR

:UnrecognizedExtension
    set error=%1 has an extension ^(%ext%^) I don't recognize.&
    goto :ERROR

:ERROR
dir %~dp1
echo Error in %zero%: %error%
copy >nul
