# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

struct FileToml
    cxx_file::cxx_FileToml
end
convert(FileToml, cxx_file::cxx_FileToml) = FileToml(cxx_file)
FileToml(name::String) = FileToml(construct_FileToml(name))
