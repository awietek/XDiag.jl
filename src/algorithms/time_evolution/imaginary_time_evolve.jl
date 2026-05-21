# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

imaginary_time_evolve(ops::OpSum,
                      psi0::State,
                      time::Float64; 
                      precision::Float64=1e-12,
                      shift::Float64=0.0)::State = 
                          cxx_imaginary_time_evolve(ops.cxx_opsum,
                                                    psi0.cxx_state,
                                                    time,
                                                    precision,
                                                    shift)
imaginary_time_evolve(ops::CSRMatrix,
                      psi0::State,
                      time::Float64; 
                      precision::Float64=1e-12,
                      shift::Float64=0.0)::State = 
                          with_cxx_csr_matrix(ops) do cxx_ops
                              cxx_imaginary_time_evolve(cxx_ops,
                                                        psi0.cxx_state,
                                                        time,
                                                        precision,
                                                        shift)
                          end

imaginary_time_evolve_inplace(ops::OpSum,
                              psi0::State,
                              time::Float64; 
                              precision::Float64 = 1e-12,
                              shift::Float64=0.0) = 
                                  cxx_imaginary_time_evolve_inplace(ops.cxx_opsum,
                                                                    psi0.cxx_state,
                                                                    time,
                                                                    precision,
                                                                    shift)


imaginary_time_evolve_inplace(ops::CSRMatrix,
                              psi0::State,
                              time::Float64; 
                              precision::Float64 = 1e-12,
                              shift::Float64=0.0) = 
                                  with_cxx_csr_matrix(ops) do cxx_ops
                                      cxx_imaginary_time_evolve_inplace(cxx_ops,
                                                                        psi0.cxx_state,
                                                                        time,
                                                                        precision,
                                                                        shift)
                                  end
