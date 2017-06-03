from pymatbridge import Matlab
import matplotlib.pylab as plt
import os
import numpy as np

mlab = Matlab()
mlab.start()
dir_path = os.path.dirname(os.path.realpath(__file__))
dir_list = ['/HHT_MATLAB_package', '/HHT_MATLAB_package/EEMD',
          '/HHT_MATLAB_package/checkIMFs', '/HHT_MATLAB_package/HSA']
for d in dir_list:
    res = mlab.run_func('addpath', dir_path + d)

class HSA():
    def __init__(self, imfs, dt, ifmethod='hilbtm', normmethod='pchip', nfilter=0):
        fa_res = mlab.run_func('fa', imfs, dt, ifmethod, normmethod, nfilter, nargout=2)
        fa = fa_res['result']
        self.ifreq = fa[0].T.reshape(-1)
        self.iamp = fa[1].T.reshape(-1)
