[Mesh]
  [steady_exodus]
    type = FileMeshGenerator
    file = 'steady_coarse_THM_scen2_out.e'
    use_for_exodus_restart = true
  []
[]

Hour = 3600.0
Day = ${fparse 24.0*Hour}
Year = ${fparse 365.0*Day}

tau_1 = ${fparse 10000*Year} #1000
tau_2 = ${fparse tau_1 + 2500*Year} #10000

permeability_sediment_up = 6e-17 
permeability_sediment_low = 6e-17 #3.5e-15 
permeability_granite_up = 4e-14 #Vallier first inversion
permeability_granite_low = 6e-17
permeability_fault = 5.34e-14

m = ${fparse (permeability_sediment_up - 1e-18)/tau_1}
m_granite_up = ${fparse (permeability_granite_up - 1e-18)/tau_1}
fault = ${fparse (permeability_fault - 1e-18)/tau_1}

#input values
p_atm = 1e5 #[Pa]
T_top = 15 #[°C]
T_bottom = 525 #[°C]

[Variables]
  [dispx]
    initial_from_file_var = dispx
    initial_from_file_timestep = 2
  []
  [dispy]
    initial_from_file_var = dispy
    initial_from_file_timestep = 2
  []
  [dispz]
    initial_from_file_var = dispz

  []
  [pore_pressure]
    initial_from_file_var = pore_pressure
    initial_from_file_timestep = 2 #LATEST?
  []
  [temperature]
    initial_from_file_var = temperature
    initial_from_file_timestep = 2 #LATEST?
  []
[]

[AuxVariables]
  [stress_xx]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = stress_xx
    initial_from_file_timestep = 2
  []
  [stress_yy]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = stress_yy
    initial_from_file_timestep = 2
  []
  [stress_zz]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = stress_zz
    initial_from_file_timestep = 2
  []
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = stress_xy
    initial_from_file_timestep = 2
  []
  [stress_xz]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = stress_xz
    initial_from_file_timestep = 2
  []
  [stress_yz]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = stress_yz
    initial_from_file_timestep = 2
  []
  [sigma_n]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = sigma_n
    initial_from_file_timestep = 2
    block = 'robertsau_fault'
  []
  [tau]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = tau
    initial_from_file_timestep = 2
    block = 'robertsau_fault'
  []
  [biot]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = biot
    initial_from_file_timestep = 2
  []
  [ST]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = ST
    initial_from_file_timestep = 2
    block = 'robertsau_fault'
  []
  [thermal_stress_xx]
    order = CONSTANT
    family = MONOMIAL
    block = 'upper_sediments lower_sediments upper_granites lower_granites'
  []
  [thermal_stress_yy]
    order = CONSTANT
    family = MONOMIAL
    block = 'upper_sediments lower_sediments upper_granites lower_granites'
  []
  [thermal_stress_zz]
    order = CONSTANT
    family = MONOMIAL
    block = 'upper_sediments lower_sediments upper_granites lower_granites'
  []
  [vx]
    order = CONSTANT
    family = MONOMIAL
  []
  [vy]
    order = CONSTANT
    family = MONOMIAL
  []
  [vz]
    order = CONSTANT
    family = MONOMIAL
  []
  #Total flux
  [qt_x]
    order = CONSTANT
    family = MONOMIAL
  []
  [qt_y]
    order = CONSTANT
    family = MONOMIAL
  []
  [qt_z]
    order = CONSTANT
    family = MONOMIAL
  []
  # viscosity and density
  [rho]
    order = SECOND
    family = MONOMIAL
  []
  [eta]
    order = SECOND
    family = MONOMIAL
  []
[]

