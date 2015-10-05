import numpy as np
from pymatbridge import Matlab
import HHTplots

#  Parameters Setting
filename = './Input_data/example_qpo.txt'
Nstd = 6
NE = 100
seedNo = 50
numImf = 10
runCEEMD = 1
maxSift = 10
typeSpline = 2
toModifyBC = 1
randType = 2
checksignal = 1

##
data = np.loadtxt(filename)
time = data[:, 0]
amp = data[:, 1]
dt = time[1] - time[0]

##
mlab = Matlab()
mlab.start()
mlab.run_code('addpaths')

# Fast EEMD
res = mlab.run_func('feemd_post_pro', amp, Nstd, NE, numImf, runCEEMD, maxSift,
                    typeSpline, toModifyBC, randType, seedNo, checksignal)
imfs = res['result']


# Orthogonality Checking
oi = mlab.run_func('ratio1', imfs)
oi_pair = mlab.run_func('ratioa', imfs)
print('Non-orthogonal leakage of components:')
print(oi['result'])
print('Non-orthogonal leakage for pair of adjoining components:')
print(oi_pair['result'])

# Hilbert Transform
fa_res = mlab.run_func('fa', imfs[:, 3], dt, 'hilbtm', 'pchip', 0, nargout=2)
fa = fa_res['result']
ifreq = np.transpose(fa[0])
iamp = np.transpose(fa[1])

# Plot Results
HHTplots.example_qpo(time[4001:5000], amp[4001:5000], imfs[4001:5000, 3],
                      ifreq[4001:5000], iamp[4001:5000])

mlab.stop()
