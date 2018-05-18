import numpy as np
import matplotlib.pyplot as plt

y,T,Ux,Uy = np.loadtxt('postProcessing/singleGraph/622/line_T_Ux_Uy.xy',delimiter='\t',dtype=np.float,unpack=True)
z,Uueh,Tueh,Ukim,Tkim,Uxie,Txie = np.loadtxt('xie-2006-data.csv',delimiter=',',dtype=np.float,skiprows=1,unpack=True)

#Tf = T[1]
Tf = 300.02
#top = (np.abs(y-2.0)).argmin()
#Ta = T[top]
Ta = 300
U0 = 0.056
#U0 = Ux[top]
theta = (T-Tf)/(Ta-Tf)
y0 = y/1.0
U0 = Ux/U0

plt.subplot(1,2,1)
plt.plot(theta,y0,'r',label='This study, Rb = -0.21')
plt.plot(Tueh,z,'bo',label='Uehara et al 2000, Rb = -0.21')
plt.plot(Tkim,z,'k^',label='Kim & Baik 2001, Rb = -0.27')
plt.plot(Txie,z,'gD',label='Xie et al 2006, Rb = -0.21')
plt.xlabel(r'$\theta$')
plt.ylabel('y/H')
plt.xlim((-0.1,1.2))
plt.ylim((0.0,2.0))
plt.legend(loc=2)

plt.subplot(1,2,2)
plt.plot(U0,y0,'r')
plt.plot(Uueh,z,'bo')
plt.plot(Ukim,z,'k^')
plt.plot(Uxie,z,'gD')
plt.xlabel('Ux/U0')
plt.ylabel('y/H')
plt.ylim((0.0,2.0))

#print(Ta,Tf,np.average(T[0:top]),Ux[top])

plt.show()
