from pymatbridge import Matlab
import matplotlib.pylab as plt
import os

mlab = Matlab()
mlab.start()
dir_path = os.path.dirname(os.path.realpath(__file__))
dir_list = ['/Input_data', '/HHT_MATLAB_package', '/HHT_MATLAB_package/EMD',
          '/HHT_MATLAB_package/checkIMFs', '/HHT_MATLAB_package/HT']
for d in dir_list:
    res = mlab.run_func('addpath', dir_path + d)

class EEMD():
    def __init__(self, signal, Nstd, NE, num_imf=10, run_CEEMD=1, max_sift=10,
                 type_spline=2, modify_BC=1, rand_type=2, seed_no=1,
                 check_signal=1, post_processing=False):
        if post_processing == True:
            eemd = 'feemd_post_pro'
        else:
            eemd = 'eemd'
        res = mlab.run_func(eemd, signal, Nstd, NE, num_imf,
                            run_CEEMD, max_sift, type_spline, modify_BC,
                            rand_type, seed_no, check_signal)
        if post_processing == True:
            self.imfs = res['result'].T
        else:
            self.imfs = res['result']
        self.input_signal = signal
        self.num_imf = num_imf

    def get_oi(self):
        oi = mlab.run_func('ratio1', self.imfs.T)
        oi_pair = mlab.run_func('ratioa', self.imfs.T)
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
            plt.plot(time, self.imfs[i])
        plt.show()

    def plot_imfs_significance(self, imfs, savefig_name=''):
        n_imf, n_pt = imfs.shape
        if n_pt < n_imf:
            imfs = imfs.T
            n_imf, n_pt = imfs.shape
        res_logep = mlab.run_func('significanceIMF', imfs[:-1].T)
        logep = res_logep['result']
        mlab.run_code('sigline90=confidenceLine(0.10,' + str(n_pt) + ');' +
                      'sigline95=confidenceLine(0.05,' + str(n_pt) + ');' +
                      'sigline99=confidenceLine(0.01,' + str(n_pt) + ');')
        sigline90 = mlab.get_variable('sigline90')
        sigline95 = mlab.get_variable('sigline95')
        sigline99 = mlab.get_variable('sigline99')
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