[AuxKernels]
  [vx]
    type = GolemDarcyVelocity
    variable = vx
    component = 0
    execute_on = 'TIMESTEP_END'
  []
  [vy]
    type = GolemDarcyVelocity
    variable = vy
    component = 1
    execute_on = 'TIMESTEP_END'
  []
  [vz]
    type = GolemDarcyVelocity
    variable = vz
    component = 2
    execute_on = 'TIMESTEP_END'
  []
  [rho_aux]
    type = MaterialRealAux
    variable = rho
    property = fluid_density
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [eta_aux]
    type = MaterialRealAux
    variable = eta
    property = fluid_viscosity
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [heat_total_flux_x]
    type = GolemTotalHeatFlux
    flow_type = face_invariant
    flux_type = all
    component = 0
    variable = qt_x
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [heat_total_flux_y]
    type = GolemTotalHeatFlux
    flow_type = face_invariant
    flux_type = all
    component = 1
    variable = qt_y
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [heat_total_flux_z]
    type = GolemTotalHeatFlux
    flow_type = face_invariant
    flux_type = all
    component = 2
    variable = qt_z
    execute_on = 'INITIAL TIMESTEP_END'
  []
  #Stresses
  [stress_xx]
    type = GolemStress
    variable = stress_xx
    index_i = 0
    index_j = 0
  []
  [stress_yy]
    type = GolemStress
    variable = stress_yy
    index_i = 1
    index_j = 1
  []
  [stress_zz]
    type = GolemStress
    variable = stress_zz
    index_i = 2
    index_j = 2
  []
  [stress_xy]
    type = GolemStress
    variable = stress_xy
    index_i = 0
    index_j = 1
  []
  [stress_xz]
    type = GolemStress
    variable = stress_xz
    index_i = 0
    index_j = 2
  []
  [stress_yz]
    type = GolemStress
    variable = stress_yz
    index_i = 1
    index_j = 2
  []
  #Thermal stresses
  [thermal_stress_xx]
    type = GolemThermalStress
    variable = thermal_stress_xx
    index = 0
    block = 'upper_sediments lower_sediments upper_granites lower_granites'
    execute_on = 'TIMESTEP_END'
  []
  [thermal_stress_yy]
    type = GolemThermalStress
    variable = thermal_stress_yy
    index = 1
    block = 'upper_sediments lower_sediments upper_granites lower_granites'
    execute_on = 'TIMESTEP_END'
  []
  [thermal_stress_zz]
    type = GolemThermalStress
    variable = thermal_stress_zz
    index = 2
    block = 'upper_sediments lower_sediments upper_granites lower_granites'
    execute_on = 'TIMESTEP_END'
  []
[]

[Kernels]
  [momentum_x]
    type = GolemKernelM
    variable = dispx
    component = 0
    block = 'upper_sediments lower_sediments upper_granites lower_granites'
  []
  [momentum_y]
    type = GolemKernelM
    variable = dispy
    component = 1
    block = 'upper_sediments lower_sediments upper_granites lower_granites'
  []
  [momentum_z]
    type = GolemKernelM
    variable = dispz
    component = 2
    block = 'upper_sediments lower_sediments upper_granites lower_granites'
  []
  [darcy]
    type = GolemKernelH
    variable = pore_pressure
  []
  [storageH]
    type = GolemKernelTimeH
    variable = pore_pressure
  []
  [fourier]
    type = GolemKernelT
    variable = temperature
  []
  [storageT]
    type = GolemKernelTimeTSUPG
    variable = temperature
  []
  [advective]
    type = GolemKernelTHSUPG
    variable = temperature
  []
[]

[GolemMapStressAction]
 write_map = true
 file_name = 'map.csv'
 action_blocks = 'upper_sediments lower_sediments upper_granites lower_granites robertsau_fault'
 frac_blocks = 'robertsau_fault'
 index_i = '0 1 2 0 0 1'
 index_j = '0 1 2 1 2 2'
 # dimension = 3
 epsilon = 1e-4
 # max_leaf = 10
 patch_size = 100
 compute_ST = true
[]

# [DiracKernels]
#   [Injection]
#     type = GolemDiracKernelTH
#     variable = pore_pressure
#     source_point = '1805.9781494140625	3388.907958984375	-4198.39794921875'
#     source_type = injection
#     constant_rate = 6.9 #9.51 # So 100000 m3 is reached in 4 months (calculated with 1070 kg/m3 to kg)
#     # function_rate = injection_flowrate
#     start_time = 0#3.0
#     end_time = 1.5552e7 # 6 months
#   []
# []

