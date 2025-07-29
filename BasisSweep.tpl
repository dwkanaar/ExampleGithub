<?xml version="1.0" standalone="no" ?>
<RunFCIexec_ParameterListArray>

<RunParameters>
<threadCount value = "16" />
<runOrbitalBasisFlag           value = "false"  type = "bool" />
<runOrbitalIntegralsFlag       value = "false"  type = "bool"  />
<runFCIflag                    value = "true"  type = "bool"  />
<orbitalFileCreation           value = "false"  type = "bool" /> 
<integralsFileCreation         value = "false"  type = "bool" />
<potentialType                 value = "USER_SPECIFIED" type = "string" />  <!-- One of USER_SPECIFIED, DOUBLE_QDOT, TIGHT_BINDING --> 
<kineticOpType                 value = "FD2D_SPECTRALZ_TB"          type = "string" />  <!-- FD2D_SPECTRALZ_TB One of FD_3D, SPECTRAL_3D, FD2D_SPECTRALZ, A04_TB, SPECTRAL_3D_TB, FD2D_SPECTRALZ_TB} -->
<subspaceInfoOutput            value = "false" type = "bool" />
<FCIdensityOutput              value = "false"  type = "bool" />
<FCIspinDensityOutput          value = "false"  type = "bool" />
<detailedFCIoutput             value = "false" type = "bool" />
</RunParameters>

<!--  State indexing starts at 0  -->
<FCIdensity>
<densitySpecifier>
<spinDesignator value = "UUDDD" type = "string"/>
<stateCount     value = "1"  type = "int" />  
</densitySpecifier>
<densitySpecifier>
<spinDesignator value = "UDDDD" type = "string"/>
<stateCount     value = "1"  type = "int" />  
</densitySpecifier>
<VTKthreshold       value = "1.0e-35" />
</FCIdensity>


<InputOutputFiles>
<orbitalBasisDirectory       value =  "/u/home/d/dwkanaar/MaSQE/Testing/FCIexec/potentials"  />
<orbitalBasisFile            value = "OrbBasisAnis1.dat" />
<orbitalIntegralsDirectory   value =  "/u/home/d/dwkanaar/MaSQE/Testing/FCIexec/potentials"   />
<orbitalIntegralsFile        value = "OrbIntegralsAnis1.dat" />
</InputOutputFiles>

<!--  Schroedinger Operator Specification  -->

<SchroedingerOp>
<materialName value = "TestMaterial" type = "string"/>

<KineticEnergyOp>
<opOrder          value = "6"   type = "int"  />
<k0 value = "9.486636887951278" type= "double"/>
</KineticEnergyOp>

</SchroedingerOp>


<PotentialOutput>
<vtkOutputFlag              value = "true" type = "bool"/>
<VTKscalingFactor           value = "-1" />
<VTKthreshold               value = "1.0e-35" />
<midSliceOutputFlag         value = "false" type = "bool" /> <!--  Output 2d slices at index = [X,Y,Z]panels/2 -->
</PotentialOutput>

<!--   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX            -->
<!--               USER_SPECIFIED potential parameters                              -->
<!--   Symbolically defined or file specified potentials                     -->
<!--   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX            -->

<DevicePotential>
<potentialFileName          value = "./potentials/AsymPotential3.dat" type = "string"/>
<symbolicPotentialFlag      value = "false" />
<symbolicPotentialParamList value = "ParabolicPotential" />
</DevicePotential>

<ComputationalDomain>
<xMin value = "-50.0"/>
<xMax value =  "50.0"/>
<yMin value = "-50.0"/>
<yMax value =  "50.0"/>
<zMin value = "-10.0"/>
<zMax value =  "10.0"/>
</ComputationalDomain>	

<GridParameters>
<xPanelDensity  value = "0.2"  />   <!-- x panels per nm -->
<yPanelDensity  value = "0.2" />    <!--  y panels per nm -->
<zPanelDensity  value = "2.0"  />   <!-- z panels per nm -->
</GridParameters>

<!--                                            -->
<!--  Specification of symbolic potential       -->
<!--                                            -->

<ParabolicPotential>

<functionString value = "a*x^2 + b*y^2 + c*z^2" type ="string" />

<!--  variables : specify variable name and value = coordinate index  -->

<variables>
<x value = "1" /> 
<y value = "2" />
<z value = "3" />
</variables>

<!-- symbolic constants (i.e. coefficients) with values -->

<symbolicConstants>
<a value      = "1.0e-05"  />
<b value      = "1.0e-05"  />  
<c value      = "1.0e-03"  />
</symbolicConstants>
</ParabolicPotential>


<!--   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       -->
<!--               DOUBLE_QDOT potential parameters                     -->
<!--          Parameters for double quantum dot potential               -->
<!--   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       -->


<DoubleQdotParameters>

<bandShift value = "-0.238" /> 

<GateBias> <!--  bias Voltage (eV)  -->
<VP1        value = "0.25" type="double" />
<VX         value = "0.05" type="double" />
<VP2        value = "0.25" type="double" />
</GateBias>

<VerticalParameters>
<zBar       value    = "70"  /> <!--  distance to center of quantum well  -->
<zWellWidth value    = "5.0" />
<zBufferWidth value  = "5.0" /> 
<zPanelDensity value = "4.0" /> <!-- Use an integral number to insure a uniform mesh -->
</VerticalParameters>

