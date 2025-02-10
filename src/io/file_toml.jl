struct FileToml
    cxx_file::cxx_FileToml
end
convert(FileToml, cxx_file::cxx_FileToml) = FileToml(cxx_file)
FileToml(name::String) = FileToml(cxx_FileToml(name))