[GlobalParams]
  supg_uo = supg
  pore_pressure = 'pore_pressure'
  temperature = 'temperature'
  displacements = 'dispx dispy dispz'
  gravity_acceleration = 9.80665
  scaling_uo = scaling
  porosity_uo = porosity_constant
  #permeability_uo = permeability_constant
  #fluid_density_uo = fluid_density_constant
  #fluid_viscosity_uo = fluid_viscosity_constant
  fluid_thermal_conductivity_uo = fluid_thermal_conductivity
  fluid_heat_capacity_uo = fluid_heat_capacity
  #fluid_thermal_expansion_uo = fluid_thermal_expansion
  fluid_modulus = 2.5e09
  #fluid_viscosity_initial = 0.00019 #Magnenet 2014
  #fluid_density_initial = 1070
  solid_thermal_expansion = 4.2e-5
[]

[Materials]
  [Upper_sediments]
    type = GolemMaterialTHMElasticSUPG
    block = 'upper_sediments'
    material_type = unit
    # Hydraulic data
    porosity_initial = 0.19
    permeability_initial = ${replace permeability_sediment_up}
    permeability_uo = permeability_time #permeability_constant
    solid_thermal_conductivity_uo = lambda_constant_up
    solid_density_uo = rho_constant_up
    solid_heat_capacity_uo = cp_constant_up
    # Fluid data
    fluid_viscosity_uo = etha_f
    fluid_density_uo = rho_f
    fluid_viscosity_initial = 0.00117 #Magri 2017
    fluid_density_initial = 1070 #Magnenet 2014
    #Mechanical properties
    young_modulus = 15e9
    poisson_ratio = 0.23
  []
  [Lower_sediments]
    type = GolemMaterialTHMElasticSUPG
    block = 'lower_sediments'
    material_type = unit
    # Hydraulic data
    porosity_initial = 0.12
    permeability_initial = ${replace permeability_sediment_low}
    permeability_uo = permeability_time #permeability_constant
    solid_thermal_conductivity_uo = lambda_constant_low
    solid_density_uo = rho_constant_low
    solid_heat_capacity_uo = cp_constant_low
    # Fluid data
    fluid_viscosity_uo = etha_f
    fluid_density_uo = rho_f
    fluid_viscosity_initial = 0.00117 #Magri 2017
    fluid_density_initial = 1070 #Magnenet 2014
    #Mechanical properties
    young_modulus = 15e9
    poisson_ratio = 0.23
  []
  [Upper_granites]
    type = GolemMaterialTHMElasticSUPG
    block = 'upper_granites'
    material_type = unit
    # Hydraulic data
    porosity_initial = 0.1 #Duda
    permeability_initial = ${replace permeability_granite_up}
    permeability_uo = permeability_time_granite #permeability_constant
    solid_thermal_conductivity_uo = lambda_constant_granite
    solid_density_uo = rho_constant_granite
    solid_heat_capacity_uo = cp_constant_granite
    # Fluid data
    fluid_viscosity_uo = etha_f
    fluid_density_uo = rho_f
    fluid_viscosity_initial = 0.00117 #Magri 2017
    fluid_density_initial = 1070 #Magnenet 2014
    #Mechanical properties
    young_modulus = 25e9 #25e9
    poisson_ratio = 0.25
  []
  [Lower_granites]
    type = GolemMaterialTHMElasticSUPG
    block = 'lower_granites'
    material_type = unit
    # Hydraulic data
    porosity_initial = 0.1 #Duda
    permeability_initial = ${replace permeability_granite_low}
    permeability_uo = permeability_time #permeability_constant
    #Solid data
    solid_thermal_conductivity_uo = lambda_constant_granite
    solid_density_uo = rho_constant_granite
    solid_heat_capacity_uo = cp_constant_granite
    # Fluid data
    fluid_viscosity_uo = etha_f
    fluid_density_uo = rho_f
    fluid_viscosity_initial = 0.00117 #Magri 2017
    fluid_density_initial = 1070 #Magnenet 2014
    #Mechanical properties
    young_modulus = 25e9 #25e9
    poisson_ratio = 0.20
  []
  [Faults]
     type = GolemMaterialTHMFracElasticSUPG
     block = 'robertsau_fault'
     material_type = 'frac'
     porosity_initial = 0.1
     permeability_initial = ${replace permeability_fault}
     permeability_uo = permeability_time_fault #permeability_constant
     fracture_aperture_uo = a_constant
     #Fluid data
     fluid_viscosity_uo = etha_f
     fluid_density_uo = rho_f
     fluid_viscosity_initial = 0.0017
     fluid_density_initial = 1070 
     #Mechanical properties
     young_modulus = 25e9
     poisson_ratio = 0.23
     normal_stress = sigma_n
     shear_stress = tau
  []
