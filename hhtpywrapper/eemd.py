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

class EEMD():
    def __init__(self, signal, Nstd, NE, num_imf=0, run_CEEMD=1, max_sift=10,
                 type_spline=2, modify_BC=1, rand_type=2, seed_no=1,
                 check_signal=1, post_processing=False):
        res = mlab.run_func('eemd', signal, Nstd, NE, num_imf,
                            run_CEEMD, max_sift, type_spline, modify_BC,
                            rand_type, seed_no, check_signal)
        allmode = res['result'].T
        num_imf = allmode.shape[1]
        if post_processing == True:
            imfs = np.zeros((len(signal), num_imf))
            remainder = 0
            for i in range(num_imf-1):
                res2 = mlab.run_func('eemd', allmode[:,i] + remainder, 0, 1, num_imf)
                imfs_temp = res2['result'].T
                imfs[:,i] = imfs_temp[:,0]
                remainder = allmode[:,i] + remainder - imfs[:,i]
            imfs[:,-1] = remainder + allmode[:,-1]
        else:
            imfs = allmode
        self.imfs = imfs
        self.input_signal = signal
        self.num_imf = num_imf

    def get_oi(self):
        oi = mlab.run_func('ratio1', self.imfs)
        oi_pair = mlab.run_func('ratioa', self.imfs)
        oi_dic = {'Non-orthogonal leakage of components': oi['result'],
                  'Non-orthogonal leakage for pair of adjoining components': oi_pair['result']}
        return oi_dic

    def plot_imfs(self, time):
        num_subplot = self.num_imf + 1
        plt.figure()
        plt.subplot(num_subplot, 1, 1)
        plt.plot(time, self.input_signal)
        for i in range(self.num_imf):
            plt.subplot(num_subplot, 1, i + 2)
            plt.plot(time, self.imfs[:,i])
        plt.show()

    def plot_imfs_significance(self, imfs, savefig_name=''):
        n_pt, n_imf = imfs.shape
        if n_pt < n_imf:
            imfs = imfs.T
            n_pt, n_imf = imfs.shape
        res_logep = mlab.run_func('significanceIMF', imfs[:,:-1])
        logep = res_logep['result']
        mlab.run_code('sigline90=confidenceLine(0.10,' + str(n_pt) + ');' +
                      'sigline95=confidenceLine(0.05,' + str(n_pt) + ');' +
                      'sigline99=confidenceLine(0.01,' + str(n_pt) + ');')
        sigline90 = mlab.get_variable('sigline90')
        sigline95 = mlab.get_variable('sigline95')
        sigline99 = mlab.get_variable('sigline99')
        plt.figure()
        plt.plot(sigline90[:,0], sigline90[:,1], 'k',
                 sigline95[:,0], sigline95[:,1], 'b',
                 sigline99[:,0], sigline99[:,1], 'r')
        plt.legend(('90% significance', '95% significance', '99% significance'), loc=3)
        plt.plot(logep[:,0], logep[:,1], 'g.')
        plt.xlabel('Log-T, Period of the IMFs (log)')
        plt.ylabel('Log-E, Energy of the IMFs (log)')
        if savefig_name == '':
            plt.show()
        else:
            plt.savefig(savefig_name, format='eps', dpi=1000)
