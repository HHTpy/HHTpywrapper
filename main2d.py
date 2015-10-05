from pymatbridge import Matlab
import HHTplots

#  Parameters Setting
filename = './Input_data/example_lena.png'
npixs = 512
Nstd = 0.4
NE = 20
seedNo = 1
numImf = 6
runCEEMD = 1
maxSift = 10
typeSpline = 2
toModifyBC = 1
randType = 2
checksignal = 1

##
mlab = Matlab()
mlab.start()
mlab.run_code('addpaths')

# Fast 2dEEMD
res = mlab.run_func('meemd', filename, npixs, Nstd, NE, numImf, runCEEMD,
                    maxSift, typeSpline, toModifyBC, randType, seedNo,
                    checksignal)
imfs = res['result']

# Plot Results
HHTplots.example_lena(filename, imfs)

mlab.stop()