[]

[Functions]
  [Initial_temperature]
    type = ParsedFunction
    expression = 'T0-grad*z'
    symbol_names = 'T0 grad'
    symbol_values = '15 0.051'
  []
  [Initial_pressure]
    type = ParsedFunction
    expression = 'p0-rho_f*g*z'
    symbol_names = 'p0 rho_f g'
    symbol_values = '1079 101325 9.80665'
  []
  [perm]
    type = ParsedFunction
    expression = 'if(t < ${replace tau_1}, ${replace m}*t + 1e-18, ${replace permeability_sediment_up})'
  []
  [perm_granite_up]
    type = ParsedFunction
    expression = 'if(t < ${replace tau_1}, ${replace m_granite_up}*t + 1e-18, ${replace permeability_granite_up})'
  []
  [perm_fault]
    type = ParsedFunction
    expression = 'if(t < ${replace tau_1}, ${replace m_fault}*t + 1e-18, ${replace permeability_fault})'
  []
  [SH_disp_grad]
    type = ParsedFunction
    expression = 'SH_disp0 - SH_disp_grad * (z - z0)'
    symbol_names = 'SH_disp0 SH_disp_grad z0'
    #vals = '0.112 0.00111645 0'
    #symbol_values = '0.0 25000 0'
    #symbol_values = '0.0 24500 0'
    symbol_values = '-1.3e6 25000 0'
  []
  [Sh_disp_grad]
    type = ParsedFunction
    expression = 'Sh_disp0 - Sh_disp_grad * (z - z0)'
    symbol_names = 'Sh_disp0 Sh_disp_grad z0'
    #symbol_values = '0.0 15000 0'
    symbol_values = '-1.78e6 14450 0'
  []
[]

[BCs]
  [p_bc_atmospheric]
    type = DirichletBC
    variable = pore_pressure
    # boundary = 'west east south north'
    boundary = 'top'
    value = ${replace p_atm}
    #function = p_gradient
  []
  [T_TOP]
    type = DirichletBC
    variable = temperature
    boundary = 'top'
    value = ${replace T_top}
  []
  [T_BOTTOM]
    type = DirichletBC
    variable = temperature
    #function = T_bottom
    boundary = 'bottom'
    value = ${replace T_bottom}
  []
  [load_z_bottom]
    type = DirichletBC
    boundary = 'bottom'
    variable = dispz
    value = 12.8#6.35 #7.4#7.5#8#4#5.5#7.75 #7.5 (bit too low) #10(too much) #5 #2.5#0.0
  []
  [load_z_top]
    type = DirichletBC
    boundary = 'top'
    variable = dispz
    value = -12.8#-6.35 #-7.4#-7.5#-8#-4#-5.5#-7.75 #-7.5 #-10 #-5 #-2.5#-1
  []
  # x loading
  [load_x_west] # Sh
    type = FunctionNeumannBC
    #type = DirichletBC
    boundary = 'west'
    variable = dispx
    #value = 0.0
    function = Sh_disp_grad
  []
  [load_x_east]
    #type = FunctionNeumannBC
    type = DirichletBC
    boundary = 'east'
    variable = dispx
    #function = Sh_disp_grad
    value = 0.0
  []
  # y loading
  [load_y_south] # SH
    type = FunctionNeumannBC
    #type = DirichletBC
    boundary = 'south'
    variable = dispy
    function = SH_disp_grad
    #value = 0.0
  []
  [load_y_north]
    #type = FunctionNeumannBC
    type = DirichletBC
    boundary = 'north'
    variable = dispy
    #function = SH_disp_grad
    value = 0.0
  []
