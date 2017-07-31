from pymatbridge import Matlab
import os

def start_mlab():
    dir_path = os.path.dirname(os.path.realpath(__file__))
    dir_list = ['/HHT_MATLAB_package', '/HHT_MATLAB_package/EEMD',
                '/HHT_MATLAB_package/checkIMFs', '/HHT_MATLAB_package/HSA']
    mlab = Matlab()
    mlab.start()
    for d in dir_list:
        res = mlab.run_func('addpath', dir_path + d)
    return mlab