<TransverseParameters>
<a                         value =  "35.0" />  <!-- width of square gates   -->
<xMin                      value = "-150.0"/>
<xMax                      value =  "150.0"/>
<yMin                      value = "-150.0"/>
<yMax                      value =  "150.0"/>
<xPanelDensity             value = ".05"  />  <!-- x panels per nm -->
<yPanelDensity             value = ".05"  /> <!--  y panels per nm -->
<FFTquantizationFlag       value = "true" type = "bool" /> 
</TransverseParameters>

</DoubleQdotParameters>


<!--  Orbital Basis Parameters  -->

<ConfinementParameters>
<zBoundarySmoothingPanels            value  = "4" type = "int"/>
<xyBoundaryRelativeSmoothingDistance value = "0.25" />
<boundarySmoothingDifferentiability  value = "4" />
<vtkOutputFlag                       value = "false" type = "bool"/>
<VTKscalingFactor                    value = "-1" />
<VTKthreshold                        value = "1.0e-35" />
</ConfinementParameters>

<OrbitalBasis>
<basisCount          value = "60" />
<barrierFunctionFlag value = "false" />
<verboseFlag value = "true" type = "bool"/>
<EigensystemParameters>
		<subspaceIncrementSize value = "60" />
		<bufferSize            value = "45" />
		<subspaceTol           value = "1.0e-5" />
		<maxSpectralBoundsIter  value = "10000" />
		<spectralBoundsTol     value = "1.0e-04" />   <!--  If not specified uses value 0.01                 -->
        <minEigEstimationTol   value = "1.0e-04"  />  <!--  If not specified, uses value of spectralBoundsTol-->
        <maxEigEstimationTol   value = "2.0e-05" />   <!--  If not specified, uses value of spectralBoundsTol-->
		<polyDegreeBound       value = "100" />
        <stopCondition value = "COMBINATION" type = "string" /> <!-- one of DEFAULT,COMBINATION,RESIDUAL_ONLY,EIGENVALUE_ONLY -->
</EigensystemParameters>
<outputBasisVTKflag            value = "false" />
<outputBasisDataflag            value = "false" /> <!--Count is the same as VTKcount-->
<outputBasisVTKcount           value = "5"    />
<VTKthreshold                 value = "1.0e-35" />
</OrbitalBasis>

<OrbitalIntegrals>
<verboseFlag          value = "true"  type = "bool"/>
<basisCount           value = "60"      type = "int"/>
<useArrayOfOps        value = "false" type = "bool"/>
<explicitSymmetryFlag value = "false" type = "bool"/>
</OrbitalIntegrals>

<RunFCI>
<verboseFlag value = "true" type = "bool"/>
<electronCount    value = "5" />                       <!-- Number of electrons -->
<spatialOrbitalBasisCount value = "$BasisSize" />               <!-- Number of orbital basis functions used (<= basisCount)   -->
<stateCountMax value = "$BasisSize"  />                        <!-- Maximal number of states to determine in each spin block -->
<energyShift   value = "0.0" />
<eeFactor      value = "1.0" />
<dropTolerance       value = "1.0e-8" />                  <!-- Elements with magnitude below dropTolerance not added to Hamiltonian  -->
<energyDecomposition value = "false" />                <!-- Construct energy  decomposition : Warning! causes large memory footpring -->
<EigensystemParameters>
		<verboseDiagonlizationFlag value = "true" type="bool"/> <!-- Output progress to screen -->
		<subspaceIncrementSize  value = "$BasisSize" />                  <!-- Eigensystem computational subspace size (Rayleigh-Chebyshev) -->
		<bufferSize    value = "30" />                            <!-- Subspace buffer size                    (Rayleigh-Chebyshev) -->
		<subspaceTol   value = "1.0e-8" />                      <!-- Eigenvalue subspace tolerance           (Rayleigh-Chebyshev) -->
		<maxSpectralBoundsIter  value = "5000" />
		<spectralBoundsTol     value = "1.0e-03" />
		<polyDegreeBound       value = "200" />
		<largeMatrixFlag value = "true" />                      <!-- Set true for smaller memory allocation  (Rayleigh-Chebyshev) -->
		<stopCondition value = "COMBINATION" type = "string" /> <!-- one of DEFAULT,COMBINATION,RESIDUAL_ONLY,EIGENVALUE_ONLY -->
</EigensystemParameters>
</RunFCI>



<!--  Material properties specification  -->

<MaterialDataSource>
<materialSource  value = "Material"     type = "string" /> 
<!--  Acceptable materialSource specification                    -->
<!--  Material     (single "Material" parameter list)   -->
<!--  MaterialList ("MaterialList"    parameter list )   -->
<!--  SQLite database file (*.db) name                  -->
</MaterialDataSource>

<Material>
<name value                      = "TestMaterial" />
<dielectricConstant value        = "11.7"     />
<effectiveMass_x value           = "0.19"     />
<effectiveMass_y value           = "0.19"     />
<effectiveMass_z value           = "0.9"      />
<bandShift value                 = " -0.2376"  /> <!--  -0.2376  -->
<backgroundDopingDensity value   = "0.0"      />
</Material>



</RunFCIexec_ParameterListArray>