[]

[UserObjects]
  [scaling]
    type = GolemScaling
    #characteristic_stress = 1e6
    execute_on = 'INITIAL'
  []
  [supg]
    type = GolemSUPG
    execute_on = 'INITIAL'
  []
  # [fluid_density_constant]
  #   type = GolemFluidDensityConstant
  #   execute_on = 'INITIAL'
  # []
  # [fluid_viscosity_constant]
  #   type = GolemFluidViscosityConstant
  #   execute_on = 'INITIAL'
  # []
  [database]
    type = GolemFluidPropertiesFromCSVTable
    fluid_property_file = 'database_magri_strasbourg_525.csv'
    interpolated_properties = 'rho eta'
    force_range = true
    num_p = 10
    num_T = 400
    temperature_min = 273
    temperature_max = 700
    pressure_min = 0
    pressure_max = 1e7
    execute_on = 'INITIAL'
    execution_order_group = -1
  []
  [rho_f]
    type = GolemFluidDensityFromCSVTable
    fluid_property_uo = database
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
  []
  [etha_f]
    type = GolemFluidViscosityFromCSVTable
    fluid_property_uo = database
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
  []
  [fluid_heat_capacity]
    type = GolemFluidHeatCapacityConstant
    value = 4184 #3703.3
    execute_on = 'INITIAL'
  []
  [fluid_thermal_conductivity]
    type = GolemFluidThermalConductivityConstant
    value = 0.65
    execute_on = 'INITIAL'
  []
  [porosity_constant]
    type = GolemPorosityConstant
    execute_on = 'INITIAL'
  []
  [permeability_time]
    type = GolemPermeabilityFunction
    function = perm
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
  []
  [permeability_time_granite]
    type = GolemPermeabilityFunction
    function = perm_granite_up
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
  []
  [permeability_time_fault]
    type = GolemPermeabilityFunction
    function = perm_fault
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
  []
  # Upper sediments
  [lambda_constant_up]
    type = GolemSolidThermalConductivityConstant
    value = 0.6 #Vallier 2019
    execute_on = 'INITIAL'
  []
  [cp_constant_up]
    type = GolemSolidHeatCapacityConstant
    value = 800
    execute_on = 'INITIAL'
  []
  [rho_constant_up]
    type = GolemSolidDensityConstant
    value = 2390 #Magnenet 2014
    execute_on = 'INITIAL'
  []
  #Lower sediments
  [lambda_constant_low]
    type = GolemSolidThermalConductivityConstant
    value = 1.7 #Vallier 2019
    execute_on = 'INITIAL'
  []
  [cp_constant_low]
    type = GolemSolidHeatCapacityConstant
    value = 800
    execute_on = 'INITIAL'
  []
  [rho_constant_low]
    type = GolemSolidDensityConstant
    value = 2390 #Magnenet 2014
    execute_on = 'INITIAL'
  []
  #Granite
  [lambda_constant_granite]
    type = GolemSolidThermalConductivityConstant
    value = 1.7 #Vallier 2019
    execute_on = 'INITIAL'
  []
  [cp_constant_granite]
    type = GolemSolidHeatCapacityConstant
    value = 800
    execute_on = 'INITIAL'
  []
  [rho_constant_granite]
    type = GolemSolidDensityConstant
    value = 2630 #Magnenet 2014 #2850 #2593 #2390
    execute_on = 'INITIAL'
  []
  [a_constant]
    type = GolemFractureApertureConstant
    value = 1e-2 #(Gergo)#1.08826e-6
    execute_on = 'INITIAL'
  []
[]

