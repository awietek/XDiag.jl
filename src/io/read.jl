read_permutation_group(file::FileToml, tag::String)::PermutationGroup =
    cxx_read_permutation_group(file.cxx_file, tag)

read_representation(file::FileToml, irrep_tag::String,
                    group_tag::String = "Symmetries")::Representation =
    cxx_read_representation(file.cxx_file, irrep_tag, group_tag)

read_opsum(file::FileToml, tag::String)::OpSum =
    cxx_read_opsum(file.cxx_file, tag)
