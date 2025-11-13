import subprocess as sp

src_file_name = input("src: ")

cmd = [
    "zig", "build-lib",
    "-dynamic",
    "-O", 
    "ReleaseSafe",
    "-fPIC",
    f"usr/autos/{src_file_name}.zig",
    f"-femit-bin=zig-out/bin/usr/autos/{src_file_name}.dylib",
]

sp.run(cmd)
