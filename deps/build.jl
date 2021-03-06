using BinDeps

depsdir = joinpath(Pkg.dir(),"HttpParser","deps")
prefix=joinpath(depsdir,"usr")
uprefix = replace(replace(prefix,"\\","/"),"C:/","/c/")
target = joinpath(prefix,"lib/libhttp_parser.$(BinDeps.shlib_ext)")

run(@build_steps begin
    ChangeDirectory(Pkg2.Dir.path("HttpParser"))
    FileRule("deps/src/http-parser/Makefile",`git submodule update --init`)
    FileRule(target,@build_steps begin
        ChangeDirectory(Pkg2.Dir.path("HttpParser","deps","src"))
        CreateDirectory(dirname(target))
        MakeTargets(["-C","http-parser","library"])
        `cp http-parser/libhttp_parser.so $target`
    end)
end)