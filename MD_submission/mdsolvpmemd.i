MD heating of solvent with restraints for solute 
&cntrl
 imin=0, irest=0, ntx=1,
 nstlim=25000, dt=0.001,
 ntpr=500, ntwx=500, ioutfm=1,
 ntb=2, cut=10.0, 
 ntc=2, ntf=2,
 ntt=1, tautp=1.0, tempi=50.0, temp0=300.0,
 ntp=1, taup=1.0, pres0=1.0,  
 ntr=1, restraint_wt=25.0, restraintmask='!:WAT,SOD,CLA'
&end
&ewald
 skinnb=3.0
&end