[VectorPostprocessors]
  [sampling]
    type = GolemElementValueSampler
    variable = 'sigma_n tau ST stress_xx stress_yy stress_zz stress_xy stress_xz stress_yz'
    block = 'robertsau_fault'
    outputs = 'csv'
    sort_by = z
    out_type = elem_centroid
    centroid_type = vertex_average
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [point_C]
    type = LineValueSampler
    outputs = 'csv'
    variable = temperature
    start_point = '825 219 -43'
    end_point = '825 219 -9990'
    num_points = 2000
    sort_by = z
    execute_on = 'TIMESTEP_END'
    use_interpolated_state = True
  []
  [point_A]
    type = LineValueSampler
    outputs = 'csv'
    variable = temperature
    start_point = '-700 -2283 -43'
    end_point = '-700 -2283 -9990'
    num_points = 2000
    sort_by = z
    execute_on = 'TIMESTEP_END'
    use_interpolated_state = True
  []
  [point_B]
    type = LineValueSampler
    outputs = 'csv'
    variable = temperature
    start_point = '-700 2217 -43'
    end_point = '-700 2217 -9990'
    num_points = 2000
    sort_by = z
    execute_on = 'TIMESTEP_END'
    use_interpolated_state = True
  []
  [point_E]
    type = LineValueSampler
    outputs = 'csv'
    variable = temperature
    start_point = '2300 2717 -43'
    end_point = '2300 2717 -9990'
    num_points = 2000
    sort_by = z
    execute_on = 'TIMESTEP_END'
    use_interpolated_state = True
  []
[]

[Preconditioning]
  active = 'FSP'
  [hypre]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew -snes_converged_reason -ksp_converged_reason' # -ksp_gmres_modifiedgramschmidt -ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-snes_linesearch_type -snes_linesearch_maxstep -sneslinesearch_minlambda
                           -snes_atol -snes_rtol -snes_max_it
                           -pc_type -pc_hypre_type
                           -ksp_type -ksp_rtol -ksp_max_it'
    petsc_options_value = 'basic 2e12 1e-3
                           1e-10 1e-14 200
                           hypre boomeramg
                           bcgs 1e-12 500'
  []
  [FSP]
    type = FSP
    full = true
    topsplit = 'THM'
    [THM]
      splitting = 'H T M'
      splitting_type = additive
      petsc_options = ' -snes_monitor'
      petsc_options_iname = '-ksp_type
                             -ksp_rtol -ksp_max_it
                             -snes_type -snes_linesearch_type
                             -snes_atol -snes_stol -snes_max_it'
      petsc_options_value = 'fgmres
                             1.0e-12 100
                             newtonls basic
                             1e-3 0 1000'
    []
    [H]
      vars = 'pore_pressure'
      petsc_options_iname = '-ksp_type
                             -pc_type -pc_hypre_type
                             -ksp_rtol -ksp_max_it'
      petsc_options_value = 'fgmres
                             hypre boomeramg
                             1.0e-4 1000'
    []
    [T]
      vars = 'temperature'
      petsc_options_iname = '-ksp_type
                             -pc_type -sub_pc_type -sub_pc_factor_levels
                             -ksp_rtol -ksp_max_it'
      petsc_options_value = 'fgmres
                             asm ilu 1
                             5e-3 1000'
    []
    [M]
      vars = 'dispx dispy dispz'
      petsc_options_iname = '-ksp_type
                             -pc_type -sub_pc_type -sub_pc_factor_levels
                             -ksp_rtol -ksp_max_it'
      petsc_options_value = 'fgmres
                             asm ilu 1
                             1.0e-4 1000'
    []
  []
[]

#############################################################
##################### EXECUTIONER ###########################
#############################################################

[Executioner]
  type = Transient
  solve_type = NEWTON
  start_time = 0.0
  end_time = ${replace tau_2}
  automatic_scaling = true
  compute_scaling_once = false
  steady_state_detection = true
  steady_state_start_time = 3.2e11
  steady_state_tolerance = 1e-14
  [TimeSteppers]
    [itdt]
      type = IterationAdaptiveDT
      dt = 1e8
      cutback_factor = 0.5
      growth_factor = 2
      optimal_iterations = 13
      reject_large_step = false
    []
  []
[]

#############################################################
####################### OUTPUTS #############################
#############################################################

[Outputs]
  print_linear_residuals = false
  file_base = 'THM_coarse_model6'
  exodus = 'true'
  csv = 'true'
[]

[Debug]
  show_var_residual_norms = true
[]
