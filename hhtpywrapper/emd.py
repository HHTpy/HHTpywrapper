from pymatbridge import Matlab
import os

mlab = Matlab()
mlab.start()
dir_path = os.path.dirname(os.path.realpath(__file__))
dir_list = ['/Input_data', '/HHT_MATLAB_package', '/HHT_MATLAB_package/EMD',
          '/HHT_MATLAB_package/checkIMFs', '/HHT_MATLAB_package/HT']
for d in dir_list:
    res = mlab.run_func('addpath', dir_path + d)

class EMD():
    def __init__(self, signal, Nstd, NE, num_imf=10, run_CEEMD=1, max_sift=10,
                 type_spline=2, modify_BC=1, rand_type=2, seed_no=1,
                 check_signal=1):
        res = mlab.run_func('feemd_post_pro', signal, Nstd, NE, num_imf,
                            run_CEEMD, max_sift, type_spline, modify_BC,
                            rand_type, seed_no, check_signal)
        self.imfs = res['result']

    def get_oi(self):
        oi = mlab.run_func('ratio1', self.imfs)
        oi_pair = mlab.run_func('ratioa', self.imfs)
        oi_dic = {'Non-orthogonal leakage of components': oi['result'],
                  'Non-orthogonal leakage for pair of adjoining components': oi_pair['result']}
        return oi_dic
